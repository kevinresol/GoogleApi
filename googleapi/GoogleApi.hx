package googleapi ;
import googleapi.macro.Macro;
import haxe.Json;
import openfl.events.EventDispatcher;

#if cpp
import cpp.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end

using tink.CoreApi;

class GoogleApi 
{
	public static inline var SCOPE_PLUS_LOGIN:String = "https://www.googleapis.com/auth/plus.login";
	public static inline var SCOPE_GAMES:String = "https://www.googleapis.com/auth/games";
	
	private static var inited:Bool = false;
	
	public static var token:Null<Surprise<AccessToken, Error>>;
	
	/**
	 * Call this method at the beginning of 
	 * By default it requests the access token of the following two scopes:
		* https://www.googleapis.com/auth/plus.login
		* https://www.googleapis.com/auth/games
	 * @param	extraScopes array of scopes other than the default scopes (plus.login and games)
	 */
	public static function authenticate(?extraScopes:Array<String>):Surprise<AccessToken, Error>
	{
		if (!inited) init();
		
		var scopes = [SCOPE_PLUS_LOGIN, SCOPE_GAMES];
		
		if (extraScopes != null)
			scopes = scopes.concat(extraScopes);
			
		return token = Future.async(function(handler)
		{
			#if (android && openfl)
			googleapi_authenticate(scopes.join(" "), {handle:onAuthenticateResult.bind(handler)});
			#else
			googleapi_authenticate(scopes.join(" "), onAuthenticateResult.bind(handler));
			#end
		});
		
	}
	private static function init():Void
	{
		inited = true;
		
		#if (android && openfl)
		
		#else
		googleapi_init(Macro.getID());
		#end
	}
	
	private static function onAuthenticateResult(handler, jsonResult)
	{
		var result:AuthenticateResult = Json.parse(jsonResult);
		
		if (result.status == "success")
			handler(Success(new AccessToken(result.scopes.split(" "), result.accessToken)));
		else
			handler(Failure(new Error(Std.string(result.error))));
	}
	
	
	#if (android && openfl)
	private static var googleapi_authenticate = JNI.createStaticMethod("googleapi.GoogleApi", "authenticate", "(Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V");
	
	#else
	private static var googleapi_init = Lib.load("googleapi", "googleapi_init", 1);
	private static var googleapi_authenticate = Lib.load("googleapi", "googleapi_authenticate", 2);
	#end
	
}

class AccessToken
{
	public var scopes:Array<String>;
	public var token:String;
	
	public function new(scopes:Array<String>, token:String)
	{
		this.scopes = scopes;
		this.token = token;
	}
	
	public function toString():String
	{
		return 'scopes: $scopes, token: $token';
	}
}

typedef AuthenticateResult = 
{
	status:String,
	?error:String,
	?scopes:String,
	?accessToken:String
}