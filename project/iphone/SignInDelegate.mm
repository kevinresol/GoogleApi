#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>
#include <SignInDelegate.h>

@implementation SignInDelegate
- (SignInDelegate* )initWithCompletionHandler:(void(^)(NSError*)) handler {
	
	completionHandler = [handler copy];
	return [super init];
}

// called when sign in google play games
- (void)didFinishGamesSignInWithError:(NSError *)error {
    /*if (error) {
        NSLog(@"Received an error while signing in %@", [error localizedDescription]);

    } else {
        NSLog(@"GPG justSigned in!");
		NSLog(@"going to callback");

		if(!completionHandler)
			NSLog(@"null handler");

		completionHandler(error);
		[completionHandler release];
    }*/
}

// called when sign in google+
- (void)didFinishGoogleAuthWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while googleAuth %@", [error localizedDescription]);
    } else {
        NSLog(@"Google+ Signed in!");
    }
    completionHandler(error);
}

- (void)didFinishGamesSignOutWithError:(NSError *)error {
	NSLog(@"didfinishlogout");
}


- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    //[[self navigationController] pushViewController:viewController animated:YES];
}
@end
