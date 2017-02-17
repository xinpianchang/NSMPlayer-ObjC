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
#import "NSMVideoPlayerConfig.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *NSMVideoPlayerStatusDescription (NSMVideoPlayerStatus status);

FOUNDATION_EXPORT NSString * const NSMVideoPlayerStatusDidChange;

typedef NS_ENUM(NSUInteger, NSMVideoPlayerMessageType) {
    NSMVideoPlayerEventReplacePlayerItem,
    NSMVideoPlayerEventTryToPrepared,
    NSMVideoPlayerEventReadyToPlay,
    NSMVideoPlayerEventPlay,
    NSMVideoPlayerEventPause,
    NSMVideoPlayerEventCompleted,
    NSMVideoPlayerEventLoopPlayback,
    NSMVideoPlayerEventWaitingBufferToPlay,
    NSMVideoPlayerEventEnoughBufferToPlay,
    NSMVideoPlayerEventReleasePlayer,
    NSMVideoPlayerEventSeek,
    NSMVideoPlayerEventFailure,
    NSMVideoPlayerEventRetry,
    NSMVideoPlayerEventAllowWWANChange,
    NSMVideoPlayerEventPlayerTypeChange,
    
    NSMVideoPlayerActionPlay,
    NSMVideoPlayerActionPause,
    NSMVideoPlayerActionReleasePlayer,
    NSMVideoPlayerActionSeek,
    NSMVideoPlayerActionRetry,
    
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

@property (nonatomic, strong) NSMVideoPlayerConfig *videoPlayerConfig;

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

@property (nonatomic, assign) NSMVideoPlayerType playerType;

@property (nonatomic, readonly, strong) NSError *playerError;

- (instancetype)initWithPlayerType:(NSMVideoPlayerType)playerType NS_DESIGNATED_INITIALIZER;
- (void)setupUnderlyingPlayerWithPlayerType:(NSMVideoPlayerType)playerType;

- (BOOL)shouldPlayWithWWAN;

/**
 在 preparing 的时候接受到 Play/Pause 等 Event 时，需要记录用户<测试人员的>的 是否最终想要播放的一种意图。
 */
@property (nonatomic, assign) BOOL intentToPlay;

@end

NS_ASSUME_NONNULL_END
