#include <Achievements.h>
#include <Utils.h>
#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>

namespace googleapi {
	
	void increment(const char * id, int numSteps) 
	{
		NSString *achievementId = [[NSString alloc] initWithUTF8String:id];
		
		if([GPGManager sharedInstance].isSignedIn)
		{
		
			[[GPGAchievement achievementWithId:achievementId] incrementAchievementNumSteps:numSteps completionHandler:^(BOOL newlyUnlocked, int currentSteps, NSError *error) 
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

	void unlock(const char * id) 
	{	
		NSString *achievementId = [[NSString alloc] initWithUTF8String:id];
			
		if([GPGManager sharedInstance].isSignedIn)
		{
		
			[[GPGAchievement achievementWithId:achievementId] unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) 
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

	void setSteps(const char * id, int numSteps) 
	{
		NSString *achievementId = [[NSString alloc] initWithUTF8String:id];
		
		if([GPGManager sharedInstance].isSignedIn)
		{
		
			[[GPGAchievement achievementWithId:achievementId] setSteps:numSteps completionHandler:^(BOOL newlyUnlocked, int currentSteps, NSError *error) 
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

	void reveal(const char * id) 
	{
		NSString *achievementId = [[NSString alloc] initWithUTF8String:id];
			
		if([GPGManager sharedInstance].isSignedIn)
		{
		
			[[GPGAchievement achievementWithId:achievementId] revealAchievementWithCompletionHandler:^(GPGAchievementState state, NSError *error) 
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

