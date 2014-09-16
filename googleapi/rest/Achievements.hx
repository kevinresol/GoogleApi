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

typedef AchievementUnlockResponse = 
{
	kind:String,
	newlyUnlocked:Bool,
}

typedef AchievementResetResponse = 
{
	kind:String,
	definitionId:String,
	updateOccurred:Bool,
	currentState:String,
}