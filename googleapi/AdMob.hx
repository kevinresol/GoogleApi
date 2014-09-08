package googleapi;

#if ios
import cpp.Lib;
#end

#if android
import openfl.utils.JNI;
#end

/**
 * From:
 * https://github.com/mkorman9/admob-openfl
 */

class AdMob {
	public static var LEFT:Int = 0;
	public static var RIGHT:Int = 1;
	public static var CENTER:Int = 2;
	public static var TOP:Int = 0;
	public static var BOTTOM:Int = 1;
	
	public static var BANNER_PORTRAIT:Int = 0;
	public static var BANNER_LANDSCAPE:Int = 1;
	
	private static var admobID:String;
	private static var originX:Int = 0;
	private static var originY:Int = 0;
	private static var bannerSize:Int = 0;
	private static var testMode:Bool = false;

	private static var admobInterstitialID:String;
	private static var testModeInterstitial:Bool;


	public static function init(id:String, x:Int = 0, y:Int = 0, size:Int = 0, test:Bool = false) {
		admobID = id;
		originX = x;
		originY = y;
		bannerSize = size;
		testMode = test;
		
		admob_ad_init(admobID, originX, originY, bannerSize, testMode);
	}
	
	public static function show():Void {
		admob_ad_show();
	}
	
	public static function hide():Void {
		admob_ad_hide();
	}
	
	public static function refresh():Void {
		#if ios
		admob_ad_refresh();
		#end
	}

	public static function initInterstitial(id:String, test:Bool = false) {
		admobInterstitialID = id;
		testModeInterstitial = test;

		admob_ad_init_interstitial(admobInterstitialID, testModeInterstitial);
	}

	public static function showInterstitial():Void {
		admob_ad_show_interstitial();
	}

	#if ios
	private static var admob_ad_init = Lib.load("admob", "admob_ad_init", 5);
	private static var admob_ad_show = Lib.load("admob", "admob_ad_show", 0);
	private static var admob_ad_hide = Lib.load("admob", "admob_ad_hide", 0);
	private static var admob_ad_refresh = Lib.load("admob", "admob_ad_refresh", 0);
	private static var admob_ad_init_interstitial = Lib.load("admob", "admob_ad_init_interstitial", 2);
	private static var admob_ad_show_interstitial = Lib.load("admob", "admob_ad_show_interstitial", 0);
	#end
	
	#if android
	private static var admob_ad_init = JNI.createStaticMethod("org.haxe.extension.GoogleApi", "initAd", "(Ljava/lang/String;IIIZ)V");
	private static var admob_ad_show = JNI.createStaticMethod("org.haxe.extension.GoogleApi", "showAd", "()V");
	private static var admob_ad_hide = JNI.createStaticMethod("org.haxe.extension.GoogleApi", "hideAd", "()V");
	private static var admob_ad_init_interstitial = JNI.createStaticMethod("org.haxe.extension.GoogleApi", "initInterstitial", "(Ljava/lang/String;Z)V");
	private static var admob_ad_show_interstitial = JNI.createStaticMethod("org.haxe.extension.GoogleApi", "showInterstitial", "()V");
	#end

}