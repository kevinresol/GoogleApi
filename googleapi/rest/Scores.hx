package googleapi.rest ;
import openfl.net.URLVariables;
using tink.CoreApi;

/**
 * https://developers.google.com/games/services/web/api/scores/get
 * @author Kevin
 */
@:build(googleapi.macro.BuildMacro.build())
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
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES)
	@:pathParam("players", playerId, String)
	@:pathParam("leaderboards", leaderboardId, String)
	@:pathParam("scores", timeSpan, GetTimeSpan)
	public function get():Surprise<PlayerLeaderboardScoreListResponse, Error>
	{		
		
	}
	
	@:cache
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES)
	@:pathParam("leaderboards", leaderboardId, String)
	@:pathParam("scores", collection, ScoresCollection)
	@:queryParam(timeSpan, ListTimeSpan)
	@:queryParam(maxResults, Int, 0)
	@:queryParam(pageToken, String, "")
	public static function list():Surprise<LeaderboardScores, Error>
	{
		
	}
	
	@:cache
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES)
	@:pathParam("leaderboards", leaderboardId, String)
	@:pathParam("window", collection, ScoresCollection)
	@:queryParam(timeSpan, ListTimeSpan)
	@:queryParam(maxResults, Int, 0)
	@:queryParam(pageToken, String, "")
	@:queryParam(resultsAbove, Int, 0)
	@:queryParam(returnTopIfAbsent, Bool, true)
	public static function listWindow():Surprise<LeaderboardScores, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "POST")
	@:pathParam("leaderboards", leaderboardId, String)
	@:pathParam("scores")
	@:queryParam("score", Int)
	@:queryParam("scoreTag", String, "")
	public static function submit():Surprise<PlayerScoreResponse, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "POST")
	@:pathParam("leaderboards")
	@:pathParam("scores")
	@:requestBody(PlayerScoreSubmissionList)
	public static function submitMultiple():Surprise<PlayerScoreListResponse, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES_MANAGEMENT, "POST")
	@:pathParam("leaderboards", leaderboardId, String)
	@:pathParam("scores")
	@:pathParam("reset")
	public static function reset():Surprise<PlayerScoreResetResponse, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES_MANAGEMENT, "POST")
	@:pathParam("leaderboards", leaderboardId, String)
	@:pathParam("scores")
	@:pathParam("resetForAllPlayers")
	public static function resetForAllPlayers():Surprise<Noise, Error>
	{
		
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
	kind:String, // "games#playerLeaderboardScoreListResponse"
	nextPageToken:String,
	player:Players.Player,
	items:Array<PlayerLeaderboardScore>,
}

typedef PlayerLeaderboardScore =
{
	kind:String, // "games#playerLeaderboardScore"
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
	kind:String, // "games#leaderboardScoreRank"
	rank:Int,
	formattedRank:String,
	numScores:Int,
	formattedNumScores:String,
}

typedef LeaderboardScores = 
{
	kind:String, // "games#leaderboardScores"
	nextPageToken:String,
	prevPageToken:String,
	numScores:Int,
	playerScore:LeaderboardEntry,
	items:Array<LeaderboardEntry>,
}

typedef LeaderboardEntry =
{
	kind:String, // "games#leaderboardEntry"
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
	kind:String, // "games#playerScoreResponse"
	beatenScoreTimeSpans:Array<String>,
	unbeatenScores:Array<PlayerScore>,
	formattedScore:String,
	leaderboardId:String,
	scoreTag:String,
}

typedef PlayerScore = 
{
	kind:String, // "games#playerScore"
	timeSpan:String,
	score:Int,
	formattedScore:String,
	scoreTag:String,
}

typedef PlayerScoreSubmissionList = 
{
	kind:String,// "games#playerScoreSubmissionList"
	scores:Array<ScoreSubmission>,
}

typedef PlayerScoreListResponse =
{
	kind:String, // "games#playerScoreListResponse"
	submittedScores:Array<PlayerScoreResponse>
}

typedef ScoreSubmission = 
{
	kind:String, // "games#scoreSubmission"
	leaderboardId:String,
	score:Int,
	scoreTag:String,
}

typedef PlayerScoreResetResponse = 
{
	kind:String,
	resetScoreTimeSpans:Array<String>,
}