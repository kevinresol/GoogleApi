package org.haxe.extension;

import java.io.IOException;
import android.util.Log;
import android.accounts.AccountManager;
import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.widget.Toast;
import android.view.View;
import com.google.android.gms.plus.Plus;
import com.google.android.gms.plus.Plus.PlusOptions;
import com.google.android.gms.games.Games;
import com.google.android.gms.auth.GoogleAuthUtil;
import com.google.android.gms.auth.UserRecoverableAuthException;
import com.google.android.gms.auth.GoogleAuthException;
import com.google.android.gms.common.AccountPicker;
import com.google.example.games.basegameutils.GameHelper;
import com.google.example.games.basegameutils.GameHelper.GameHelperListener;
import org.haxe.lime.HaxeObject;

/* 
	You can use the Android Extension class in order to hook
	into the Android activity lifecycle. This is not required
	for standard Java code, this is designed for when you need
	deeper integration.
	
	You can access additional references from the Extension class,
	depending on your needs:
	
	- Extension.assetManager (android.content.res.AssetManager)
	- Extension.callbackHandler (android.os.Handler)
	- Extension.mainActivity (android.app.Activity)
	- Extension.mainContext (android.content.Context)
	- Extension.mainView (android.view.View)
	
	You can also make references to static or instance methods
	and properties on Java classes. These classes can be included 
	as single files using <java path="to/File.java" /> within your
	project, or use the full Android Library Project format (such
	as this example) in order to include your own AndroidManifest
	data, additional dependencies, etc.
	
	These are also optional, though this example shows a static
	function for performing a single task, like returning a value
	back to Haxe from Java.
*/
public class GoogleApi extends Extension 
{
	
	protected static GameHelper mHelper;	
	protected static HaxeObject mAccountNameHandler;
	protected static HaxeObject mTokenHandler;
	protected static HaxeObject mDebugHandler;
	protected static String mTokenScope = "";
	protected static String mAccountName = "";
	
	private static final String TAG = "GoogleApi";	
	
	private static final String INIT = "init";
	private static final String TOKEN = "token";
	private static final String ACCOUNT_NAME = "accountName";
	private static final String SIGN_IN_SUCCEEDED = "signInSucceeded";
	private static final String SIGN_IN_FAILED = "signInFailed";
	
	private static final int USER_RECOVERABLE_AUTH = 5;
	private static final int ACCOUNT_PICKER = 2;
	
	public static int sampleMethod (int inputValue) 
	{
		
		//Games.Leaderboards.submitScore(mHelper.getApiClient(), "CgkI-dP3tMUNEAIQAQ", 12345);
		//mHelper.beginUserInitiatedSignIn();
		return inputValue * 100;
		
	}
	
	public static void init(HaxeObject accountNameHandler, HaxeObject debugHandler)
	{
		mAccountNameHandler = accountNameHandler;
		mDebugHandler = debugHandler;
	}
	
	public static void getToken(HaxeObject handler, String scope)
	{
		Log.i(TAG, "getToken " + mAccountName);
		if(mTokenHandler == null) //if not null => already processing another getToken request
		{
			if(mAccountName == "")
				handler.call1("handler", "failed: GoogleAPI not yet ready"); // ACCOUNT_NAME not yet ready
			else
			{
				mTokenHandler = handler;
				mTokenScope = scope;
				new GetAuthToken().execute();
			}
		}
	}
	
	public static void invalidateToken(String token)
	{
		GoogleAuthUtil.invalidateToken(Extension.mainContext, token);
	}
	
	private static void trace(String message)
	{
		if(mDebugHandler != null)
			mDebugHandler.call1("handler", message);
	}
	
	
	/**
	 * Called when an activity you launched exits, giving you the requestCode 
	 * you started it with, the resultCode it returned, and any additional data 
	 * from it.
	 */
	public boolean onActivityResult (int requestCode, int resultCode, Intent data) 
	{
		if (requestCode == USER_RECOVERABLE_AUTH && resultCode == Activity.RESULT_OK) 
		{
			// Call it again returned from UserRecoverableAuthException 
			new GetAuthToken().execute();
		} 
		else if (requestCode == USER_RECOVERABLE_AUTH && resultCode == Activity.RESULT_CANCELED) 
		{
			/*Toast.makeText(this, "User rejected authorization.",
				Toast.LENGTH_SHORT).show();*/
		}
	   
		mHelper.onActivityResult(requestCode, resultCode, data);
		return true;
		
	}
	
	
	/**
	 * Called when the activity is starting.
	 */
	public void onCreate (Bundle savedInstanceState) 
	{
		// create game helper with all APIs (Games, Plus, AppState):
		mHelper = new GameHelper(Extension.mainActivity, GameHelper.CLIENT_GAMES | GameHelper.CLIENT_PLUS /*| GameHelper.CLIENT_APPSTATE*/);
		mHelper.enableDebugLog(true);

		// enable debug logs (if applicable)
		/*if (DEBUG_BUILD) {
			mHelper.enableDebugLog(true, "GameHelper");
		}*/

		GameHelperListener listener = new GameHelper.GameHelperListener() 
		{
			@Override
			public void onSignInSucceeded() 
			{
				trace("signInSucceeded!");
				mAccountName = Plus.AccountApi.getAccountName(mHelper.getApiClient());
				
				// throw it back to haxe
				if(mAccountNameHandler != null)
					mAccountNameHandler.call1("handler", mAccountName);
			}
			
			@Override
			public void onSignInFailed() 
			{
				
			}

		};
		mHelper.setPlusApiOptions(PlusOptions.builder().build());
		mHelper.setup(listener);
	}
	
	
	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy () 
	{
		
	}
	
	
	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause () 
	{
		
	}
	
	
	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart () 
	{
		
	}
	
	
	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	public void onResume ()
	{
		
	}
	
	
	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	public void onStart () 
	{
		mHelper.onStart(Extension.mainActivity);
	}
	
	
	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	public void onStop () 
	{
		mHelper.onStop();
	}
	
	
	
	
	static class GetAuthToken extends AsyncTask<Void, Void, String> 
	{
		public GetAuthToken() 
		{
			
		}
		
		/*@Override
		protected void onPreExecute() 
		{
		
		}*/
		
		@Override
		protected String doInBackground(Void... params) 
		{
			try 
			{
				String token = GoogleAuthUtil.getToken(Extension.mainActivity, mAccountName, "oauth2:" + mTokenScope);
				return token;
			} 
			catch (UserRecoverableAuthException userRecoverableException) 
			{
				Extension.mainActivity.startActivityForResult(userRecoverableException.getIntent(), USER_RECOVERABLE_AUTH);
			} 
			catch (IOException ioEx)
			{
				return "failed: IO Error - " + ioEx.getMessage();
			}
			catch (GoogleAuthException authEx) 
			{
				return "failed: GoogleAuthException - " + authEx.getMessage();
			}
			return null;
		}
		
		@Override
		protected void onPostExecute(String resultToken) 
		{
			if (resultToken != null)
			{
				mTokenHandler.call1("handler", resultToken);
				mTokenHandler = null;
				mTokenScope = "";
			}
		}
	}
	
	
}