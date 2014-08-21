#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>

@interface NMEAppDelegate:NSObject <UIApplicationDelegate>
@end

@implementation NMEAppDelegate(TestGoogle)
- (BOOL) application:(UIApplication *) application
openURL:(NSURL *)url
sourceApplication: (NSString *) sourceApplication
annotation: (id)annotation
{
	return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}
@end

namespace googleapi 
{
	static NSString * const kClientID = @"465309657593-k7ia3okdnditnrru3vnc7nq6omq6gb92.apps.googleusercontent.com";
	
	bool TestGoogle()
    {
        return true;
    }
    
    void Init()
	{
		[[GPGManager sharedInstance] signInWithClientID:kClientID silently:NO];
        
    }
}
