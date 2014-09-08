#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"
#include "AD.h"


using namespace googleapi;

AutoGCRoot *mDebugHandler      = 0;
AutoGCRoot *mAccountNameHandler = 0;
AutoGCRoot *mTokenHandler      = 0;



static value googleapi_sample_method (value inputValue) {
	
	int returnValue = SampleMethod(val_int(inputValue));
	return alloc_int(returnValue);
	
}
DEFINE_PRIM (googleapi_sample_method, 1);

static value googleapi_test_google () {
	bool r = TestGoogle();
	if(r) return val_true;
       	else return val_false;
}
DEFINE_PRIM (googleapi_test_google, 0);

static value googleapi_init(value accountNameHandler, value debugHandler)
{
	val_check_function(accountNameHandler, 1);
	val_check_function(debugHandler, 1);

	mAccountNameHandler = new AutoGCRoot(accountNameHandler);
	mDebugHandler = new AutoGCRoot(debugHandler);

	//pretend ready
	const char *readyMessage = "ready";
	val_call1(mAccountNameHandler->get(), alloc_string(readyMessage)); 
	return val_null;
}
DEFINE_PRIM(googleapi_init, 2);

static value googleapi_get_token(value tokenHandler, value scope)
{
	val_check_function(tokenHandler, 1);
	mTokenHandler = new AutoGCRoot(tokenHandler);
	//getToken(mTokenHandler, val_get_string(scope));
	getToken(mTokenHandler, val_get_string(scope));
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
