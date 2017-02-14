//
//  NSMAVPlayer.h
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//
/* Note that NSNotifications posted by AVPlayerItem may be posted on a different thread from the one on which the observer was registered. */

// notifications                                                                                description
//AVF_EXPORT NSString *const AVPlayerItemTimeJumpedNotification			 NS_AVAILABLE(10_7, 5_0);	// the item's current time has changed discontinuously
//AVF_EXPORT NSString *const AVPlayerItemDidPlayToEndTimeNotification      NS_AVAILABLE(10_7, 4_0);   // item has played to its end time
//AVF_EXPORT NSString *const AVPlayerItemFailedToPlayToEndTimeNotification NS_AVAILABLE(10_7, 4_3);   // item has failed to play to its end time
//AVF_EXPORT NSString *const AVPlayerItemPlaybackStalledNotification       NS_AVAILABLE(10_9, 6_0);    // media did not arrive in time to continue playback
//AVF_EXPORT NSString *const AVPlayerItemNewAccessLogEntryNotification	 NS_AVAILABLE(10_9, 6_0);	// a new access log entry has been added
//AVF_EXPORT NSString *const AVPlayerItemNewErrorLogEntryNotification		 NS_AVAILABLE(10_9, 6_0);	// a new error log entry has been added
//
//// notification userInfo key                                                                    type
//AVF_EXPORT NSString *const AVPlayerItemFailedToPlayToEndTimeErrorKey     NS_AVAILABLE(10_7, 4_3);   // NSError
#import "NSMUnderlyingPlayer.h"

@interface NSMAVPlayer : NSMUnderlyingPlayer

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) NSURL *playerURL;

@end
