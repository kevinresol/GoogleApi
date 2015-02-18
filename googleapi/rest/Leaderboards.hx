package googleapi.rest ;
import openfl.net.URLVariables;
using tink.CoreApi;

/**
 * https://developers.google.com/games/services/web/api/leaderboards
 * @author Kevin
 */
@:build(googleapi.macro.BuildMacro.build())
class Leaderboards
{
	@:cache
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES)
	@:pathParam("leaderboards", leaderboardId, String)
	public static function get():Surprise<Leaderboard, Error>
	{
		
	}
	
	@:cache
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES)
	@:pathParam("leaderboards")
	@:queryParam(maxResults, Int, 0)
	@:queryParam(pageToken, String, "")
	public static function list():Surprise<LeaderboardListResponse, Error>
	{
		
	}
}

/**
 * https://developers.google.com/games/services/web/api/leaderboards#resource
 */
typedef Leaderboard =
{
	kind:String, // "games#leaderboard"
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
	kind:String, // "games#leaderboardListResponse"
	nextPageToken:String,
	items:Array<Leaderboard>,
}