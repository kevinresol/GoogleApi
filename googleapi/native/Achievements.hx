package googleapi.native;

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
	
	public static function increment(achievementId:String, numSteps:Int):Void
	{
		_increment(achievementId, numSteps);
	}

	public static function unlock(achievementId:String):Void
	{
		_unlock(achievementId);
	}
	
	public static function reveal(achievementId:String):Void
	{
		_reveal(achievementId);
	}

	public static function setSteps(achievementId:String, numSteps:Int):Void
	{
		_setSteps(achievementId, numSteps);
	}
	
	#if android
	private static var _increment = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "increment", "(Ljava/lang/String;I)V");
	private static var _unlock = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "unlock", "(Ljava/lang/String;)V");
	private static var _reveal = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "reveal", "(Ljava/lang/String;)V");
	private static var _setSteps = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "setSteps", "(Ljava/lang/String;I)V");
	#end
	
	#if ios
	private static var _increment = null;
	private static var _unlock = Lib.load("googleapi","achievements_unlock",1);
	private static var _reveal = null;
	private static var _setSteps = null;
	#end
	
}
