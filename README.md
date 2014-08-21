#GoogleApi

A Haxe library for the Google Play Games API 

## Dependencies

[tink_core](https://github.com/haxetink/tink_core)

## Setup

```
haxelib git googleapi https://github.com/kevinresol/GoogleApi.git
```

```
lime rebuild googleapi android
```

#### Android

Project xml:
```xml
<setenv name="GooglePlayID" value="your-app-id" if="android"/>
```

#### iPhone

Coming soon

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
