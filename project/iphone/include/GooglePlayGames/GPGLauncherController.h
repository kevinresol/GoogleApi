//
// Google Play Games Platform Services
// Copyright 2013 Google Inc. All rights reserved.
//
#import "GPGEnums.h"

@class GPGQuest;
@class GPGQuestMilestone;
@class GPGSnapshotMetadata;
@class GPGTurnBasedMatch;

@protocol GPGLauncherDelegate;
@protocol GPGPlayerPickerLauncherDelegate;
@protocol GPGQuestListLauncherDelegate;
@protocol GPGSnapshotListLauncherDelegate;
@protocol GPGTurnBasedMatchListLauncherDelegate;

@interface GPGLauncherController : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, weak) id<GPGLauncherDelegate> launcherDelegate;

@property(nonatomic, weak) id<GPGPlayerPickerLauncherDelegate> playerPickerLauncherDelegate;

@property(nonatomic, weak)
    id<GPGTurnBasedMatchListLauncherDelegate> turnBasedMatchListLauncherDelegate;

@property(nonatomic, weak) id<GPGQuestListLauncherDelegate> questListLauncherDelegate;

@property(nonatomic, weak) id<GPGSnapshotListLauncherDelegate> snapshotListLauncherDelegate;

@property(nonatomic, readonly, assign) GPGLauncherType presentingLauncherType;

- (void)presentPlayerPicker;

- (void)presentTurnBasedMatchList;

- (void)presentQuestList;

- (void)presentQuestListWithQuestId:(NSString *)questId;

- (void)presentSnapshotList;

- (void)presentLeaderboardWithLeaderboardId:(NSString *)leaderboardId;

- (void)presentLeaderboardList;

@end

@protocol GPGLauncherDelegate<NSObject>

- (UIViewController *)presentingViewControllerForLauncher;

@optional

- (void)launcherWillAppear;

- (void)launcherDidAppear;

- (void)launcherWillDisappear;

- (void)launcherDidDisappear;

@end

@protocol GPGPlayerPickerLauncherDelegate<NSObject>

- (int)minPlayersForPlayerPickerLauncher;

- (int)maxPlayersForPlayerPickerLauncher;

- (void)playerPickerLauncherDidPickPlayers:(NSArray *)players
                       autoPickPlayerCount:(int)autoPickPlayerCount;

@end

@protocol GPGTurnBasedMatchListLauncherDelegate<NSObject>

- (void)turnBasedMatchListLauncherDidJoinMatch:(GPGTurnBasedMatch *)match;

- (void)turnBasedMatchListLauncherDidTakeTurnForMatch:(GPGTurnBasedMatch *)match;

- (void)turnBasedMatchListLauncherDidRematch:(GPGTurnBasedMatch *)match;

@optional

- (void)turnBasedMatchListLauncherDidDeclineMatch:(GPGTurnBasedMatch *)match;

- (BOOL)turnBasedMatchListLauncherShouldSelectMatch:(GPGTurnBasedMatch *)match;

- (void)turnBasedMatchListLauncherDidSelectMatch:(GPGTurnBasedMatch *)match;

@end

@protocol GPGQuestListLauncherDelegate<NSObject>

- (void)questListLauncherDidAcceptQuest:(GPGQuest *)quest;

- (void)questListLauncherDidClaimRewardsForQuestMilestone:(GPGQuestMilestone *)milestone;

@optional

- (BOOL)questListLauncherShouldShowQuest:(GPGQuest *)quest;

@end

@protocol GPGSnapshotListLauncherDelegate<NSObject>

- (void)snapshotListLauncherDidTapSnapshotMetadata:(GPGSnapshotMetadata *)snapshot;

- (void)snapshotListLauncherDidCreateNewSnapshot;

@optional

- (NSString *)titleForSnapshotListLauncher;

- (BOOL)shouldAllowCreateForSnapshotListLauncher;

- (BOOL)shouldAllowDeleteForSnapshotListLauncher;

- (int)maxSaveSlotsForSnapshotListLauncher;

@end
