#include <hx/CFFI.h>
#ifndef GOOGLEAPI_H
#define GOOGLEAPI_H


namespace googleapi {
	
	
    void getToken(const char *clientId, AutoGCRoot *tokenHandler, const char *scope);
	void signInGames(const char *clientId, AutoGCRoot *handler);
	void authenticate();
}


#endif
