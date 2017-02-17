//
//  NSMUnderlyingPlayer.h
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NSMPlayerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const NSMUnderlyingPlayerErrorDomain;

// item has played to its end time
FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerDidPlayToEndTimeNotification;

// item has played to its end time
FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerFailedNotification;

// item has played to its end time
FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerLoadedTimeRangesDidChangeNotification;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPlaybackBufferEmptyNotification;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPlayheadDidChangeNotification;

// notification userInfo key                                                                    type
FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerPeriodicPlayTimeChangeKey;

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerErrorKey;//NSError

FOUNDATION_EXPORT NSString *const NSMUnderlyingPlayerLoadedTimeRangesKey;//NSValue[CMTimeRange]

//AVF_EXPORT NSString *const AVPlayerItemDidPlayToEndTimeNotification      NS_AVAILABLE(10_7, 4_0);
//AVF_EXPORT NSString *const AVPlayerItemFailedToPlayToEndTimeNotification NS_AVAILABLE(10_7, 4_3);   // item has failed to play to its end time
//AVF_EXPORT NSString *const AVPlayerItemPlaybackStalledNotification       NS_AVAILABLE(10_9, 6_0);    // media did not arrive in time to continue playback
//AVF_EXPORT NSString *const AVPlayerItemNewAccessLogEntryNotification	 NS_AVAILABLE(10_9, 6_0);	// a new access log entry has been added
//AVF_EXPORT NSString *const AVPlayerItemNewErrorLogEntryNotification		 NS_AVAILABLE(10_9, 6_0);	// a new error log entry has been added
//
//// notification userInfo key                                                                    type
//AVF_EXPORT NSString *const AVPlayerItemFailedToPlayToEndTimeErrorKey     NS_AVAILABLE(10_7, 4_3);   // NSError

@protocol NSMVideoPlayerViewProtocol;

@class NSMVideoAssetInfo, BFTask, NSMVideoPlayerControllerDataSource;

@protocol NSMUnderlyingPlayerProtocol <NSMPlayerProtocol>


//- (void)replacePlayerItemWithURL:(NSURL *)url;

@end

@interface NSMUnderlyingPlayer : NSObject <NSMUnderlyingPlayerProtocol>

@property (nonatomic, strong) NSURL *playerURL;
//- (instancetype)initWithAssetURL:(NSURL *)assetURL NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
