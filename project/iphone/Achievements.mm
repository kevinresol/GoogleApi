#include <Achievements.h>
#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>

namespace googleapi {
	namespace achievements {
		void show()
		{
			[[GPGLauncherController sharedInstance] presentAchievementList];
		}

		void increment(const char * achievementId, int numSteps) 
		{
			if([GPGManager sharedInstance].isSignedIn)
			{
			
				[[GPGAchievement achievementWithId:[NSString stringWithUTF8String:achievementId]] incrementAchievementNumSteps:numSteps completionHandler:^(BOOL newlyUnlocked, int currentSteps, NSError *error) 
				{
					if(error) 
					{
						NSLog(@"%@", [error localizedDescription]);
					}
					else if (newlyUnlocked) 
					{
						NSLog(@"incremental unlocked");
					}
					else
					{
						NSLog(@"total steps: %i", currentSteps);
					}
				}];
			}
	
		}
	
		void unlock(const char * achievementId) 
		{	
			if([GPGManager sharedInstance].isSignedIn)
			{
			
				[[GPGAchievement achievementWithId:[NSString stringWithUTF8String:achievementId]] unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) 
				{
					if(error) 
					{
						NSLog(@"%@", [error localizedDescription]);
					}
					else if (newlyUnlocked) 
					{
						NSLog(@"already unlocked");
					}
					else
					{
						NSLog(@"successfully unlocked");
					}
				}];
			}
		}
	
		void setSteps(const char * achievementId, int numSteps) 
		{
			if([GPGManager sharedInstance].isSignedIn)
			{
			
				[[GPGAchievement achievementWithId:[NSString stringWithUTF8String:achievementId]] setSteps:numSteps completionHandler:^(BOOL newlyUnlocked, int currentSteps, NSError *error) 
				{
					if(error) 
					{
						NSLog(@"%@", [error localizedDescription]);
					}
					else if (newlyUnlocked) 
					{
						NSLog(@"set step unlocked");
					}
					else
					{
						NSLog(@"total steps: %i", currentSteps);
					}
				}];
			}	
		}
	
		void reveal(const char * achievementId) 
		{	
			if([GPGManager sharedInstance].isSignedIn)
			{
			
				[[GPGAchievement achievementWithId:[NSString stringWithUTF8String:achievementId]] revealAchievementWithCompletionHandler:^(GPGAchievementState state, NSError *error) 
				{
					if(error) 
					{
						NSLog(@"%@", [error localizedDescription]);
					}
					else
					{
						NSLog(@"successfully revealed");
					}
				}];
			}
	
		}
	}
}

