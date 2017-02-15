//
//  NSMVideoPlayer.h
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//



#import <NSMStateMachine/NSMStateMachine.h>
#import "NSMUnderlyingPlayer.h"
#import "NSMVideoPlayerController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NSMVideoPlayerMessageType) {
    NSMVideoPlayerEventReadyToPlay,
    NSMVideoPlayerEventPlay,
    NSMVideoPlayerEventPause,
    NSMVideoPlayerEventReleasePlayer,
    NSMVideoPlayerEventSeek,
    NSMVideoPlayerEventFailure,
    NSMVideoPlayerEventRetry,
    NSMVideoPlayerEventNetworkConnectionChange,
    
    NSMVideoPlayerActionPlay,
    NSMVideoPlayerActionPause,
    NSMVideoPlayerActionReleasePlayer,
    NSMVideoPlayerActionSeek,
    NSMVideoPlayerActionRetry,
    NSMVideoPlayerActionReplacePlayerItem,
};

typedef NS_OPTIONS(NSUInteger, NSMVideoPlayerStatus) {
    NSMVideoPlayerStatusIdle = 1 << 0,// for poster?
    NSMVideoPlayerStatusFailed = 1 << 1, // 随时都可能进入到 Error ,Playing -> error, Preparing -> error,
    NSMVideoPlayerStatusPreparing = 1 << 2, // loadTracks
    NSMVideoPlayerStatusPlaying = 1 << 3, // Playing but not waitBuffering
    NSMVideoPlayerStatusWaitBufferingToPlay = 1 << 4,
    NSMVideoPlayerStatusPaused = 1 << 5, // Paused
    NSMVideoPlayerStatusPlayToEndTime = 1 << 6,//PlayBack to end time
};

@class NSMStateMachine, NSMVideoPlayer;

@interface NSMPlayerState : NSMState

@property (readonly, nonatomic, weak) NSMVideoPlayer *videoPlayer;

+ (instancetype)playerStateWithVideoPlayer:(NSMVideoPlayer *)videoPlayer;
- (instancetype)initWithVideoPlayer:(NSMVideoPlayer *)videoPlayer;

@end

@interface NSMPlayerInitialState : NSMPlayerState

@end

@interface NSMPlayerUnWorkingState : NSMPlayerState

@end

@interface NSMPlayerIdleState : NSMPlayerState

@end

@interface NSMPlayerFailedState : NSMPlayerState

@end

@interface NSMPlayerPreparingState : NSMPlayerState

@end

@interface NSMPlayerReayToPlayState : NSMPlayerState

@end

@interface NSMPlayerPlayedState : NSMPlayerState

@end

@interface NSMPlayerPlayingState : NSMPlayerState  //

@end

@interface NSMPlayerWaitBufferingToPlayState : NSMPlayerState // played - very bad network - loading cache

@end

@interface NSMPlayerPausedState : NSMPlayerState // current state receive buffering notification do nothing

@end

@interface NSMPlayerPausingState : NSMPlayerState

@end

@interface NSMPlayerCompletedState : NSMPlayerState

@end

@interface NSMVideoPlayer : NSMStateMachine <NSMVideoPlayerProtocol>

@property (nonatomic, strong) id<NSMUnderlyingPlayerProtocol> underlyingPlayer;
@property (nonatomic, strong) NSMStateMachine *stateMachine;

@property (nonatomic, strong) NSMPlayerState *initialState;

@property (nonatomic, strong) NSMPlayerState *unworkingState;

@property (nonatomic, strong) NSMPlayerState *idleState;
@property (nonatomic, strong) NSMPlayerState *errorState;

@property (nonatomic, strong) NSMPlayerState *preparingState;

@property (nonatomic, strong) NSMPlayerState *readyToPlayState;

@property (nonatomic, strong) NSMPlayerState *playedState;
@property (nonatomic, strong) NSMPlayerState *playingState;
@property (nonatomic, strong) NSMPlayerState *waitBufferingToPlayState;

@property (nonatomic, strong) NSMPlayerState *pausedState;
@property (nonatomic, strong) NSMPlayerState *pausingState;
@property (nonatomic, strong) NSMPlayerState *completedState;

@property (nonatomic, assign) NSMVideoPlayerStatus currentStatus;

@property (nonatomic, assign) NSMVideoPlayerType playerType;

- (instancetype)initWithPlayerType:(NSMVideoPlayerType)playerType NS_DESIGNATED_INITIALIZER;


@end

NS_ASSUME_NONNULL_END
