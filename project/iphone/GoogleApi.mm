#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>
#include <SignInDelegate.h>

namespace googleapi 
{
    void getToken(const char *clientId, AutoGCRoot * handler, const char * scope)
	{
		NSLog(@"GoogleApi.mm getToken");
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
		signIn.shouldFetchGoogleUserID = YES;
		signIn.clientID = [[NSString alloc] initWithUTF8String:clientId];
		signIn.scopes = @[[[NSString alloc] initWithUTF8String:scope]];
		signIn.delegate = [[SignInDelegate alloc] initWithSignIn:signIn andCompletionHandler:^(GTMOAuth2Authentication* auth, NSError* error) {
			val_call1(handler->get(),  alloc_string(auth.accessToken.UTF8String));
		}];	
		NSLog(@"cpp before authenticate");
		if(![signIn trySilentAuthentication])
			[signIn authenticate];
		NSLog(@"cpp after authenticate");
    }
	
	void signInGames(const char *clientId, AutoGCRoot *handler)
	{
		NSLog(@"GoogleApi.mm signInGames");
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
		signIn.shouldFetchGoogleUserID = YES;
		signIn.clientID = [[NSString alloc] initWithUTF8String:clientId];
		signIn.scopes = @[kGTLAuthScopePlusLogin, @"https://www.googleapis.com/auth/games"];
		signIn.attemptSSO = NO;
		signIn.delegate = [[SignInDelegate alloc] initWithSignIn:signIn andCompletionHandler:^(GTMOAuth2Authentication* auth, NSError* error) {
			val_call1(handler->get(), alloc_string("done"));
		}];



		if(signIn.delegate != nil)
			NSLog(@"signIn.delegate != nil");

		NSLog(signIn.clientID);

		if(![signIn trySilentAuthentication])
		{
			NSLog(@"GoogleApi.mm trySilentAuthentication failed");
			[signIn authenticate];
		}
		else
		{
			NSLog(@"GoogleApi.mm trySilentAuthentication success");
		}
	}

	void authenticate()
	{
		if(![GPPSignIn sharedInstance].authentication)
			[[GPPSignIn sharedInstance] authenticate];
	}
}
