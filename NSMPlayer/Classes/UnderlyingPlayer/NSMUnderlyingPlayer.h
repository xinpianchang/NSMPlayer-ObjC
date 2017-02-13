//
//  NSMUnderlyingPlayer.h
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

FOUNDATION_EXPORT NSString * const NSMUnderlyingPlayerErrorDomain;

@class NSMVideoAssetInfo, BFTask;

@protocol NSMUnderlyingPlayerProtocol <NSObject>

- (BFTask *)prepare;
- (void)start;
- (void)pause;
- (void)seekToTime:(NSTimeInterval)seconds;
- (void)releasePlayer;

/* Indicates the current audio volume of the player; 0.0 means "silence all audio", 1.0 means "play at the full volume of the current item".
 
 iOS note: Do not use this property to implement a volume slider for media playback. For that purpose, use MPVolumeView, which is customizable in appearance and provides standard media playback behaviors that users expect.
 This property is most useful on iOS to control the volume of the AVPlayer relative to other audio output, not for volume control by end users. */

- (void)adjustVolume:(CGFloat)volum;

/* indicates whether or not audio output of the player is muted. Only affects audio muting for the player instance and not for the device. */
- (void)switchMuted:(BOOL)on;

/**
 adjust rate of playback
 */
- (void)adjustRate:(CGFloat)rate;

- (void)replacePlayerItemWithURL:(NSURL *)url;

@end

@interface NSMUnderlyingPlayer : NSObject <NSMUnderlyingPlayerProtocol>

@end

