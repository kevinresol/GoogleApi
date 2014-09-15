package googleapi.rest;
import haxe.Json;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;
using tink.CoreApi;
/**
 * ...
 * @author Kevin
 */
class Rest
{
	public static inline var URI_GAMES:String = "https://www.googleapis.com/games/v1";
	public static inline var URI_GAMES_MANAGEMENT:String = "https://www.googleapis.com/games/v1management";
	
	public static function callRaw(scope:String, url:String, ?variables:URLVariables, method:String = "GET"):Surprise<String, Error>
	{
		//TODO cache
		//ready -> getToken -> load url
		return GoogleApi.getToken(scope).flatMap(function(outcome)	
		{
			try
			{
				if (variables == null)
					variables = new URLVariables();
				
				variables.access_token = outcome.sure();
				return Future.async(function(handler)
				{
					var request = new URLRequest(url + "?" + variables.toString());
					request.method = method;
					
					var loader = new URLLoader();
					loader.addEventListener(Event.COMPLETE, function(_) handler(Success(loader.data)));
					loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) handler(Failure(new Error(e.toString()))));
					loader.load(request);
				});
			}
			catch (e:Error) // token error (e.g. typo in scope)
				return Future.sync(Failure(e));
		});
	}
	
	public static function call<T>(scope:String, url:String, ?variables:URLVariables, method:String = "GET"):Surprise<T, Error>
	{
		return callRaw(scope, url, variables, method).map(function(outcome)
		{
			try
			{
				var response = outcome.sure();
				if (response == "")
					return Success(null);
				else
					return Success(Json.parse(response));
			}
			catch (e:Error)
				return Failure(e);
		});
	}
	
}