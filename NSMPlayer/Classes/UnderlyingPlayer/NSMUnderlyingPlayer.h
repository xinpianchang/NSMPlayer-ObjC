//
//  NSMUnderlyingPlayer.h
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NSMUnderlyingPlayerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const NSMUnderlyingPlayerErrorDomain;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerDidPlayToEndTimeNotification;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerFailedNotification;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerLoadedTimeRangesDidChangeNotification;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPlaybackBufferEmptyNotification;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPlayheadDidChangeNotification;

// notification userInfo key
FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPeriodicPlayTimeChangeKey;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerErrorKey;// NSError

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerLoadedTimeRangesKey;//NSValue [CMTimeRange]

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPlaybackLikelyToKeepUpKey;// NSNumber BOOL

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPlaybackBufferEmptyKey;// NSNumber BOOL



@interface NSMUnderlyingPlayer : NSObject <NSMUnderlyingPlayerProtocol>


@end

NS_ASSUME_NONNULL_END
