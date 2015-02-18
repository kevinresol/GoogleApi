#import <GooglePlayGames/GooglePlayGames.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#include <hx/CFFI.h>
#include <SignInDelegate.h>

namespace googleapi 
{
	const char* clientId;

	void authenticate(AutoGCRoot* handler, const char * scopes)
	{
		GPGManager *manager = [GPGManager sharedInstance];
		NSString* _clientId = [NSString stringWithUTF8String:clientId];
		NSArray* scopesArray = [[NSString stringWithUTF8String:scopes] componentsSeparatedByString:@" "];

		manager.statusDelegate = [[SignInDelegate alloc] initWithCompletionHandler:^(NSError* error) {
			if(error)
			{
				NSLog(@"error, retry login");
				[manager signInWithClientID:_clientId silently:NO withExtraScopes:scopesArray];
			}
			else
			{
				GTMOAuth2Authentication* auth = [GPPSignIn sharedInstance].authentication;

				NSDictionary* dict = @{
					@"status": @"success",
					@"scopes": [NSString stringWithUTF8String:scopes],
					@"accessToken": auth.accessToken
				};
		
				NSError* jsonError;
				NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
					options:(NSJSONWritingOptions)(0)
					error:&jsonError];
		
				NSString* jsonResult = @"{}";
		
				if(!jsonData)
					NSLog(@"JSON error: %@", jsonError.localizedDescription);
				else
					jsonResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		

				val_call1(handler->get(), alloc_string(jsonResult.UTF8String));
			}
		}];

		if(![manager signInWithClientID:_clientId silently:YES withExtraScopes:scopesArray])
		{
			[manager signInWithClientID:_clientId silently:NO withExtraScopes:scopesArray];
		}
	}
}
