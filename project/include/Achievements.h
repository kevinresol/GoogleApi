#ifndef ACHIEVEMENTS
#define ACHIEVEMENTS


namespace googleapi {
	
	void increment(const char * id, int numSteps);
	void unlock(const char * id);	
	void setSteps(const char * id, int numSteps);
	void reveal(const char * id);	

}


#endif
