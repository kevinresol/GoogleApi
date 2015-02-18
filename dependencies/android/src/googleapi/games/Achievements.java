package googleapi.games;

import googleapi.GoogleApi;
import com.google.android.gms.games.Games;
import org.haxe.extension.Extension;

/**
 * https://developer.android.com/reference/com/google/android/gms/games/achievement/Achievements.html
 *
 * @author Kevin
 */
public class Achievements
{
	private static final String TAG = "GoogleApi (Haxe) Achievements";

	public static void show()
	{
		Extension.mainActivity.startActivityForResult(Games.Achievements.getAchievementsIntent(GoogleApi.getApiClient()), GoogleApi.REQUEST_ACHIEVEMENTS);
	}

	public static void increment(String id, int numSteps)
	{
		Games.Achievements.increment(GoogleApi.getApiClient(), id, numSteps);
	}

	public static void unlock(String id)
	{
		Games.Achievements.unlock(GoogleApi.getApiClient(), id);
	}

	public static void reveal(String id)
	{
		Games.Achievements.reveal(GoogleApi.getApiClient(), id);
	}

	public static void setSteps(String id, int numSteps)
	{
		Games.Achievements.setSteps(GoogleApi.getApiClient(), id, numSteps);
	}

}