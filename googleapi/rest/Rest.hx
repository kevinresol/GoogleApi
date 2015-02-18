package googleapi.rest;
import googleapi.GoogleApi.AccessToken;
import haxe.Json;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
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
		if (GoogleApi.token == null)
			return GoogleApi.authenticate().flatMap(tokenNext.bind(_, scope, url, variables, method));
		else
			return GoogleApi.token.flatMap(tokenNext.bind(_, scope, url, variables, method));
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
	
	private static function tokenNext(outcome:Outcome<AccessToken, Error>, scope, url, ?variables, method )
	{
		try
		{
			var accessToken = outcome.sure();
			if (accessToken.scopes.indexOf(scope) == -1)
			{
				var scopes = accessToken.scopes.concat([scope]);
				scopes.remove(GoogleApi.SCOPE_GAMES);
				scopes.remove(GoogleApi.SCOPE_PLUS_LOGIN);
				return GoogleApi.authenticate(scopes).flatMap(tokenNext.bind(_, scope, url, variables, method));
			}
			
			if (variables == null)
				variables = new URLVariables();
			
			variables.access_token = outcome.sure().token;
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
	}
	
}