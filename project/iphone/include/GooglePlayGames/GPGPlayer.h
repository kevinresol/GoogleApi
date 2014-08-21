//
// Google Play Games Platform Services
// Copyright 2013 Google Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@class GPGPlayerLevel;

@interface GPGPlayer : NSObject

@property(nonatomic, readonly, copy) NSURL *imageUrl;

@property(nonatomic, readonly, copy) NSString *displayName;

@property(nonatomic, readonly, copy) NSString *playerId;

@property(nonatomic, readonly, copy) NSString *title;

@property(nonatomic, readonly, assign) int64_t currentExperiencePoints;

@property(nonatomic, readonly, assign) int64_t lastLevelUpTimestamp;

@property(nonatomic, readonly, copy) GPGPlayerLevel *currentLevel;
@property(nonatomic, readonly, copy) GPGPlayerLevel *nextLevel;


@end

