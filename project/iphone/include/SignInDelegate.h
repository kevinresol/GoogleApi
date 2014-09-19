#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>

@interface SignInDelegate:NSObject<GPPSignInDelegate, GPGStatusDelegate>
{
	GPPSignIn *signIn;
	AutoGCRoot *mTokenHandler;
}
- (SignInDelegate *)initWithSignIn:(GPPSignIn *) signInObject andTokenHandler:(AutoGCRoot*) tokenHandler;


@end
