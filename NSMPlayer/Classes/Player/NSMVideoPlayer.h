// NSMVideoPlayer.h
//
// Copyright (c) 2017 NSMPlayer
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
