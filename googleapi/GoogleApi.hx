package googleapi ;
import flash.net.URLRequest;
import haxe.Json;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;

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
	public static inline var URI_GAMES:String = "https://www.googleapis.com/games/v1";
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
		googleapi_invalidate_token_jni(token);
	}
	
	public static function makeRawRestCall(scope:String, url:String, ?variables:URLVariables, post:Bool = false):Surprise<String, Error>
	{
		//TODO cache
		//ready -> getToken -> load url
		return getToken(scope).flatMap(function(outcome)	
		{
			try
			{
				if (variables == null)
					variables = new URLVariables();
				
				variables.access_token = outcome.sure();
				return Future.async(function(handler)
				{
					var request = new URLRequest(url + "?" + variables.toString());
					if (post) request.method = URLRequestMethod.POST;
					
					var loader = new URLLoader();
					loader.addEventListener(Event.COMPLETE, function(_) handler(Success(loader.data)));
					loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) handler(Failure(new Error(e.toString()))));
					loader.load(request);
				});
			}
			catch (e:Error) // token error (e.g. typo in scope)
				return Future.sync(Failure(e));
		});
	}
	
	public static function makeRestCall<T>(scope:String, url:String, ?variables:URLVariables, post:Bool = false):Surprise<T, Error>
	{
		return makeRawRestCall(scope, url, variables, post).map(function(outcome)
		{
			try
				return Success(Json.parse(outcome.sure()))
			catch (e:Error)
				return Failure(e);
		});
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
	private static var googleapi_sample_method_jni = JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "sampleMethod", "(I)I");
	private static var googleapi_get_token_jni = JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "getToken", "(Lorg/haxe/lime/HaxeObject;Ljava/lang/String;)V");
	private static var googleapi_invalidate_token_jni = JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "invalidateToken", "(Ljava/lang/String;)V");
	#end
}