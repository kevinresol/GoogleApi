package googleapi ;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end

using tink.CoreApi;

class GoogleApi 
{
	public static inline var SCOPE_GAMES:String = "https://www.googleapis.com/auth/games";
	
	public static var debugCallback:String->Void;
	public static var ready:Surprise<Bool, Error> = init();
	
	private static var tokenCache:Map<String, Surprise<String, Error>> = new Map();
	
	public static function sampleMethod (inputValue:Int):Int {
		
		#if (android && openfl)
		
		var resultJNI = googleapi_sample_method_jni(inputValue);
		var resultNative = googleapi_sample_method(inputValue);
		
		if (resultJNI != resultNative) {
			
			throw "Fuzzy math!";
			
		}
		
		return resultNative;
		
		#else
		
		return googleapi_sample_method(inputValue);
		
		#end
	}
	
	
	public static function getToken(scope:String):Surprise<String, Error>
	{
		if (!tokenCache.exists(scope))
		{
			tokenCache[scope] = ready.flatMap(function(ready)
			{
				try
				{
					ready.sure();
					return Future.async(function(handler)		 
					{
						googleapi_get_token_jni( { handler:function(s:String) 
						{
							if (s.indexOf("failed") != -1)
								handler(Failure(new Error(s)));
							else
								handler(Success(s));
						} }, scope);
					});
				}
				catch (e:Error) // ready error (e.g. user does not authorize)
					return Future.sync(Failure(e));
			});
		}
		return tokenCache[scope];
	}
	
	public static function invalidateToken(token:String):Void
	{
		for (scope in tokenCache.keys())
		{
			tokenCache[scope].handle(function(t) try if (t.sure() == token) invalidateTokenByScope(scope) catch (e:Error) {});
		}
	}
	
	public static function invalidateTokenByScope(scope:String):Void
	{
		if (tokenCache.exists(scope))
		{
			tokenCache[scope].handle(function(t)
			{
				try
				{
					var token = t.sure();
					googleapi_invalidate_token_jni(token);
				}
				catch (e:Error)
				{
					
				}
				
				tokenCache.remove(scope);
			});
		}
	}
	
	private static function init():Surprise<Bool, Error>
	{
		return Future.async(function(handler)
		{
			var googleapi_init_jni = JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "init", "(Lorg/haxe/lime/HaxeObject;Lorg/haxe/lime/HaxeObject;)V");			
			var accountNameHandler = { handler:function(s:String) /* s is accountname if success*/ handler(s.indexOf("failed") != -1 ? Failure(new Error(s)) : Success(true)) };
			var debugHandler = { handler:function(s:String) if (debugCallback != null) debugCallback(s) };
			
			googleapi_init_jni(accountNameHandler, debugHandler);
		});
	}
	
	
	private static var googleapi_sample_method = Lib.load ("googleapi", "googleapi_sample_method", 1);
	private static var googleapi_init = Lib.load ("googleapi", "googleapi_sample_method", 1);
	
	#if (android && openfl)
	private static var googleapi_sample_method_jni:Int->Int 			= JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "sampleMethod", "(I)I");
	private static var googleapi_get_token_jni:Dynamic->String->Void 	= JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "getToken", "(Lorg/haxe/lime/HaxeObject;Ljava/lang/String;)V");
	private static var googleapi_invalidate_token_jni:String->Void 		= JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "invalidateToken", "(Ljava/lang/String;)V");
	#end
}