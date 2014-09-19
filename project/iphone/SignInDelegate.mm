#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>
#include <SignInDelegate.h>

@implementation SignInDelegate
- (SignInDelegate* )initWithSignIn:(GPPSignIn *) signInObject
	andTokenHandler:(AutoGCRoot *) tokenHandler
{
	signIn = signInObject;
	mTokenHandler = tokenHandler;
	return [super init];
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
	if(error != nil)
	{
		[signIn authenticate];
	}
	else
	{
		[[GPGManager sharedInstance] signIn];
		NSLog(@"going to call haxe");
		//NSLog(auth.accessToken);
		val_call1(mTokenHandler->get(), alloc_string(auth.accessToken.UTF8String));
	}
}

- (void)didFinishGamesSignInWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while signing in %@", [error localizedDescription]);

    } else {
        NSLog(@"Signed in!");
    }
}
- (void)didFinishGoogleAuthWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while googleAuth %@", [error localizedDescription]);

    } else {
        NSLog(@"Signed in!");
    }
}

- (void)didFinishGamesSignOutWithError:(NSError *)error {
	NSLog(@"didfinishlogout");
}


- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    //[[self navigationController] pushViewController:viewController animated:YES];
}
@end
