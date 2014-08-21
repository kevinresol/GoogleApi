#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"


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
