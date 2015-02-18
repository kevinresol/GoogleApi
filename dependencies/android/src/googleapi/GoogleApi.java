package googleapi;

import java.io.IOException;

import android.util.Log;
import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import com.google.android.gms.plus.Plus;
import com.google.android.gms.plus.Plus.PlusOptions;
import com.google.android.gms.auth.GoogleAuthUtil;
import com.google.android.gms.auth.UserRecoverableAuthException;
import com.google.android.gms.auth.GoogleAuthException;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.example.games.basegameutils.GameHelper;
import com.google.example.games.basegameutils.GameHelper.GameHelperListener;
import org.haxe.lime.HaxeObject;
import org.haxe.extension.Extension;
import org.json.JSONException;
import org.json.JSONObject;

// Google Ads
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.graphics.Color;
import com.google.android.gms.ads.*;
////////////////////////////////////////////////////////////////////////

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

/**
 * admob-related codes are from:
 * https://github.com/mkorman9/admob-openfl
 */
public class GoogleApi extends Extension
{

	// Google Ads
	static RelativeLayout adLayout;
	static RelativeLayout.LayoutParams adMobLayoutParams;
	static AdView adView;
	static Boolean adVisible = false, adInitialized = false, adTestMode = false;
	static InterstitialAd interstitial;
	////////////////////////////////////////////////////////////////////////

	protected static GameHelper gameHelper;

	protected static HaxeObject handler;
	protected static String accountName = "";

	private static final String TAG = "GoogleApi (Haxe)";

	private static final int USER_RECOVERABLE_AUTH = 5;

	public static final int REQUEST_ACHIEVEMENTS = 6;

	public static GoogleApiClient getApiClient()
	{
		return gameHelper.getApiClient();
	}

	public static void authenticate(final String scopes, final HaxeObject handler)
	{
		Log.i(TAG, "authenticate " + scopes);
		if (gameHelper == null)
		{
			Extension.mainActivity.runOnUiThread(new Runnable()
			{
				public void run()
				{
					Log.i(TAG, "Preparing GameHelper");

					// create game helper with all APIs (Games, Plus, AppState):
					gameHelper = new GameHelper(Extension.mainActivity, GameHelper.CLIENT_GAMES | GameHelper.CLIENT_PLUS /*| GameHelper.CLIENT_APPSTATE*/);

					GameHelperListener listener = new GameHelper.GameHelperListener()
					{
						@Override
						public void onSignInSucceeded()
						{
							Log.i(TAG, "Sign in Succeeded");
							accountName = Plus.AccountApi.getAccountName(gameHelper.getApiClient());
							new GetAuthToken(accountName, scopes, handler).execute();
						}

						@Override
						public void onSignInFailed()
						{
							Log.i(TAG, "Sign in Failed");
						}

					};
					gameHelper.setPlusApiOptions(PlusOptions.builder().build());
					gameHelper.setup(listener);
					gameHelper.beginUserInitiatedSignIn();

				}
			});
		}
		else
		{
			new GetAuthToken(accountName, scopes, handler).execute();
		}
	}

	public static void invalidateToken(String token)
	{
		GoogleAuthUtil.invalidateToken(Extension.mainContext, token);
	}

	/**
	 * Called when an activity you launched exits, giving you the requestCode
	 * you started it with, the resultCode it returned, and any additional data
	 * from it.
	 */
	public boolean onActivityResult(int requestCode, int resultCode, Intent data)
	{
		if (requestCode == USER_RECOVERABLE_AUTH && resultCode == Activity.RESULT_OK)
		{
			// Call it again returned from UserRecoverableAuthException
			new GetAuthToken(accountName, data.getStringExtra("scopes"), handler).execute();
			handler = null;
		}
		else if (requestCode == USER_RECOVERABLE_AUTH && resultCode == Activity.RESULT_CANCELED)
		{
			/*Toast.makeText(this, "User rejected authorization.",
				Toast.LENGTH_SHORT).show();*/
		}

		gameHelper.onActivityResult(requestCode, resultCode, data);
		return true;

	}


	/**
	 * Called when the activity is starting.
	 */
	public void onCreate(Bundle savedInstanceState)
	{

		// Google Ads
		FrameLayout rootLayout = new FrameLayout(Extension.mainActivity);
		adLayout = new RelativeLayout(Extension.mainActivity);

		RelativeLayout.LayoutParams adMobLayoutParams = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);

		((ViewGroup) Extension.mainView.getParent()).removeView(Extension.mainView);
		rootLayout.addView(Extension.mainView);
		rootLayout.addView(adLayout, adMobLayoutParams);

		Extension.mainActivity.setContentView(rootLayout);
		////////////////////////////////////////////////////////////////////////
	}


	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy()
	{

	}


	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause()
	{
		if (adView != null)
			adView.pause();
	}


	/**
	 * Called after {@link #onStop} when the current activity is being
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart()
	{

	}


	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity
	 * to start interacting with the user.
	 */
	public void onResume()
	{
		if (adView != null)
			adView.resume();
	}


	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when
	 * the activity had been stopped, but is now again being displayed to the
	 * user.
	 */
	public void onStart()
	{
		if (gameHelper != null)
			gameHelper.onStart(Extension.mainActivity);
	}


	/**
	 * Called when the activity is no longer visible to the user, because
	 * another activity has been resumed and is covering this one.
	 */
	public void onStop()
	{
		if (gameHelper != null)
			gameHelper.onStop();
	}


	static class GetAuthToken extends AsyncTask<String, Void, String>
	{
		private String accountName;
		private String scopes;
		private HaxeObject handler;

		public GetAuthToken(String accountName, String scopes, HaxeObject handler)
		{
			this.accountName = accountName;
			this.scopes = scopes;
			this.handler = handler;
		}
		
		/*@Override
		protected void onPreExecute() 
		{
		
		}*/

		@Override
		protected String doInBackground(String... params)
		{
			try
			{
				String token = GoogleAuthUtil.getToken(Extension.mainActivity, accountName, "oauth2:" + scopes);
				return token;
			}
			catch (UserRecoverableAuthException userRecoverableException)
			{
				Intent intent = userRecoverableException.getIntent();
				intent.putExtra("scopes", scopes);
				GoogleApi.handler = handler; // hack: save the handler reference at this point because it cannot be passed to another activity through the intent
				Extension.mainActivity.startActivityForResult(intent, USER_RECOVERABLE_AUTH);
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
			try
			{
				if (resultToken != null)
				{

					JSONObject obj = new JSONObject();
					obj.put("status", "success");
					obj.put("scopes", scopes);
					obj.put("accessToken", resultToken);
					handler.call1("handle", obj.toString());
					return;
				}
				else
				{
					handler.call1("handle", "{\"status\":\"failure\", \"error\":\"no token returned\"}");
					return;
				}
			}
			catch (JSONException ex)
			{
				handler.call1("handle", "{\"status\":\"failure\", \"error\":\"" + ex.toString() + "\"}");
				return;
			}

		}
	}

	////////////////////////////////////////////////////////////////////////
	static public void loadAd()
	{
		AdRequest adRequest = new AdRequest.Builder().build();
		adView.loadAd(adRequest);
	}

	static public void initAd(final String id, final int x, final int y, final int size, final boolean testMode)
	{
		Extension.mainActivity.runOnUiThread(new Runnable()
		{
			public void run()
			{
				String adID = id;
				adTestMode = testMode;

				if (Extension.mainActivity == null)
				{
					return;
				}

				adView = new AdView(Extension.mainActivity);
				adView.setAdUnitId(adID);
				adView.setAdSize(AdSize.SMART_BANNER);

				loadAd();
				adMobLayoutParams = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);

				if (x == 0)
				{
					adMobLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
				}
				else if (x == 1)
				{
					adMobLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
				}
				else if (x == 2)
				{
					adMobLayoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
				}

				if (y == 0)
				{
					adMobLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
				}
				else if (y == 1)
				{
					adMobLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
				}
				else if (y == 2)
				{
					adMobLayoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
				}

				adInitialized = true;
			}
		});
	}

	static public void showAd()
	{
		Log.i("GoogleApi", "showAd");
		Extension.mainActivity.runOnUiThread(new Runnable()
		{
			public void run()
			{
				if (adInitialized && !adVisible)
				{
					adLayout.removeAllViews();
					adView.setBackgroundColor(Color.BLACK);
					adLayout.addView(adView, adMobLayoutParams);
					adView.setBackgroundColor(0);
					adVisible = true;
				}
			}
		});
	}

	static public void hideAd()
	{
		Extension.mainActivity.runOnUiThread(new Runnable()
		{
			public void run()
			{
				if (adInitialized && adVisible)
				{
					adLayout.removeAllViews();
					loadAd();
					adVisible = false;
				}
			}
		});
	}

	static public void loadInterstitial()
	{
		AdRequest adRequest = new AdRequest.Builder().build();
		interstitial.loadAd(adRequest);
	}

	static public void initInterstitial(final String id, final boolean testMode)
	{
		Extension.mainActivity.runOnUiThread(new Runnable()
		{
			public void run()
			{
				if (Extension.mainActivity == null)
				{
					return;
				}

				interstitial = new InterstitialAd(Extension.mainActivity);
				interstitial.setAdUnitId(id);

				loadInterstitial();
			}
		});
	}

	static public void showInterstitial()
	{
		Extension.mainActivity.runOnUiThread(new Runnable()
		{
			public void run()
			{
				if (interstitial.isLoaded())
				{
					interstitial.show();
				}
			}
		});
	}
	///////////////////////////////////////////////////////////////////////////////////////////


}