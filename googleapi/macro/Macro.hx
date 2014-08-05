package googleapi.macro;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.Metadata;

/**
 * ...
 * @author Kevin
 */
class Macro
{
	public static function build():Array<Field>
	{
		var fields = Context.getBuildFields();
		
		var fieldsToPush:Array<Field> = [];
		
		for (field in fields)
		{
			if (hasMeta(field, ":cache"))
			{
				for(f in buildCache(field))
					fieldsToPush.push(f);
			}
			
			if (hasMeta(field, ":rest"))
			{
				buildFunctionBody(field);
			}
			
		}
		
		return fields.concat(fieldsToPush);
	}
	
	private static function hasMeta(field:Field, name:String):Bool
	{
		for (m in field.meta)
			if (m.name == name) return true;
		
		return false;
	}
	
	private static function buildFunctionBody(field:Field)
	{
		// Read the metadata
		var cached = hasMeta(field, ":cache");
		
		var restMeta = field.meta.filter(function(meta) return meta.name == ":rest")[0];
		var scope = restMeta.params[0];
		var url = restMeta.params[1];
		var method = restMeta.params[2];	
		
		// get the function body
		var func = getFunction(field);
		var funcBodyBlockExprs = getFunctionBodyBlockExprs(field);
		
		// function body expressions...
		var urlSection = [];
		
		var varSection = [];
		var varInited = false;
		
		var indexSection = []; // cache index
		if (cached) indexSection.push(macro var indexBuf:Array<String> = []);
		
		// Parameters
		urlSection.push(macro var url = $url);
		var pathParamMetas = field.meta.filter(function(meta) return meta.name == ":pathParam");
		for (m in field.meta)
		{
			if (m.name == ":pathParam")
			{
				var restParamName = getConstantString(m.params[0]);
				
				// Append the param name in the url
				urlSection.push(macro url += "/" + $v{restParamName});
				
				// if we need to add an argument for the function...
				if (m.params.length > 1)
				{
					var argName = getConstantString(m.params[1]);
					var argType = composeType(getConstantString(m.params[2]));
					
					// Create a parameter for the method
					addFunctionArgument(func, argName, argType);
					
					// Append the param value in the url
					urlSection.push(macro url += "/" + $i{argName} );
					
					// Compose the cache index
					if (cached) indexSection.push(macro indexBuf.push(Std.string($i{argName})));
				}
			}
			else if (m.name == ":queryParam")
			{				
				if (!varInited)
				{
					varSection.push(macro var variables = new openfl.net.URLVariables());
					varInited = true;
				}
				
				var argName = getConstantString(m.params[0]);
				var argType = composeType(getConstantString(m.params[1]));
				var defaultValue = m.params[2];
				
				// Create a parameter for the method
				addFunctionArgument(func, argName, argType, defaultValue);
				
				// Add the parameter to the URLVariable
				trace(argName, defaultValue);
				if (defaultValue != null)
					varSection.push(macro if($i{argName} != $defaultValue) $p{["variables", argName]} = $i{argName});
				else
					varSection.push(macro $p{["variables", argName]} = $i{argName});
				
				// Compose the cache index
				if (cached) indexSection.push(macro indexBuf.push(Std.string($i{argName})));
			}
		}
		
		// the REST-call expr
		var restCallExpr = method == null ? (macro Rest.call($scope, url, variables)) : (macro Rest.call($scope, url, variables, $method));
		
		// Construct the whole function body
		if (cached) // if this field is cached, add a if-block to check if the cache already exist
		{
			var cacheName = getCacheName(field);
			indexSection.push(macro var index = indexBuf.join("-"));
			
			// the if-block expressions
			var blockExprs = [];		
			for (expr in urlSection) blockExprs.push(expr);
			for (expr in varSection) blockExprs.push(expr);
			blockExprs.push(macro $i{cacheName}.set(index, $restCallExpr));
			
			// the if-statement (plus the if-block)
			for (expr in indexSection) funcBodyBlockExprs.push(expr);
			funcBodyBlockExprs.push(macro if (!$i{cacheName}.exists(index)) $b{blockExprs});
			
			// the return-statement
			funcBodyBlockExprs.push(macro return $i{cacheName}.get(index));
		}		
		else // if this field is not cached, simply return the REST call
		{	
			for (expr in urlSection) funcBodyBlockExprs.push(expr);
			for (expr in varSection) funcBodyBlockExprs.push(expr);
			funcBodyBlockExprs.push(macro return $restCallExpr);
		}
	}
	
	private static function buildCache(field:Field):Array<Field>
	{
		var pos = Context.currentPos();
		
		// the variable name of the cache
		// e.g. function named list() will generate a cache named listCache
		var cacheName = getCacheName(field);
		
		// get the function body
		var funcBodyBlockExprs = getFunctionBodyBlockExprs(field);
		
		// add a statement at the beginning
		// e.g. 
		// if (getCache == null) getCache = new Map();
		funcBodyBlockExprs.unshift(macro if ($i { cacheName } == null) $i { cacheName } = new Map());
		
		
		// the return type of the function
		// will become the cache type
		var returnType = switch (field.kind) 
		{
			case FFun(_.ret => r): r;
			default: null;
		}
		
		if (returnType == null) throw "the cached rest api must have a return type";
		
		// declare the cache and the reset method
		// e.g. 
		// private static var cacheName:Map<String, returnType>;
		// and
		// public static function resetCacheName():Void cacheName = null;
		return [
			{
				name:cacheName, 
				access:[APrivate, AStatic], 
				kind:FVar(macro:Map<String, $returnType>, null), 
				pos:pos
			},
			{
				name:"reset" + cacheName.substr(0, 1).toUpperCase() + cacheName.substr(1, cacheName.length), 
				access:[APublic, AStatic, AInline], 
				kind:FFun({args:[], ret:macro:Void, expr:macro $i{cacheName} = null}),
				pos:pos
			},
		];
					
	}
	
	private static function addFunctionArgument(func:Function, argName:String, argType:ComplexType, ?defaultValue:Expr):Void
	{
		func.args.push( { name:argName, type: macro:$argType, value:defaultValue } );
	}
	
	private static function composeType(path:String):ComplexType
	{
		var a = path.split(".");
		var className = a.pop();
		return TPath( { name:className, pack:a } );
	}
	
	private static function getCacheName(field:Field):String
	{
		return field.name + "Cache";
	}
	
	/**
	 * Extract the String value of a CString or CIdent of a EConst Expr
	 * @param	expr
	 * @return
	 */
	private static function getConstantString(expr:Expr):String
	{
		return switch(expr.expr)
		{
			case EConst(c):
				switch(c)
				{
					case CString(s): s;
					case CIdent(i): i;
					default: null;
				}
			default: null;
		};
	}
	
	/**
	 * Extract the Function of a FFun Field
	 * @param	field
	 * @return
	 */
	private static function getFunction(field:Field):Function
	{
		return switch(field.kind)
		{
			case FFun(f): f;
			default: null;
		}
	}
	
	/**
	 * Extract the array of expr inside a the EBlock of a FFun Field
	 * Only works if the Function has a EBlock body
	 * @param	field
	 * @return
	 */
	private static function getFunctionBodyBlockExprs(field:Field):Array<Expr>
	{
		return switch (field.kind) 
		{
			case FFun(_.expr.expr => e): 
				switch(e)
				{
					case EBlock(b): b;
					default: null; 
				}
			default: null;
		}
	}
}