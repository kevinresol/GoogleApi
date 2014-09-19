#include <hx/CFFI.h>
#ifndef GOOGLEAPI_H
#define GOOGLEAPI_H


namespace googleapi {
	
	
	int SampleMethod(int inputValue);
	bool TestGoogle();
    void getToken(const char *clientId, AutoGCRoot *tokenHandler, const char *scope);
	void signInGames(const char *clientId, AutoGCRoot *handler);
	
}


#endif
