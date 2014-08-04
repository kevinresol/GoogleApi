package googleapi;
import googleapi.rest.Leaderboards.LeaderboardResource;
import googleapi.rest.Scores;
using tink.CoreApi;

/**
 * ...
 * @author Kevin
 */
class LeaderboardHandle
{
	public var id(default, null):String;
	public var pageSize:Int;
	public var data(get, never):Surprise<LeaderboardResource, Error>;
	
	public var pages:Map<Int, Surprise<LeaderboardResource, Error>>;
	private var tokens:Map<Int, String>;
	private var currentPage:Int = 0;
	

	public function new(id:String, pageSize:Int = 15) 
	{
		this.id = id;
		this.pageSize = pageSize;
		pages = new Map();
		tokens = new Map();
	}
	
	public function nextPage():Surprise<LeaderboardResource, Error>
	{
		pages[currentPage] = Scores.list(id, 
		return data;
	}
	
	private function getIndex(collection:ScoresCollection, timeSpan:ListTimeSpan, 
	
	private inline function get_data():Surprise<LeaderboardResource, Error>
	{
		return pages[currentPage];
	}
}