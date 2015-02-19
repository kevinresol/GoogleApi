#ifndef ACHIEVEMENTS
#define ACHIEVEMENTS


namespace googleapi {
	namespace achievements {
		void show();
		void increment(const char * achievementId, int numSteps);
		void unlock(const char * achievementId);	
		void setSteps(const char * achievementId, int numSteps);
		void reveal(const char * achievementId);	
	}
}


#endif
