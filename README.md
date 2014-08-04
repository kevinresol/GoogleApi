#GoogleApi

A Haxe library for the Google Play Games API 

## Dependencies
tink_core

## Setup
Coming soon...

GameActivity.java:
```java
public class GameActivity extends android.support.v4.app.FragmentActivity implements SensorEventListener
```

Project xml:
```xml
<template path="templates/GameActivity.java" rename="src/org/haxe/lime/GameActivity.java" if="android"/>
<setenv name="GooglePlayID" value="your-app-id" if="android"/>
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
