//
// Google Play Games Platform Services
// Copyright 2013 Google Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "GPGEnums.h"

@protocol GPGLeaderboardControllerDelegate;

@interface GPGLeaderboardController : UINavigationController

- (id)initWithLeaderboardId:(NSString *)leaderboardId;

#pragma mark Properties 

@property(nonatomic, assign) GPGLeaderboardTimeScope timeScope; // Default: GPGLeaderboardTimeScopeAllTime
@property(nonatomic, weak) id<GPGLeaderboardControllerDelegate> leaderboardDelegate;

@end

@protocol GPGLeaderboardControllerDelegate <NSObject>
 @required

- (void)leaderboardViewControllerDidFinish:(GPGLeaderboardController *)viewController;

@end
