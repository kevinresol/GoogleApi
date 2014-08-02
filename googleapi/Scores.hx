package googleapi ;
import openfl.net.URLVariables;
using tink.CoreApi;

/**
 * ...
 * @author Kevin
 */
class Scores
{
	/**
	 * https://developers.google.com/games/services/web/api/scores/get
	 * @param	playerId
	 * @param	leaderboardId
	 * @param	timeSpan
	 * @return
	 */
	public function get(playerId:String, leaderboardId:String, timeSpan:GetTimeSpan):Surprise<PlayerLeaderboardScoreListResponse, Error>
	{
		var url = '${GoogleApi.URI_GAMES}/players/$playerId/leaderboards/$leaderboardId/scores/$timeSpan';
		return GoogleApi.makeRestCall(GoogleApi.SCOPE_GAMES, url);
	}
	
	public static function list(leaderboardId:String, collection:ScoresCollection, timeSpan:ListTimeSpan, maxResults:Int = 0, pageToken:String = ""):Surprise<LeaderboardScores, Error>
	{
		var url = '${GoogleApi.URI_GAMES}/leaderboards/$leaderboardId/scores/$collection';
		
		var variables = new URLVariables('timeSpan=$timeSpan');
		if (maxResults > 0)
			variables.maxResults = maxResults;
		if (pageToken != "")
			variables.pageToken = pageToken;
			
		return GoogleApi.makeRestCall(GoogleApi.SCOPE_GAMES, url, variables);
	}
	
	public static function listWindow(leaderboardId:String, collection:ScoresCollection, timeSpan:ListTimeSpan, maxResults:Int = 0, pageToken:String = "", resultsAbove:Int = 0, returnTopIfAbsent:Bool = true):Surprise<LeaderboardScores, Error>
	{
		var url = '${GoogleApi.URI_GAMES}/leaderboards/$leaderboardId/window/$collection';
		
		var variables = new URLVariables('timeSpan=$timeSpan&returnTopIfAbsent=$returnTopIfAbsent');
		if (maxResults > 0)
			variables.maxResults = maxResults;
		if (pageToken != "")
			variables.pageToken = pageToken;
		if (resultsAbove > 0)
			variables.resultsAbove = resultsAbove;
		
		return GoogleApi.makeRestCall(GoogleApi.SCOPE_GAMES, url, variables);
	}
	
	public static function submit(leaderboardId:String, score:Int, scoreTag:String = ""):Surprise<PlayerScoreResponse, Error>
	{
		var url = '${GoogleApi.URI_GAMES}/leaderboards/$leaderboardId/scores';
		
		var variables = new URLVariables('score=$score');
		if (scoreTag != "")
			variables.scoreTag = scoreTag;
			
		return GoogleApi.makeRestCall(GoogleApi.SCOPE_GAMES, url, variables, true);
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