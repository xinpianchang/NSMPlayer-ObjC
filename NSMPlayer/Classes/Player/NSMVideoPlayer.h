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
#import "NSMPlayerRestoration.h"
#import "NSMUnderlyingPlayerProtocol.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NSMVideoPlayerMessageType) {
    NSMVideoPlayerEventReplacePlayerItem,
    NSMVideoPlayerEventStartPreparing,
    NSMVideoPlayerEventPreparingCompleted,
    NSMVideoPlayerEventPlay,
    NSMVideoPlayerEventPause,
    NSMVideoPlayerEventAdjustVolume,
    //NSMVideoPlayerEventAdjustRate,
    NSMVideoPlayerEventSetMuted,
    NSMVideoPlayerEventCompleted,
    NSMVideoPlayerEventLoopPlayback,
    NSMVideoPlayerEventWaitingBufferToPlay,
    NSMVideoPlayerEventEnoughBufferToPlay,
    NSMVideoPlayerEventUpdateBuffering,
    NSMVideoPlayerEventReleasePlayer,
    NSMVideoPlayerEventSeek,
    NSMVideoPlayerEventFailure,
    NSMVideoPlayerEventAllowWWANChange,
    NSMVideoPlayerEventPlayerTypeChangeStart,
    NSMVideoPlayerEventPlayerTypeChangeFinish,
    NSMVideoPlayerEventPlayerRestore,
    NSMVideoPlayerEventPlayerStartRestorePrepare,
    NSMVideoPlayerEventReplacePlayerView,
    
    NSMVideoPlayerActionPlay,
    NSMVideoPlayerActionPause,
    NSMVideoPlayerActionReleasePlayer,
    NSMVideoPlayerActionSeek,
};

FOUNDATION_EXPORT NSString * NSMVideoPlayerStatusDescription (NSMVideoPlayerStatus status);

FOUNDATION_EXPORT  NSString * NSMVideoPlayerMessageDescription (NSMVideoPlayerMessageType messageType);

FOUNDATION_EXPORT NSString * const NSMVideoPlayerStatusDidChange;

FOUNDATION_EXPORT NSString * const NSMVideoPlayerOldStatusKey;

FOUNDATION_EXPORT NSString * const NSMVideoPlayerNewStatusKey;



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

@class NSMPlayerError;
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

@property (nullable, nonatomic, strong) NSMPlayerRestoration *tempRestoringConfig;

@property (nullable, nonatomic, strong) NSMPlayerError *playerError;

/**
 在 preparing 的时候接受到 Play/Pause 等 Event 时，需要记录用户<测试人员的>的 是否最终想要播放的一种意图。
 */
@property (nonatomic, assign) BOOL intentToPlay;

@property (nonatomic, assign, getter = isBuffering) BOOL buffering;

/**
 判断播放器是否处在某个状态层级中
 */
- (BOOL)isOnCurrentLevelWithLevel:(NSMVideoPlayerStatusLevel)level;

- (void)setupUnderlyingPlayerWithPlayerType:(NSMVideoPlayerType)playerType;

- (BOOL)shouldPlayWithWWAN;

- (instancetype)initWithPlayerType:(NSMVideoPlayerType)playerType NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
