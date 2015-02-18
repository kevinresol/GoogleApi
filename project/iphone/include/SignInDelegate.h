#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>

@interface SignInDelegate:NSObject<GPGStatusDelegate>
{
	void (^completionHandler)(NSError *error);
}
- (SignInDelegate *)initWithCompletionHandler:(void(^)(NSError*)) handler;


@end
