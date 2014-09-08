#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>


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

///////////////////////////////////
@interface SignInDelegate:NSObject<GPPSignInDelegate>
{
	GPPSignIn *signIn;
	AutoGCRoot *mTokenHandler;
}
- (SignInDelegate *)initWithSignIn:(GPPSignIn *) signInObject andTokenHandler:(AutoGCRoot*) tokenHandler; 

@end

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
		//[[GPGManager sharedInstance] signIn];
		NSLog(@"going to call haxe");
		//NSLog(auth.accessToken);
		val_call1(mTokenHandler->get(), alloc_string(auth.accessToken.UTF8String));
	}
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    //[[self navigationController] pushViewController:viewController animated:YES];
}
@end

namespace googleapi 
{
	static NSString * const kClientID = @"465309657593-k7ia3okdnditnrru3vnc7nq6omq6gb92.apps.googleusercontent.com";
	
	bool TestGoogle()
    {
        return true;
    }
   
    void getToken(AutoGCRoot * tokenHandler, const char * scope)
	{
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
		signIn.shouldFetchGoogleUserID = YES;
		signIn.clientID = kClientID;
		signIn.scopes = @[kGTLAuthScopePlusLogin, [[NSString alloc] initWithUTF8String:scope]];
		signIn.delegate = [[SignInDelegate alloc] initWithSignIn:signIn andTokenHandler:tokenHandler];
		if(![signIn trySilentAuthentication])
			[signIn authenticate];
    }
}
