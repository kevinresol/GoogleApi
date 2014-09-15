package googleapi.native;
import openfl.utils.JNI;

/**
 * https://developer.android.com/reference/com/google/android/gms/games/achievement/Achievements.html
 * @author Kevin
 */
class Achievements
{
	public static inline var ACHIEVEMENTS_CLASS_QUALIFIER:String = "googleapi.games.Achievements";
	
	public static function increment(achievementId:String, numSteps:Int):Void
	{
		var f = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "increment", "(Ljava/lang/String;I)V");
		f(achievementId, numSteps);
	}

	public static function unlock(achievementId:String):Void
	{
		var f = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "unlock", "(Ljava/lang/String;)V");
		f(achievementId);
	}
	
	public static function reveal(achievementId:String):Void
	{
		var f = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "reveal", "(Ljava/lang/String;)V");
		f(achievementId);
	}

	public static function setSteps(achievementId:String, numSteps:Int):Void
	{
		var f = JNI.createStaticMethod(ACHIEVEMENTS_CLASS_QUALIFIER, "setSteps", "(Ljava/lang/String;I)V");
		f(achievementId, numSteps);
	}
	
}