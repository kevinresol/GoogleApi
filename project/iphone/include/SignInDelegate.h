#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>

@interface SignInDelegate:NSObject<GPPSignInDelegate, GPGStatusDelegate>
{
	GPPSignIn *signIn;
	GTMOAuth2Authentication *_auth;
	void (^completionHandler)(GTMOAuth2Authentication *auth, NSError *error);
}
- (SignInDelegate *)initWithSignIn:(GPPSignIn *) signInObject andCompletionHandler:(void(^)(GTMOAuth2Authentication*, NSError*)) handler;


@end
