package googleapi.rest ;
import openfl.net.URLVariables;
using tink.CoreApi;

/**
 * https://developers.google.com/games/services/web/api/leaderboards
 * @author Kevin
 */
private typedef GetResult = Surprise<Leaderboard, Error>;
private typedef ListResult = Surprise<LeaderboardListResponse, Error>;

@:build(googleapi.macro.Macro.build())
class Leaderboards
{
	public static function get(leaderboardId:String):GetResult
	{
		var url = '${Rest.URI_GAMES}/leaderboards/$leaderboardId'; 
		return Rest.call(GoogleApi.SCOPE_GAMES, url);
	}
	
	@:cache
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES)
	@:pathParam("leaderboards")
	@:queryParam(maxResults, Int, 0)
	@:queryParam(pageToken, String, "")
	public static function testList():ListResult
	{
		
	}
	
	public static function list(maxResults:Int = 0, pageToken:String = ""):ListResult
	{
		var url = '${Rest.URI_GAMES}/leaderboards'; 
		
		var variables = new URLVariables();
		if (maxResults > 0)
			variables.maxResults = maxResults;
		if (pageToken != "")
			variables.pageToken = pageToken;
			
		return Rest.call(GoogleApi.SCOPE_GAMES, url, variables);
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