//
//  NSMVideoPlayer.m
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import "NSMVideoPlayer.h"
#import "NSMVideoPlayerControllerDataSource.h"
#import "NSMAVPlayer.h"
#import <Bolts/Bolts.h>
#import "AFNetworkReachabilityManager.h"

NSString * const NSMVideoPlayerStatusDidChange = @"NSMVideoPlayerStatusDidChange";

@implementation NSMPlayerState

- (NSMVideoPlayer *)videoPlayer {
    return (NSMVideoPlayer *)self.stateMachine;
}

+ (instancetype)playerStateWithVideoPlayer:(NSMVideoPlayer *)videoPlayer {
    return [[self alloc] initWithVideoPlayer:videoPlayer];
}

- (instancetype)initWithVideoPlayer:(NSMVideoPlayer *)videoPlayer {
    self = [super initWithStateMachine:videoPlayer];
    if (self) {
    
    }
    return self;
}

@end

@implementation NSMPlayerInitialState

- (BOOL)processMessage:(NSMMessage *)message {
    
    switch (message.messageType) {
        case NSMVideoPlayerEventPlayerTypeChange: {
            [self.videoPlayer setupUnderlyingPlayerWithPlayerType:(NSMVideoPlayerType)[message.userInfo intValue]];
            return YES;
        }
        
        case NSMVideoPlayerEventFailure: {
            [self.videoPlayer transitionToState:self.videoPlayer.errorState];
            return YES;
        }
        
        default:
            return NO;
    }
}

@end

@implementation NSMPlayerUnWorkingState

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerEventReplacePlayerItem: {
            if (self.videoPlayer.videoPlayerConfig.isAutoPlay) {
                self.videoPlayer.intentToPlay = YES;
                [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                [self sendMessageWithType:NSMVideoPlayerEventTryToPrepared];
            } else if (self.videoPlayer.videoPlayerConfig.isPreload) {
                [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                [self sendMessageWithType:NSMVideoPlayerEventTryToPrepared];
            } else {
                /*to do*/
            }
            return YES;
        }
        
        case NSMVideoPlayerActionPlay: {
            if (self.videoPlayer.playerSource != nil) {
                [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                [self sendMessageWithType:NSMVideoPlayerEventTryToPrepared];
            } else {
                [self.videoPlayer transitionToState:self.videoPlayer.errorState];
                [self sendMessageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"播放器还没有设定播放URL"}]];
            }
            return YES;
        }
        
        case NSMVideoPlayerEventPlayerRestore: {
            switch (self.videoPlayer.videoPlayerConfig.restoredStatus) {
                case NSMVideoPlayerStatusIdle: {
                    [self.videoPlayer transitionToState:self.videoPlayer.idleState];
                    //
                    self.videoPlayer.videoPlayerConfig.restoring = NO;
                    break;
                }
                
                case NSMVideoPlayerStatusFailed: {
                    [self.videoPlayer transitionToState:self.videoPlayer.errorState];
                    self.videoPlayer.videoPlayerConfig.restoring = NO;
                    break;
                }
                
                case NSMVideoPlayerStatusPaused:
                case NSMVideoPlayerStatusPlayToEndTime:
                case NSMVideoPlayerStatusPlaying: {
                    if (self.videoPlayer.videoPlayerConfig.playerSource != nil) {
                        [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                        self.videoPlayer.videoPlayerConfig.restoring = NO;
                    }
                    break;
                }
                default:
                    break;
            }
            return YES;
        }
        
        default:
            return NO;
    }
}

@end

@implementation NSMPlayerIdleState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusIdle;
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        
        default:
            return NO;
    }
}

@end

@implementation NSMPlayerFailedState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusFailed;
}


@end

@implementation NSMPlayerPreparingState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusPreparing;
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerEventReadyToPlay: {
            if (self.videoPlayer.intentToPlay) {
                [self.videoPlayer transitionToState:self.videoPlayer.readyToPlayState];
                [self sendMessageWithType:NSMVideoPlayerEventPlay];
            } else {
                [self.videoPlayer transitionToState:self.videoPlayer.readyToPlayState];
                [self sendMessageWithType:NSMVideoPlayerEventPause];
            }
            return YES;
        }

        case NSMVideoPlayerEventReplacePlayerItem:
        case NSMVideoPlayerEventTryToPrepared: {
            if (self.videoPlayer.playerSource == nil) {
                [self.videoPlayer transitionToState:self.videoPlayer.idleState];
            } else {
                if ([self.videoPlayer shouldPlayWithWWAN]) {
                    // 是否允许 3G/4G网络播放
                    [self.videoPlayer prepare];
                } else {
                    [self.videoPlayer transitionToState:self.videoPlayer.errorState];
                    [self sendMessageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
                }
            }
            return YES;
        }
        
        case NSMVideoPlayerActionSeek: {
            [self.videoPlayer removeDeferredMessage:NSMVideoPlayerActionSeek];
            [self.videoPlayer deferredMessage:message];
            return YES;
        }
        
        default:
            return NO;
    }
}

@end

@implementation NSMPlayerReayToPlayState

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerEventPlay: {
            [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            return YES;
        }
        
        case NSMVideoPlayerEventPause: {
            [self.videoPlayer transitionToState:self.videoPlayer.pausingState];
            return YES;
        }
        
        case NSMVideoPlayerEventCompleted: {
            if (self.videoPlayer.videoPlayerConfig.isLoopPlayback) {
                // 循环播放
                [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            } else {
                [self.videoPlayer transitionToState:self.videoPlayer.completedState];
            }
            return YES;
        }
        
        case NSMVideoPlayerEventReplacePlayerItem: {
            [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
            [self sendMessageWithType:NSMVideoPlayerEventTryToPrepared];
            return YES;
        }
        
        case NSMVideoPlayerActionSeek: {
            [self.videoPlayer seekToTime:[message.userInfo doubleValue]];
            return YES;
        }
        
        default:
            return NO;
    }
}

@end

@implementation NSMPlayerPlayedState

- (void)enter {
    [super enter];
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        
        case NSMVideoPlayerActionPause: {
            [self.videoPlayer transitionToState:self.videoPlayer.pausedState];
            return YES;
        }
        
        default:
            return NO;
    }
}
@end

@implementation NSMPlayerPlayingState
- (void)enter {
    [super enter];
    [self.videoPlayer.underlyingPlayer play];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusPlaying;
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerEventWaitingBufferToPlay: {
            [self.videoPlayer transitionToState:self.videoPlayer.waitBufferingToPlayState];
            return YES;
        }
        
        default:
            return NO;
    }
}
@end

@implementation NSMPlayerWaitBufferingToPlayState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusWaitBufferingToPlay;
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerEventEnoughBufferToPlay: {
            [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            return YES;
        }
        default:
            return NO;
    }
}
@end

@implementation NSMPlayerPausedState

- (void)enter {
    [super enter];
    [self.videoPlayer pause];
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerActionPlay: {
            [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            return YES;
        }
        
        case NSMVideoPlayerActionSeek: {
            [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            [self sendMessageWithType:message.messageType userInfo:message.userInfo];
        }
        
        default:
            return NO;
    }
}


@end

@implementation NSMPlayerPausingState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusPaused;
    [self.videoPlayer.underlyingPlayer pause];
}

@end

@implementation NSMPlayerCompletedState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusPlayToEndTime;
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerEventLoopPlayback: {
            [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            return YES;
        }
        default:
            return NO;
    }
}
@end


@interface NSMVideoPlayer ()

@property (nonatomic, strong) NSThread *stateMachineRunLoopThread;
@property (nonatomic, strong) NSMutableDictionary *players;
@property (nonatomic, readwrite, strong) NSMVideoPlayerConfig *videoPlayerConfig;

@end

@implementation NSMVideoPlayer

@synthesize duration = _duration;
@synthesize currentStatus = _currentStatus;

- (void)stateMachineRunLoopThreadThreadEntry {
    @autoreleasepool {
        NSThread * currentThread = [NSThread currentThread];
        currentThread.name = @"StateMachineOfPlayerThread";
        NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
        [currentRunloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [currentRunloop run];
    }
}


#pragma mark - NSMVideoPlayerProtocol

- (void)setPlayerSource:(NSMVideoPlayerControllerDataSource *)playerSource {
    NSAssert(playerSource.assetURL, @"playerSource.assetURL is nil");
    if (![self.videoPlayerConfig.playerSource.assetURL.absoluteString isEqualToString:playerSource.assetURL.absoluteString]) {
        self.videoPlayerConfig.playerSource = playerSource;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventReplacePlayerItem];
        [self sendMessage:msg];
    }
}

- (NSMVideoPlayerControllerDataSource *)playerSource {
    return self.videoPlayerConfig.playerSource;
}

- (BFTask *)prepare {
    [self.underlyingPlayer setPlayerSource:self.playerSource];
    return [[self.underlyingPlayer prepare] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.result) {
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventReadyToPlay];
            [self sendMessage:msg];
        } else if (t.error) {
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure];
            [self sendMessage:msg];
        }
        return nil;
    }];
}

- (void)play {
    self.intentToPlay = YES;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionPlay];
    [self sendMessage:msg];
}

- (void)pause {
    self.intentToPlay = NO;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionPause];
    [self sendMessage:msg];
}

- (void)releasePlayer {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionReleasePlayer];
    [self sendMessage:msg];
}

- (void)seekToTime:(NSTimeInterval)time {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionSeek];
    msg.userInfo = @(time);
    [self sendMessage:msg];
}

- (void)choosePlayerWithType:(NSMVideoPlayerType)type {
    self.playerType = type;
}

- (void)retry {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionRetry];
    [self sendMessage:msg];
}


- (id)player {
    return self.underlyingPlayer.player;
}

- (void)setMuted:(BOOL)on {
    [self.underlyingPlayer setMuted:on];
}

- (void)setVolume:(CGFloat)volum {
    [self.underlyingPlayer setVolume:volum];
}

- (void)setRate:(CGFloat)rate {
    [self.underlyingPlayer setRate:rate];
}

- (void)setAllowWWAN:(BOOL)allowWWAN {
    NSMMessage *msg = [[NSMMessage alloc] init];
    msg.messageType = NSMVideoPlayerEventAllowWWANChange;
    [self sendMessage:msg];
}

- (void)setLoopPlayback:(BOOL)loopPlayback {
    if (self.videoPlayerConfig.isLoopPlayback != loopPlayback) {
        [self.underlyingPlayer setLoopPlayback:loopPlayback];
        [self sendMessageType:NSMVideoPlayerEventLoopPlayback];
    }
}

- (void)setAutoPlay:(BOOL)autoPlay {
    if (self.videoPlayerConfig.isAutoPlay != autoPlay) {
        self.videoPlayerConfig.autoPlay = autoPlay;
        [self sendMessageType:NSMVideoPlayerEventTryToPrepared];
    }
}

- (void)setPreload:(BOOL)preload {
    if (self.videoPlayerConfig.isPreload != preload) {
        self.videoPlayerConfig.preload = preload;
        [self sendMessageType:NSMVideoPlayerEventTryToPrepared];
    }
}

- (void)restorePlayerWithConfig:(NSMVideoPlayerConfig *)config {
    
    if (!self.videoPlayerConfig.isRestoring) {
        self.videoPlayerConfig.restoring = YES;
        
    } else {
        // 正在恢复
        self.videoPlayerConfig.playerSource = config.playerSource;
        self.videoPlayerConfig.playerType = config.playerType;
        self.videoPlayerConfig.autoPlay = config.isAutoPlay;
        self.videoPlayerConfig.preload = config.isPreload;
        self.videoPlayerConfig.loopPlayback = config.isLoopPlayback;
        self.videoPlayerConfig.allowWWAN = config.isAllowWWAN;
        self.videoPlayerConfig.muted = config.isMuted;
        
        [self sendMessageType:NSMVideoPlayerEventPlayerRestore];
    }
}

- (NSMVideoPlayerConfig *)savePlayerState {
    if (self.videoPlayerConfig.restoring) {
        return self.videoPlayerConfig;
    } else {
        NSMVideoPlayerConfig *config = [[NSMVideoPlayerConfig alloc] init];
        if ([self isOnCurrentLevelWithLevel:NSMVideoPlayerStatusLevelReadyToPlay]) {
            config.restoredStatus = self.intentToPlay ? NSMVideoPlayerStatusPlaying : NSMVideoPlayerStatusPaused;
            
        }
    }
}

- (void)start {
    self.initialState = [[NSMPlayerInitialState alloc] initWithStateMachine:self];
    [self addState:self.initialState parentState:nil];
    
    self.unworkingState = [[NSMPlayerUnWorkingState alloc] initWithStateMachine:self];
    [self addState:self.unworkingState parentState:self.initialState];
    
    self.idleState = [[NSMPlayerIdleState alloc] initWithStateMachine:self];
    self.errorState = [[NSMPlayerFailedState alloc] initWithStateMachine:self];
    [self addState:self.idleState parentState:self.unworkingState];
    [self addState:self.errorState parentState:self.unworkingState];
    
    self.preparingState = [[NSMPlayerPreparingState alloc] initWithStateMachine:self];
    [self addState:self.preparingState parentState:self.initialState];
    
    self.readyToPlayState = [[NSMPlayerReayToPlayState alloc] initWithStateMachine:self];
    [self addState:self.readyToPlayState parentState:self.initialState];
    
    self.playedState = [[NSMPlayerPlayedState alloc] initWithStateMachine:self];
    [self addState:self.playedState parentState:self.readyToPlayState];
    
    self.playingState = [[NSMPlayerPlayingState alloc] initWithStateMachine:self];
    self.waitBufferingToPlayState = [[NSMPlayerWaitBufferingToPlayState alloc] initWithStateMachine:self];
    [self addState:self.playingState parentState:self.playedState];
    [self addState:self.waitBufferingToPlayState parentState:self.playedState];
    
    
    self.pausedState = [[NSMPlayerPausedState alloc] initWithStateMachine:self];
    [self addState:self.pausedState parentState:self.readyToPlayState];
    self.pausingState = [[NSMPlayerPausingState alloc] initWithStateMachine:self];
    self.completedState = [[NSMPlayerCompletedState alloc] initWithStateMachine:self];
    [self addState:self.pausingState parentState:self.pausedState];
    [self addState:self.completedState parentState:self.pausedState];
    
    // Player 的 State 需要记在内存中吗？我们的播放器在页面切换的时候需要主动的 Release Player 吗？如果需要就需要 RestoreState
    // 还有状态机的生命周期？
    self.smHandler.initialState = self.idleState;
    [super start];
}


- (instancetype)initWithPlayerType:(NSMVideoPlayerType)playerType {
    if (self = [super init]) {
        self.videoPlayerConfig = [NSMVideoPlayerConfig videoPlayerConfig];
        self.players = [NSMutableDictionary dictionary];
        self.stateMachineRunLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(stateMachineRunLoopThreadThreadEntry) object:nil];
        [self.stateMachineRunLoopThread start];
        self.smHandler.runloopThread = self.stateMachineRunLoopThread;
        [self start];
        
        [self registerObserver];
        self.playerType = playerType;
    }
    return self;
}

- (void)setPlayerType:(NSMVideoPlayerType)playerType {
    if (_playerType != playerType) {
        NSMMessage *msg = [[NSMMessage alloc] init];
        msg.messageType = NSMVideoPlayerEventPlayerTypeChange;
        msg.userInfo = @(playerType);
        [self sendMessage:msg];
    }
}

- (void)setupUnderlyingPlayerWithPlayerType:(NSMVideoPlayerType)playerType {
    if (_playerType != playerType) {
        NSMUnderlyingPlayer * player = self.players[@(playerType)];
        if (!player) {
            if (NSMVideoPlayerAVPlayer == playerType) {
                player = [[NSMAVPlayer alloc] init];
            } else if (NSMVideoPlayerIJKPlayer == playerType) {
                
            }
        }
        self.players[@(playerType)] = player;
        self.underlyingPlayer = player;
        _playerType = playerType;
    }
}


- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerDidPlayToEndTime:) name:NSMUnderlyingPlayerDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerFailed:) name:NSMUnderlyingPlayerFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerPlaybackBufferEmpty:) name:NSMUnderlyingPlayerPlaybackBufferEmptyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerPlaybackLikelyToKeepUp:) name:NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification object:nil];
}

- (void)underlyingPlayerDidPlayToEndTime:(NSNotification *)notification {
    NSMMessage *msg = [[NSMMessage alloc] init];
    msg.messageType =  NSMVideoPlayerEventCompleted;
    [self sendMessage:msg];
}

- (void)underlyingPlayerFailed:(NSNotification *)notification {
    NSMMessage *msg = [[NSMMessage alloc] init];
    msg.messageType = NSMVideoPlayerEventFailure;
    msg.userInfo = notification.userInfo;
    [self sendMessage:msg];
}

- (void)underlyingPlayerPlaybackBufferEmpty:(NSNotification *)notification {
    NSMMessage *msg = [[NSMMessage alloc] init];
    msg.messageType = NSMVideoPlayerEventWaitingBufferToPlay;
    msg.userInfo = notification.userInfo;
    [self sendMessage:msg];
}

- (void)underlyingPlayerPlaybackLikelyToKeepUp:(NSNotification *)notification {
    NSMMessage *msg = [[NSMMessage alloc] init];
    msg.messageType = NSMVideoPlayerEventEnoughBufferToPlay;
    msg.userInfo = notification.userInfo;
    [self sendMessage:msg];
}

- (BOOL)shouldPlayWithWWAN {
    return YES;
    if ([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN && self.allowWWAN) {
        return YES;
    }
    return NO;
}

- (BOOL)isOnCurrentLevelWithLevel:(NSMVideoPlayerStatusLevel)level {
    return (self.currentStatus & level);
}

- (void)setCurrentStatus:(NSMVideoPlayerStatus)currentStatus {
    if (_currentStatus != currentStatus) {
        _currentStatus = currentStatus;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NSMVideoPlayerStatusDidChange object:self userInfo:@(currentStatus)];
        });
    }
}

inline NSString *NSMVideoPlayerStatusDescription (NSMVideoPlayerStatus status) {
    switch (status) {
        case NSMVideoPlayerStatusInit: {
            return @"Init";
        }
        case NSMVideoPlayerStatusIdle: {
            return @"Idle";
        }
        case NSMVideoPlayerStatusFailed: {
            return @"Failed";
        }
        case NSMVideoPlayerStatusPreparing: {
            return @"Preparing";
        }
        case NSMVideoPlayerStatusPlaying: {
            return @"Playing";
        }
        case NSMVideoPlayerStatusWaitBufferingToPlay: {
            return @"WaitBufferingToPlay";
        }
        case NSMVideoPlayerStatusPaused: {
            return @"Paused";
        }
        case NSMVideoPlayerStatusPlayToEndTime: {
            return @"PlayToEndTime";
        }
    }
}
@end
