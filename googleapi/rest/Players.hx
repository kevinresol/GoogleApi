package googleapi.rest ;
import openfl.net.URLVariables;
using tink.CoreApi;
/**
 * https://developers.google.com/games/services/web/api/players
 * @author Kevin
 */
private typedef GetResult = Surprise<Player, Error>;
private typedef ListResult = Surprise<PlayerListResponse, Error>;

class Players
{

	public static function get(playerId:String):GetResult
	{
		var url = '${Rest.URI_GAMES}/players/$playerId';
		return Rest.call(GoogleApi.SCOPE_GAMES, url);
	}
	
	public static function list(playerId:String, collection:PlayerCollection, maxResults:Int = 0, pageToken:String = ""):ListResult
	{
		var url = '${Rest.URI_GAMES}/players/me/players/$collection';
		
		var variables = new URLVariables();
		if (maxResults > 0)
			variables.maxResults = maxResults;
		if (pageToken != "")
			variables.pageToken = pageToken;
			
		return Rest.call(GoogleApi.SCOPE_GAMES, url, variables);
	}
}

@:enum
abstract PlayerCollection(String)
{
	var PLAYED_WITH = "played_with";
}

typedef PlayerListResponse = 
{
	kind:String, // "games#playerListResponse"
	nextPageToken:String,
	items:Array<Player>,
}

typedef Player = 
{
	kind:String, // "games#player"
	playerId:String,
	displayName:String,
	avatarImageUrl:String,
	lastPlayedWith:Played,
	name:{familyName:String, givenName:String},
	experienceInfo:PlayerExperienceInfo,
	title:String,
}

typedef Played = 
{
	kind:String, // "games#played"
	timeMillis:Int,
	autoMatched:Bool,
}

typedef PlayerExperienceInfo = 
{
	kind:String, // "games#playerExperienceInfo"
	currentExperiencePoints:Int,
	lastLevelUpTimestampMillis:Int,
	currentLevel:PlayerLevel,
	nextLevel:PlayerLevel,
}

typedef PlayerLevel = 
{
	kind:String, // "games#playerLevel"
	level:Int,
	minExperiencePoints:Int,
	maxExperiencePoints:Int,
}