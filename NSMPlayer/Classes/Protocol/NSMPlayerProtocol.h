//
//  NSMPlayerProtocol.h
//  Pods
//
//  Created by chengqihan on 2017/2/15.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, NSMVideoPlayerStatus) {
    NSMVideoPlayerStatusInit = 1 << 0,
    NSMVideoPlayerStatusIdle = 1 << 1,// for poster?
    NSMVideoPlayerStatusFailed = 1 << 2, // 随时都可能进入到 Error ,Playing -> error, Preparing -> error,
    NSMVideoPlayerStatusPreparing = 1 << 3, // loadTracks
    NSMVideoPlayerStatusPlaying = 1 << 4, // Playing but not waitBuffering
    NSMVideoPlayerStatusWaitBufferingToPlay = 1 << 5,
    NSMVideoPlayerStatusPaused = 1 << 6, // Paused
    NSMVideoPlayerStatusPlayToEndTime = 1 << 7,//PlayBack to end time
};

@class BFTask, NSMVideoPlayerControllerDataSource;

@protocol NSMPlayerProtocol <NSObject>

@property (nonatomic, readonly, strong) id player;
@property (nonatomic, strong) NSMVideoPlayerControllerDataSource *playerSource;
@property (nonatomic, assign) long duration;
@property (assign, nonatomic, getter=isPreload) BOOL preload;
@property (assign, nonatomic, getter=isAutoPlay) BOOL autoPlay;
@property (assign, nonatomic, getter=isLoopPlayback) BOOL loopPlayback;
@property (nonatomic, assign) NSMVideoPlayerStatus currentStatus;


- (BFTask *)prepare;
- (void)play;
- (void)pause;
- (void)seekToTime:(NSTimeInterval)seconds;
- (void)releasePlayer;

/* Indicates the current audio volume of the player; 0.0 means "silence all audio", 1.0 means "play at the full volume of the current item".
 
 iOS note: Do not use this property to implement a volume slider for media playback. For that purpose, use MPVolumeView, which is customizable in appearance and provides standard media playback behaviors that users expect.
 This property is most useful on iOS to control the volume of the AVPlayer relative to other audio output, not for volume control by end users. */

- (void)setVolume:(CGFloat)volum;

/* indicates whether or not audio output of the player is muted. Only affects audio muting for the player instance and not for the device. */
- (void)setMuted:(BOOL)on;

/**
 adjust rate of playback
 */
- (void)setRate:(CGFloat)rate;


/**
 是否允许3G网络进行播放
 */
- (void)setAllowAllowWWAN:(BOOL)allow;

@end

NS_ASSUME_NONNULL_END
