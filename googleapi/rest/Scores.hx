package googleapi.rest ;
import openfl.net.URLVariables;
using tink.CoreApi;

/**
 * https://developers.google.com/games/services/web/api/scores/get
 * @author Kevin
 */
private typedef GetResult = Surprise<PlayerLeaderboardScoreListResponse, Error>;
private typedef ListResult = Surprise<LeaderboardScores, Error>;
private typedef ListWindowResult = Surprise<LeaderboardScores, Error>;

@:build(googleapi.macro.Macro.build())
class Scores
{
	/**
	 * https://developers.google.com/games/services/web/api/scores/get
	 * @param	playerId
	 * @param	leaderboardId
	 * @param	timeSpan
	 * @return
	 */
	@:cache
	public function get(playerId:String, leaderboardId:String, timeSpan:GetTimeSpan):GetResult
	{		
		var url = '${Rest.URI_GAMES}/players/$playerId/leaderboards/$leaderboardId/scores/$timeSpan';
		return Rest.call(GoogleApi.SCOPE_GAMES, url);
	}
	
	@:cache
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES)
	@:pathParam("leaderboardId", leaderboardId, String)
	@:pathParam("scores", collection, ScoresCollection)
	@:queryParam(timeSpan, ListTimeSpan)
	@:queryParam(maxResults, Int, 0)
	@:queryParam(pageToken, String, "")
	public static function testList():ListResult
	{
		
	}
	
	@:cache
	public static function list(leaderboardId:String, collection:ScoresCollection, timeSpan:ListTimeSpan, maxResults:Int = 0, pageToken:String = ""):ListResult
	{
		var index = '$leaderboardId-$collection-$timeSpan-$maxResults-$pageToken';
		
		if (!listCache.exists(index))
		{
			var url = '${Rest.URI_GAMES}/leaderboards/$leaderboardId/scores/$collection';
			
			var variables = new URLVariables('timeSpan=$timeSpan');
			if (maxResults > 0)
				variables.maxResults = maxResults;
			if (pageToken != "")
				variables.pageToken = pageToken;
				
			listCache[index] = Rest.call(GoogleApi.SCOPE_GAMES, url, variables);
		}
		
		return listCache[index];
	}
	
	
	@:cache
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES)
	@:pathParam("leaderboardId", leaderboardId, String)
	@:pathParam("window", collection, ScoresCollection)
	@:queryParam(timeSpan, ListTimeSpan)
	@:queryParam(maxResults, Int, 0)
	@:queryParam(pageToken, String, "")
	@:queryParam(resultsAbove, Int, 0)
	@:queryParam(returnTopIfAbsent, Bool, true)
	public static function testListWindow():ListResult
	{
		
	}
	
	@:cache
	public static function listWindow(leaderboardId:String, collection:ScoresCollection, timeSpan:ListTimeSpan, maxResults:Int = 0, pageToken:String = "", resultsAbove:Int = 0, returnTopIfAbsent:Bool = true):ListWindowResult
	{
		var index = '$leaderboardId-$collection-$timeSpan-$maxResults-$pageToken-$returnTopIfAbsent';
		
		if (!listWindowCache.exists(index))
		{
			var url = '${Rest.URI_GAMES}/leaderboards/$leaderboardId/window/$collection';
			
			var variables = new URLVariables('timeSpan=$timeSpan&returnTopIfAbsent=$returnTopIfAbsent');
			if (maxResults > 0)
				variables.maxResults = maxResults;
			if (pageToken != "")
				variables.pageToken = pageToken;
			if (resultsAbove > 0)
				variables.resultsAbove = resultsAbove;
			
			listWindowCache[index] = Rest.call(GoogleApi.SCOPE_GAMES, url, variables);
		}
		
		return listWindowCache[index];
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "POST")
	@:pathParam("leaderboardId", "leaderboardId", String)
	@:pathParam("scores")
	@:queryParam("score", Int)
	@:queryParam("scoreTag", String, "")
	public static function testSubmit():ListResult
	{
		
	}
	
	public static function submit(leaderboardId:String, score:Int, scoreTag:String = ""):Surprise<PlayerScoreResponse, Error>
	{
		var url = '${Rest.URI_GAMES}/leaderboards/$leaderboardId/scores';
		
		var variables = new URLVariables('score=$score');
		if (scoreTag != "")
			variables.scoreTag = scoreTag;
			
		return Rest.call(GoogleApi.SCOPE_GAMES, url, variables, "POST");
	}
	
}

@:enum
abstract GetTimeSpan(String)
{
	var ALL = "ALL";
	var ALL_TIME = "ALL_TIME";
	var DAILY = "DAILY";
	var WEEKLY = "WEEKLY";
}

@:enum
abstract ListTimeSpan(String)
{
	var ALL_TIME = "ALL_TIME";
	var DAILY = "DAILY";
	var WEEKLY = "WEEKLY";
}

@:enum
abstract ScoresCollection(String)
{
	var PUBLIC = "PUBLIC";
	var SOCIAL = "SOCIAL";
}

typedef PlayerLeaderboardScoreListResponse = 
{
	kind:String,
	nextPageToken:String,
	player:Players.Player,
	items:Array<PlayerLeaderboardScore>,
}

typedef PlayerLeaderboardScore =
{
	kind:String,
	leaderboard_id:String,
	scoreValue:Int,
	scoreString:String,
	publicRank:LeaderboardScoreRank,
	socialRank:LeaderboardScoreRank,
	timeSpan:String,
	writeTimestamp:Int,
	scoreTag:String,
}

typedef LeaderboardScoreRank = 
{
	kind:String,
	rank:Int,
	formattedRank:String,
	numScores:Int,
	formattedNumScores:String,
}

typedef LeaderboardScores = 
{
	kind:String,
	nextPageToken:String,
	prevPageToken:String,
	numScores:Int,
	playerScore:LeaderboardEntry,
	items:Array<LeaderboardEntry>,
}

typedef LeaderboardEntry =
{
	kind:String,
	player:Players.Player,
	scoreRank:Int,
	formattedScoreRank:String,
	scoreValue:Int,
	formattedScore:String,
	timeSpan:String,
	writeTimestampMillis:Int,
	scoreTag:String,
}

typedef PlayerScoreResponse = 
{
	beatenScoreTimeSpans:Array<String>,
	unbeatenScores:Array<PlayerScore>,
	formattedScore:String,
	leaderboardId:String,
	scoreTag:String,
}

typedef PlayerScore = 
{
	kind:String,
	timeSpan:String,
	score:Int,
	formattedScore:String,
	scoreTag:String,
}