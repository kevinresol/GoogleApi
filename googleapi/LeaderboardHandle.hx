package googleapi;
import googleapi.rest.Scores;
using tink.CoreApi;

/**
 * ...
 * @author Kevin
 */
class LeaderboardHandle
{
	public var id(default, null):String;
	public var collection:ScoresCollection;
	public var timeSpan:ListTimeSpan;
	
	public var pageSize(default, null):Int;
	public var data(get, never):Surprise<Array<LeaderboardEntry>, Error>;
	
	
	public var pages:Map<String, Surprise<Array<LeaderboardEntry>, Error>>;
	
	private var tokens:Map<String, String>;
	private var currentPage:Int = 0;
	

	public function new(id:String, pageSize:Int = 15, collection:ScoresCollection, timeSpan:ListTimeSpan) 
	{
		this.id = id;
		this.pageSize = pageSize;
		this.collection = collection;
		this.timeSpan = timeSpan;
		pages = new Map();
		tokens = new Map();
	}
	
	public inline function nextPage(forceReload:Bool = false):Surprise<Array<LeaderboardEntry>, Error>
	{
		return getPage(currentPage + 1, forceReload);
	}
	
	public inline function prevPage(forceReload:Bool = false):Surprise<Array<LeaderboardEntry>, Error>
	{
		return getPage(currentPage - 1, forceReload);
	}
	
	public function getPage(page:Int, forceReload:Bool = false):Surprise<Array<LeaderboardEntry>, Error>
	{
		currentPage = page;
		
		var index = getIndex(page);
		var token = tokens.exists(index) ? tokens[index] : "";
		
		pages[index] = Scores.list(id, collection, timeSpan, pageSize, token, forceReload).map(function(o)
		{
			try
			{
				var listResult = o.sure();
				tokens[getIndex(currentPage - 1)] = listResult.nextPageToken;
				tokens[getIndex(currentPage + 1)] = listResult.prevPageToken;
				
				// "items" may not exist, return an empty array instead of null to prevent possible bugs
				if (listResult.items == null)
					return Success([]);
				else
					return Success(listResult.items);
			}
			catch (e:Error)
				return Failure(e);
		});
		return data;
	}
	
	private inline function getIndex(page:Int):String
	{
		return '$collection-$timeSpan-$currentPage';
	}
	
	private inline function get_data():Surprise<Array<LeaderboardEntry>, Error>
	{
		return pages[getIndex(currentPage)];
	}
}