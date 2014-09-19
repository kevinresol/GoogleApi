#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <NMEAppDelegate.h>
#include <hx/CFFI.h>



@implementation NMEAppDelegate(TestGoogle)
- (BOOL) application:(UIApplication *) application
openURL:(NSURL *)url
sourceApplication: (NSString *) sourceApplication
annotation: (id)annotation
{
	return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}
@end
