#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>
#include <SignInDelegate.h>

namespace googleapi 
{
    void getToken(const char *clientId, AutoGCRoot * handler, const char * scope)
	{
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
		signIn.shouldFetchGoogleUserID = YES;
		signIn.clientID = [[NSString alloc] initWithUTF8String:clientId];
		signIn.scopes = @[[[NSString alloc] initWithUTF8String:scope]];
		signIn.delegate = [[SignInDelegate alloc] initWithSignIn:signIn andCompletionHandler:^(GTMOAuth2Authentication* auth, NSError* error) {
			val_call1(handler->get(),  alloc_string(auth.accessToken.UTF8String));
		}];
		if(![signIn trySilentAuthentication])
			[signIn authenticate];
    }
	
	void signInGames(const char *clientId, AutoGCRoot *handler)
	{
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
		signIn.shouldFetchGoogleUserID = YES;
		signIn.clientID = [[NSString alloc] initWithUTF8String:clientId];
		signIn.scopes = @[kGTLAuthScopePlusLogin, @"https://www.googleapis.com/auth/games"];
		signIn.delegate = [[SignInDelegate alloc] initWithSignIn:signIn andCompletionHandler:^(GTMOAuth2Authentication* auth, NSError* error) {
			val_call1(handler->get(), alloc_string("done"));
		}];
		if(![signIn trySilentAuthentication])
			[signIn authenticate];
	}
}
