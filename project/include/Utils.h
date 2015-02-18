#include <hx/CFFI.h>
#ifndef GOOGLEAPI_H
#define GOOGLEAPI_H


namespace googleapi {
	
	extern const char* clientId;

	void authenticate(AutoGCRoot* handler, const char * scopes);
}


#endif
