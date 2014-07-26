package;
import openfl.events.IEventDispatcher.Function;
#if openfl
import openfl.events.EventDispatcher;
#end

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class GoogleApi 
{
	public static var callback:String->String->Void;
	
	private static var inited:Bool = false;
	private static var eventDispatcher:EventDispatcher = new EventDispatcher();
	
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
	
	public static function init():Void
	{
		if (inited)
			throw "Already called init();";
		
		inited = true;
		googleapi_init_jni({dispatch:dispatchEvent});
	}
	
	private static function dispatchEvent(type:String, contents:String):Void
	{
		eventDispatcher.dispatchEvent(new GoogleApiEvent(type, contents));
	}
	
	
	public static function addEventListener(type, listener, useCapture = false, priority = 0, useWeakReference = false):Void
	{
		eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	
	
	
	
	
	
	private static var googleapi_sample_method = Lib.load ("googleapi", "googleapi_sample_method", 1);
	private static var googleapi_init = Lib.load ("googleapi", "googleapi_sample_method", 1);
	
	#if (android && openfl)
	private static var googleapi_sample_method_jni = JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "sampleMethod", "(I)I");
	private static var googleapi_init_jni = JNI.createStaticMethod ("org.haxe.extension.GoogleApi", "init", "(Lorg/haxe/lime/HaxeObject;)V");
	#end
	
	
}