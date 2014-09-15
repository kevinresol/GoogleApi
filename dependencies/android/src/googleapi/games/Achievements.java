package googleapi.games;

import googleapi.GoogleApi;
import com.google.android.gms.games.Games;

/**
 * https://developer.android.com/reference/com/google/android/gms/games/achievement/Achievements.html
 * @author Kevin
 */
public class Achievements
{
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