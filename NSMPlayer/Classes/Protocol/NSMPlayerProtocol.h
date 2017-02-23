//
//  NSMPlayerProtocol.h
//  Pods
//
//  Created by chengqihan on 2017/2/15.
//
//

#import <Foundation/Foundation.h>
#import "NSMVideoPlayerViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const NSMVideoPlayerRestorationKey; //NSMPlayerRestoration

typedef NS_ENUM(NSUInteger, NSMVideoPlayerType) {
    NSMVideoPlayerAVPlayer = 1,
    NSMVideoPlayerIJKPlayer,
};

typedef NS_OPTIONS(NSUInteger, NSMVideoPlayerStatus) {
    NSMVideoPlayerStatusInit = 1 << 0,
    NSMVideoPlayerStatusIdle = 1 << 1,// for poster?
    NSMVideoPlayerStatusFailed = 1 << 2, // 随时都可能进入到 Error ,Playing -> error, Preparing -> error,
    NSMVideoPlayerStatusPreparing = 1 << 3, // loadTracks
    NSMVideoPlayerStatusPlaying = 1 << 4, // Playing but not waitBuffering
    NSMVideoPlayerStatusWaitBufferingToPlay = 1 << 5,
    NSMVideoPlayerStatusPaused = 1 << 6, // Paused
    NSMVideoPlayerStatusPlayToEndTime = 1 << 7,//PlayBack to end time
    NSMVideoPlayerStatusUnknown = 1 << 8,
};

typedef NS_ENUM(NSUInteger, NSMVideoPlayerStatusLevel) {
    /** 播放器正在不能工作的状态下 */
    NSMVideoPlayerStatusLevelUnworking = NSMVideoPlayerStatusFailed | NSMVideoPlayerStatusIdle,
    
    /** 播放器正在播放或者马上可以开始播放的状态下 */
    NSMVideoPlayerStatusLevelPlayed = NSMVideoPlayerStatusPlaying | NSMVideoPlayerStatusWaitBufferingToPlay,
    
    /** 播放器正在停止播放状态 */
    NSMVideoPlayerStatusLevelPaused = NSMVideoPlayerStatusPaused | NSMVideoPlayerStatusPlayToEndTime,
    
    /** 播放器处于初始化完成的状态下 */
    NSMVideoPlayerStatusLevelReadyToPlay = NSMVideoPlayerStatusLevelPlayed | NSMVideoPlayerStatusLevelPaused,
};

@class BFTask, NSMPlayerAsset;

@protocol NSMPlayerProtocol <NSObject>

@property (nonatomic, readonly, strong) NSMPlayerAsset *currentAsset;

@property (nonatomic, assign, getter=isPreload) BOOL preload;
@property (nonatomic, assign, getter=isAutoPlay) BOOL autoPlay;
@property (nonatomic, assign, getter=isLoopPlayback) BOOL loopPlayback;

/* indicates whether or not audio output of the player is muted. Only affects audio muting for the player instance and not for the device. */
@property (nonatomic, assign, getter=isMuted) BOOL muted;

@property (nonatomic, readonly, strong) NSError *playerError;

/* Indicates the current audio volume of the player; 0.0 means "silence all audio", 1.0 means "play at the full volume of the current item".
 
 iOS note: Do not use this property to implement a volume slider for media playback. For that purpose, use MPVolumeView, which is customizable in appearance and provides standard media playback behaviors that users expect.
 This property is most useful on iOS to control the volume of the AVPlayer relative to other audio output, not for volume control by end users. */

@property (nonatomic, assign) CGFloat volume;

@property (nonatomic, assign) CGFloat rate;


@property (nonatomic, assign) NSMVideoPlayerStatus currentStatus;

@property (nonatomic, assign) NSMVideoPlayerType playerType;

@property (nonatomic, assign, getter=isAllowWWAN) BOOL allowWWAN;

@property (nonatomic, weak) id<NSMVideoPlayerViewProtocol> playerView;

@property (nonatomic, strong, readonly) NSProgress *playbackProgress;
@property (nonatomic, strong, readonly) NSProgress *bufferProgress;

- (BFTask *)prepare;
- (void)play;
- (void)pause;
- (void)suspendPlayingback;
- (void)seekToTime:(NSTimeInterval)seconds;
- (void)releasePlayer;
- (void)replaceCurrentAssetWithAsset:(NSMPlayerAsset *)asset;
- (NSMPlayerAsset *)currentAsset;

@end

NS_ASSUME_NONNULL_END
