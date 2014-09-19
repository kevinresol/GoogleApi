#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"
#include "AD.h"
#include "Achievements.h"


using namespace googleapi;

AutoGCRoot *mDebugHandler      = 0;
AutoGCRoot *mAccountNameHandler = 0;
AutoGCRoot *mTokenHandler      = 0;
const char *mClientId;


static value googleapi_sample_method (value inputValue) {
	
	int returnValue = SampleMethod(val_int(inputValue));
	return alloc_int(returnValue);
	
}
DEFINE_PRIM (googleapi_sample_method, 1);

static value googleapi_init(value accountNameHandler, value debugHandler, value clientId)
{
	val_check_function(accountNameHandler, 1);
	val_check_function(debugHandler, 1);

	mAccountNameHandler = new AutoGCRoot(accountNameHandler);
	mDebugHandler = new AutoGCRoot(debugHandler);
	mClientId = val_string(clientId);
	signInGames(mClientId);	
	//We don't need the account name on ios, so just let haxe know we are ready here
	val_call1(mAccountNameHandler->get(), alloc_string(mClientId)); 
	return val_null;
}
DEFINE_PRIM(googleapi_init, 3);

static value googleapi_get_token(value tokenHandler, value scope)
{
	val_check_function(tokenHandler, 1);
	val_call1(mDebugHandler->get(),alloc_string("pre"));
	mTokenHandler = new AutoGCRoot(tokenHandler);
	val_call1(mDebugHandler->get(),alloc_string("post"));
	//getToken(mTokenHandler, val_get_string(scope));
	getToken(mClientId, mTokenHandler, val_get_string(scope));
	return val_null;
}
DEFINE_PRIM(googleapi_get_token, 2);

extern "C" void googleapi_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (googleapi_main);



extern "C" int googleapi_register_prims () { return 0; }

// Google ads

value admob_ad_init(value id, value x, value y, value size, value testMode) {
	initAd(val_string(id), val_int(x), val_int(y), val_int(size), val_bool(testMode));
	return alloc_null();
}
DEFINE_PRIM(admob_ad_init, 5);

value admob_ad_show() {
	showAd();
	return alloc_null();
}
DEFINE_PRIM(admob_ad_show, 0);

value admob_ad_hide() {
	hideAd();
	return alloc_null();
}
DEFINE_PRIM(admob_ad_hide,0);

value admob_ad_refresh() {
	refreshAd();
	return alloc_null();
}
DEFINE_PRIM(admob_ad_refresh,0);

value admob_ad_init_interstitial(value id, value testMode) {
	initInterstitial(val_string(id), val_bool(testMode));
	return alloc_null();
}
DEFINE_PRIM(admob_ad_init_interstitial, 2);

value admob_ad_show_interstitial() {
	showInterstitial();
	return alloc_null();
}
DEFINE_PRIM(admob_ad_show_interstitial, 0);

// Games Achievements
value achievements_unlock(value id) { 
	unlock(val_string(id));
	return alloc_null();
}
DEFINE_PRIM(achievements_unlock, 1);
