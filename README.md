## WORK IN PROGRESS

#GoogleApi

A Haxe library for the Google Play Games API 

## Dependencies

[tink_core](https://github.com/haxetink/tink_core)

## Setup

```
haxelib git googleapi https://github.com/kevinresol/GoogleApi.git
```

#### Android

##### Project xml:
```xml
<setenv name="GooglePlayID" value="yourAppId" if="android"/>
```

##### Command line:
```
lime rebuild googleapi android
```

#### iPhone

##### Download the Google SDK (They are huge so I did not put them in the repo)

Download Google+ iOS SDK and Games SDK from this [link](https://developers.google.com/games/services/downloads/). 
Unzip and put the following files under `/dependencies/iphone/`
 - GoogleOpenSource.framework
 - GooglePlayGames.framework
 - GooglePlus.framework
 - GooglePlayGames.bundle
 - GooglePlus.bundle

##### Download Admob SDK

Download from this [link](https://developers.google.com/mobile-ads-sdk/docs/admob/ios/download) and extract GoogleMobileAds.framework under `/dependencies/iphone/`

##### Download libcurl.a

Use this [script](https://github.com/brunodecarvalho/curl-ios-build-scripts) to compile the lastest cUrl library into `libcurl.a` file. Also put it under `/dependencies/iphone/`

This is required because the Google SDK is shipped with an older version of curl which will crash upon loading URL with the HTTPS protocol. (HTTPS is necessary to access Google's REST API)



##### Project xml:
```xml
<setenv name="GooglePlayID" value="yourAppId-someHash.apps.googleusercontent.com" if="ios"/>
```

##### Command line:
```
lime rebuild googleapi ios
```



## Usage

```haxe
// list leaderboards
Leaderboards.list().handle(function(r)
{
	try 
	{
		var result = r.sure();
		// work with the result
	}
	catch (e:Error) 
	{
		// handle the error
	}
});
	
// submit score and then list the scores
Scores.submit("Some-Leaderboard-ID", 234).handle(function(s)
{
	try
	{
		var submitResult = s.sure();
		// do something with the submitResult
		
		// list the score (after successfully submitting)
		Scores.list("Some-Leaderboard-ID", PUBLIC, ALL_TIME).handle(function(l)
		{
			try
			{
				var result = l.sure();
			}
			catch (e:Error) 
			{
				// handle the list error
			}
		});
	}
	catch (e:Error) 
	{
		// handle the submit error
	}
	
});
```
