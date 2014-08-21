//
// Google Play Games Platform Services
// Copyright 2013 Google Inc. All rights reserved.
//
#import "GPGKeyedModel.h"

@class GPGAchievementModel;
@class GPGAppStateModel;
@class GPGGameMetadataModel;
@class GPGLeaderboardModel;
@class GPGPlayerModel;
@class GPGTurnBasedModel;

extern NSString *const GPGModelAchievementIncremented;
extern NSString *const GPGModelAllAchievementMetadataKey;
extern NSString *const GPGModelAllLeaderboardMetadataKey;
extern NSString *const GPGModelAllMatchesKey;
extern NSString *const GPGModelAllPlayerAchievementsKey;
extern NSString *const GPGModelConnectedPlayersKey;
extern NSString *const GPGModelGameMetadataKey;
extern NSString *const GPGModelGetAllAppStateKey;
extern NSString *const GPGModelLocalPlayerKey;
extern NSString *const GPGModelRecentlyPlayedPlayerKey;

@interface GPGApplicationModel : GPGKeyedModel

// Designated initializer
- (id)initWithApplicationId:(NSString *)applicationId;

#pragma mark Models 
// Models
@property(nonatomic, readonly, strong) GPGAchievementModel *achievement;

@property(nonatomic, readonly, strong) GPGGameMetadataModel *application;

@property(nonatomic, readonly, strong) GPGLeaderboardModel *leaderboard;

@property(nonatomic, readonly, strong) GPGPlayerModel *player;

@property(nonatomic, readonly, strong) GPGAppStateModel *appState;

@property(nonatomic, readonly, strong) GPGTurnBasedModel *turnBased;

@end

