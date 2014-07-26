package;
import flash.net.URLRequest;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;

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
	public static var debugCallback:String->Void;
	public static var ready:Surprise<Bool, Error> = init();
	
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
	
	public static function invalidateToken(token:String):Void
	{
		googleapi_invalidate_token_jni(
	}
	
	public static function makeRestCall(url:String):Surprise<String, Error>
	{
		return Future.async(function(handler)
		{
			
			var request = new URLRequest(url);
			var loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(_) handler(Success(loader.data)));
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) handler(Failure(new Error(e.toString()))));
			//TODO add error listener
			loader.load(request);
		});
	}
	
	private static function init():Surprise<Bool, Error>
	{
		return Future.async(function(handler)
		{
			var googleapi_init_jni = JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "init", "(Lorg/haxe/lime/HaxeObject;Lorg/haxe/lime/HaxeObject;)V");
			googleapi_init_jni( { handler:function(s:String) 
			{
				if (s.indexOf("failed") != -1)
					handler(Failure(new Error(s)));
				else
					handler(Success(true));
			} },
			{handler:function(s:String) if (debugCallback != null) debugCallback(s)}
			);
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

@:enum
abstract ActionKind(String)
{
	var TOKEN = "token";
}