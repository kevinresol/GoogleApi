package googleapi.native;

using tink.CoreApi;

#if android
import openfl.utils.JNI;
#end

#if ios
import cpp.Lib;
#end

/**
 * https://developer.android.com/reference/com/google/android/gms/games/achievement/Achievements.html
 * @author Kevin
 */
class Achievements
{
	public static inline var ACHIEVEMENTS_CLASS_QUALIFIER:String = "googleapi.games.Achievements";
	
	public static function show():Void
	{
		GoogleApi.token.handle(function(outcome) 
			if (outcome.isSuccess()) googleapi_achievements_show());
	}
	
	public static function increment(achievementId:String, numSteps:Int):Void
	{
		GoogleApi.token.handle(function(outcome) 
			if (outcome.isSuccess()) googleapi_achievements_increment(achievementId, numSteps));
	}

	public static function unlock(achievementId:String):Void
	{
		GoogleApi.token.handle(function(outcome) 
			if (outcome.isSuccess()) googleapi_achievements_unlock(achievementId));
	}
	
	public static function reveal(achievementId:String):Void
	{
		GoogleApi.token.handle(function(outcome) 
			if (outcome.isSuccess()) googleapi_achievements_reveal(achievementId));
	}

	public static function setSteps(achievementId:String, numSteps:Int):Void
	{
		GoogleApi.token.handle(function(outcome) 
			if (outcome.isSuccess()) googleapi_achievements_setSteps(achievementId, numSteps));
	}
	
	#if (android && openfl)
	private static var googleapi_achievements_show = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "show", "()V");
	private static var googleapi_achievements_increment = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "increment", "(Ljava/lang/String;I)V");
	private static var googleapi_achievements_unlock = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "unlock", "(Ljava/lang/String;)V");
	private static var googleapi_achievements_reveal = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "reveal", "(Ljava/lang/String;)V");
	private static var googleapi_achievements_setSteps = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "setSteps", "(Ljava/lang/String;I)V");
	#end
	
	#if ios
	private static var googleapi_achievements_show = Lib.load("googleapi", "achievements_show", 0);
	private static var googleapi_achievements_increment = Lib.load("googleapi","achievements_increment",2);
	private static var googleapi_achievements_unlock = Lib.load("googleapi","achievements_unlock",1);
	private static var googleapi_achievements_reveal = Lib.load("googleapi","achievements_reveal",1);
	private static var googleapi_achievements_setSteps = Lib.load("googleapi","achievements_setSteps",2);
	#end
	
}
