#include <Achievements.h>
#include <Utils.h>
#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>

namespace googleapi {
	
	void increment(const char * id, int numSteps) {
		
	}

	void unlock(const char * id) {	
		NSString *achievementId = [[NSString alloc] initWithUTF8String:id];
		NSLog(@"unlock: %@", achievementId);
		//TODO need signin google first
		//signInGames();
		if([GPPSignIn sharedInstance].authentication != nil)
			NSLog(@"gpp signed in");
		else
			NSLog(@"gpp not signed in");
			
		if([GPGManager sharedInstance].isSignedIn)
			NSLog(@"gpg signed in");
		else
			NSLog(@"gpg not signed in");

		return;
		[[GPGAchievement achievementWithId:achievementId] unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
			if(error) 
			{
				NSLog(@"%@", [error localizedDescription]);
			}
			else if (!newlyUnlocked) 
			{
				NSLog(@"already unlocked");
			}
			else
			{
				NSLog(@"successfully unlocked");
			}
		}];
	}

	void setSteps(const char * id, int numSteps) {

	}

	void reveal(const char * id) {

	}

}

