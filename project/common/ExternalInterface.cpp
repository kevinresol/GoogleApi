#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "GoogleApi.h"
#include "Admob.h"
#include "Achievements.h"


static value googleapi_init(value val_clientId)
{
	googleapi::clientId = val_get_string(val_clientId);
	return alloc_null();
}
DEFINE_PRIM(googleapi_init, 1);

static value googleapi_authenticate(value scopes, value handler)
{
	googleapi::authenticate(new AutoGCRoot(handler), val_get_string(scopes));
	return alloc_null();
}
DEFINE_PRIM(googleapi_authenticate, 2);

extern "C" void googleapi_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (googleapi_main);



extern "C" int googleapi_register_prims () { return 0; }

// Google ads

value admob_ad_init(value id, value x, value y, value size, value testMode) {
	admob::initAd(val_string(id), val_int(x), val_int(y), val_int(size), val_bool(testMode));
	return alloc_null();
}
DEFINE_PRIM(admob_ad_init, 5);

value admob_ad_show() {
	admob::showAd();
	return alloc_null();
}
DEFINE_PRIM(admob_ad_show, 0);

value admob_ad_hide() {
	admob::hideAd();
	return alloc_null();
}
DEFINE_PRIM(admob_ad_hide,0);

value admob_ad_refresh() {
	admob::refreshAd();
	return alloc_null();
}
DEFINE_PRIM(admob_ad_refresh,0);

value admob_ad_init_interstitial(value id, value testMode) {
	admob::initInterstitial(val_string(id), val_bool(testMode));
	return alloc_null();
}
DEFINE_PRIM(admob_ad_init_interstitial, 2);

value admob_ad_show_interstitial() {
	admob::showInterstitial();
	return alloc_null();
}
DEFINE_PRIM(admob_ad_show_interstitial, 0);

// Games Achievements
value achievements_unlock(value id) { 
	googleapi::achievements::unlock(val_string(id));
	return alloc_null();
}
DEFINE_PRIM(achievements_unlock, 1);

value achievements_increment(value id, value numSteps) { 
	googleapi::achievements::increment(val_string(id), val_int(numSteps));
	return alloc_null();
}
DEFINE_PRIM(achievements_increment, 2);

value achievements_setSteps(value id, value numSteps) { 
	googleapi::achievements::setSteps(val_string(id), val_int(numSteps));
	return alloc_null();
}
DEFINE_PRIM(achievements_setSteps, 2);

value achievements_reveal(value id) { 
	googleapi::achievements::reveal(val_string(id));
	return alloc_null();
}
DEFINE_PRIM(achievements_reveal, 1);
