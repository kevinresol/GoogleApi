package googleapi ;
import openfl.net.URLVariables;
using tink.CoreApi;

/**
 * https://developers.google.com/games/services/web/api/leaderboards
 * @author Kevin
 */
class Leaderboards
{
	public static function get(leaderboardId:String):Surprise<Leaderboard, Error>
	{
		var url = '${GoogleApi.URI_GAMES}/leaderboards/$leaderboardId'; 
		return GoogleApi.makeRestCall(GoogleApi.SCOPE_GAMES, url);
	}
	
	public static function list(maxResults:Int = 0, pageToken:String = ""):Surprise<LeaderboardListResponse, Error>
	{
		var url = '${GoogleApi.URI_GAMES}/leaderboards'; 
		
		var variables = new URLVariables();
		if (maxResults > 0)
			variables.maxResults = maxResults;
		if (pageToken != "")
			variables.pageToken = pageToken;
			
		return GoogleApi.makeRestCall(GoogleApi.SCOPE_GAMES, url, variables);
	}
	
}

/**
 * https://developers.google.com/games/services/web/api/leaderboards#resource
 */
typedef Leaderboard =
{
	kind:String,
	id:String,
	name:String,
	iconUrl:String,
	isIconUrlDefault:Bool,
	order:String,
}

/**
 * https://developers.google.com/games/services/web/api/leaderboards/list
 */
typedef LeaderboardListResponse = 
{
	kind:String,
	nextPageToken:String,
	items:Array<Leaderboard>,
}