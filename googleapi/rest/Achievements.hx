package googleapi.rest;

using tink.CoreApi;
/**
 * ...
 * @author ...
 */
@:build(googleapi.macro.BuildMacro.build())
class Achievements
{
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "POST")
	@:pathParam("achievements", achievementId, String)
	@:pathParam("unlock")
	public static function unlock():Surprise<AchievementUnlockResponse, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "POST")
	@:pathParam("achievements", achievementId, String)
	@:pathParam("increment")
	@:queryParam(stepsToIncrement, Int)
	@:queryParam(requestId, Int, 0)
	public static function increment():Surprise<AchievementIncrementResponse, Error>
	{
		
	}
	
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "GET")
	@:pathParam("players", playerId, String)
	@:pathParam("achievements")
	@:queryParam(language, String, "")
	@:queryParam(maxResults, Int, 0)
	@:queryParam(pageToken, String, "")
	@:queryParam(state, ListState, "")
	
	public static function list():Surprise<PlayerAchievementListResponse, Error>
	{
		
	}
	
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "POST")
	@:pathParam("achievements", achievementId, String)
	@:pathParam("reveal")
	public static function reveal():Surprise<AchievementRevealResponse, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "POST")
	@:pathParam("achievements", achievementId, String)
	@:pathParam("setStepsAtLeast")
	@:queryParam(steps, Int)
	public static function setStepsAtLeast():Surprise<AchievementSetStepsAtLeastResponse, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES, "POST")
	@:pathParam("achievements")
	@:pathParam("updateMultiple")
	@:requestBody(AchievementUpdateMultipleRequest)
	public static function updateMultiple():Surprise<AchievementUpdateMultipleResponse, Error>
	{
		
	}
	
	// Management API
	// https://developers.google.com/games/services/management/api/achievements
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES_MANAGEMENT, "POST")
	@:pathParam("achievements", achievementId, String)
	@:pathParam("reset")
	public static function reset():Surprise<AchievementResetResponse, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES_MANAGEMENT, "POST")
	@:pathParam("achievements")
	@:pathParam("reset")
	public static function resetAll():Surprise<AchievementResetResponse, Error>
	{
		
	}
	
	@:rest(GoogleApi.SCOPE_GAMES, Rest.URI_GAMES_MANAGEMENT, "POST")
	@:pathParam("achievements", achievementId, String)
	@:pathParam("resetForAllPlayers")
	public static function resetForAllPlayers():Surprise<Noise, Error>
	{
		
	}
}

@:enum
abstract ListState(String) from String
{
	var ALL = "ALL";
	var HIDDEN = "HIDDEN";
	var REVEALED = "REVEALED";
	var UNLOCKED = "UNLOCKED";
}


typedef AchievementUnlockResponse = 
{
	kind:String, // "games#achievementUnlockResponse"
	newlyUnlocked:Bool,
}

typedef AchievementIncrementResponse =
{
	kind:String, // "games#achievementIncrementResponse"
	currentSteps:Int,
	newlyUnlocked:Bool
}

typedef PlayerAchievementListResponse =
{
	kind:String, // "games#playerAchievementListResponse"
	nextPageToken:String,
	items:Array<PlayerAchievement>,
}

typedef PlayerAchievement =
{
	kind:String, // "games#playerAchievement"
	id:String,
	currentSteps:Int,
	formattedCurrentStepsString:String,
	achievementState:String,
	lastUpdatedTimestamp:Int,
	experiencePoints:Int,
}

typedef AchievementRevealResponse =
{
	kind:String, // "games#achievementRevealResponse"
	currentState:String,
}

typedef AchievementSetStepsAtLeastResponse = 
{
	kind:String, // "games#achievementSetStepsAtLeastResponse"
	currentSteps:Int,
	newlyUnlocked:Bool,
}

typedef AchievementUpdateMultipleRequest = 
{
	kind:String, // "games#achievementUpdateMultipleRequest"
	updates:Array<AchievementUpdateRequest>
}

typedef AchievementUpdateRequest =
{
	kind:String, // "games#achievementUpdateRequest"
	achievementId:String,
	updateType:String,
	incrementPayload:GamesAchievementIncrement,
	setStepsAtLeastPayload:GamesAchievementSetStepsAtLeast,
}

typedef GamesAchievementIncrement =
{
	kind:String, // "games#GamesAchievementIncrement"
	steps:Int,
	requestId:Int,
}

typedef GamesAchievementSetStepsAtLeast =
{
	kind:String, // "games#GamesAchievementSetStepsAtLeast"
	steps:Int,
}

typedef AchievementUpdateMultipleResponse =
{
	kind:String, // "games#achievementUpdateMultipleResponse"
	updatedAchievements:Array<AchievementUpdateResponse>
}

typedef AchievementUpdateResponse =
{
	kind:String, // "games#achievementUpdateResponse"
	achievementId:String,
	updateOccurred:Bool,
	currentState:String,
	currentSteps:Int,
	newlyUnlocked:Bool,
}

typedef AchievementResetResponse = 
{
	kind:String,
	definitionId:String,
	updateOccurred:Bool,
	currentState:String,
}