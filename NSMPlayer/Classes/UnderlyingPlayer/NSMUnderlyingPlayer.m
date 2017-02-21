//
//  NSMUnderlyingPlayer.m
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//

#import "NSMUnderlyingPlayer.h"
#import "NSMPlayerAsset.h"

NSString * const NSMUnderlyingPlayerErrorDomain = @"NSMUnderlyingPlayerErrorDomain";

 NSString *const NSMUnderlyingPlayerDidPlayToEndTimeNotification = @"NSMUnderlyingPlayerDidPlayToEndTimeNotification";

NSString *const NSMUnderlyingPlayerFailedNotification = @"NSMUnderlyingPlayerFailedNotification";

 NSString *const NSMUnderlyingPlayerLoadedTimeRangesDidChangeNotification = @"NSMUnderlyingPlayerLoadedTimeRangesDidChangeNotification";

NSString *const NSMUnderlyingPlayerPlaybackBufferEmptyNotification = @"NSMUnderlyingPlayerPlaybackBufferEmptyNotification";

NSString *const NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification = @"NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification";

NSString *const NSMUnderlyingPlayerPlaybackStallingNotification = @"NSMUnderlyingPlayerPlaybackStallingNotification";

//NSString *const NSMUnderlyingPlayerPlayheadDidChangeNotification = @"NSMUnderlyingPlayerPlayheadDidChangeNotification";

//NSString *const NSMUnderlyingPlayerPeriodicPlayTimeChangeKey = @"NSMUnderlyingPlayerPeriodicPlayTimeChangeKey";

NSString *const NSMUnderlyingPlayerErrorKey = @"NSMUnderlyingPlayerErrorKey";

//NSString *const NSMUnderlyingPlayerLoadedTimeRangesKey = @"NSMUnderlyingPlayerErrorKey";

//NSString *const NSMUnderlyingPlayerPlaybackLikelyToKeepUpKey = @"NSMUnderlyingPlayerPlaybackLikelyToKeepUpKey";

//NSString *const NSMUnderlyingPlayerPlaybackBufferEmptyKey = @"NSMUnderlyingPlayerPlaybackBufferEmptyKey";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"


@implementation NSMUnderlyingPlayer

@dynamic currentStatus, currentAsset, loopPlayback, autoPlay, preload, muted, rate, volume, allowWWAN, playerType, playerView;

#pragma clang diagnostic pop

@end
