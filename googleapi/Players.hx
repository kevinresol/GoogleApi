package googleapi ;
import openfl.net.URLVariables;
using tink.CoreApi;
/**
 * https://developers.google.com/games/services/web/api/players
 * @author Kevin
 */
class Players
{

	public static function get(playerId:String):Surprise<Player, Error>
	{
		var url = '${GoogleApi.URI_GAMES}/players/$playerId';
		return GoogleApi.makeRestCall(GoogleApi.SCOPE_GAMES, url);
	}
	
	public static function list(playerId:String, collection:PlayerCollection, maxResults:Int = 0, pageToken:String = ""):Surprise<PlayerListResponse, Error>
	{
		var url = '${GoogleApi.URI_GAMES}/players/me/players/$collection';
		
		var variables = new URLVariables();
		if (maxResults > 0)
			variables.maxResults = maxResults;
		if (pageToken != "")
			variables.pageToken = pageToken;
			
		return GoogleApi.makeRestCall(GoogleApi.SCOPE_GAMES, url, variables);
	}
}

@:enum
abstract PlayerCollection(String)
{
	var PLAYED_WITH = "played_with";
}

typedef PlayerListResponse = 
{
	kind:String,
	nextPageToken:String,
	items:Array<Player>,
}

typedef Player = 
{
	kind:String,
	playerId:String,
	displayName:String,
	avatarImageUrl:String,
	lastPlayedWith:Played,
	name:PlayerName,
	experienceInfo:PlayerExperienceInfo,
	title:String,
}

typedef PlayerName = 
{
	familyName:String, 
	givenName:String
}

typedef Played = 
{
	kind:String,
	timeMillis:Int,
	autoMatched:Bool,
}

typedef PlayerExperienceInfo = 
{
	currentExperiencePoints:Int,
	lastLevelUpTimestampMillis:Int,
	currentLevel:PlayerLevel,
	nextLevel:PlayerLevel,
}

typedef PlayerLevel = 
{
	kind:String,
	level:Int,
	minExperiencePoints:Int,
	maxExperiencePoints:Int,
}