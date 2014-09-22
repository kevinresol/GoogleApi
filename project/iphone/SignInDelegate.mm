#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>
#include <SignInDelegate.h>

@implementation SignInDelegate
- (SignInDelegate* )initWithSignIn:(GPPSignIn *) signInObject andCompletionHandler:(void(^)(GTMOAuth2Authentication*, NSError*)) handler {
	signIn = signInObject;
	completionHandler = [handler copy];
	return [super init];
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
	if(error != nil)
	{
		NSLog(@"Re-auth");
		[signIn authenticate];
	}
	else
	{
		_auth = auth;
		[GPGManager sharedInstance].statusDelegate = self;
		[[GPGManager sharedInstance] signIn];
		//NSLog(auth.accessToken);
		//val_call1(mTokenHandler->get(), alloc_string(auth.accessToken.UTF8String));
	}
}

- (void)didFinishGamesSignInWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while signing in %@", [error localizedDescription]);

    } else {
        NSLog(@"GPG justSigned in!");
		NSLog(@"going to callback");
		completionHandler(_auth, error);
    }
}
- (void)didFinishGoogleAuthWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while googleAuth %@", [error localizedDescription]);

    } else {
        NSLog(@"G{G Signed in (Auth)!");
		NSLog(@"going to callback");
		completionHandler(_auth, error);
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
