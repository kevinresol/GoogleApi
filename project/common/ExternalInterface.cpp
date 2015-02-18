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

static value googleapi_init(value val_clientId)
{
	clientId = val_get_string(val_clientId);
	return val_null;
}
DEFINE_PRIM(googleapi_init, 1);

static value googleapi_authenticate(value scopes, value handler)
{
	authenticate(new AutoGCRoot(handler), val_get_string(scopes));
	return val_null;
}
DEFINE_PRIM(googleapi_authenticate, 2);

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

value achievements_increment(value id, value numSteps) { 
	increment(val_string(id), val_int(numSteps));
	return alloc_null();
}
DEFINE_PRIM(achievements_increment, 2);

value achievements_setSteps(value id, value numSteps) { 
	setSteps(val_string(id), val_int(numSteps));
	return alloc_null();
}
DEFINE_PRIM(achievements_setSteps, 2);

value achievements_reveal(value id) { 
	reveal(val_string(id));
	return alloc_null();
}
DEFINE_PRIM(achievements_reveal, 1);
