//
//  NSMVideoPlayer.m
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import "NSMVideoPlayer.h"
#import "NSMPlayerAsset.h"
#import "NSMAVPlayer.h"
#import <Bolts/Bolts.h>
#import "AFNetworkReachabilityManager.h"

NSString * const NSMVideoPlayerStatusDidChange = @"NSMVideoPlayerStatusDidChange";

NSString * const NSMVideoPlayerOldStatusKey = @"NSMVideoPlayerOldStatusKey";

NSString * const NSMVideoPlayerNewStatusKey = @"NSMVideoPlayerNewStatusKey";


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
            self.videoPlayer.playerError = message.userInfo;
            
            [self.videoPlayer savePlayerState];
            [self.videoPlayer transitionToState:self.videoPlayer.errorState];
            return YES;
        }
        
        case NSMVideoPlayerEventReleasePlayer: {
            [self.videoPlayer transitionToState:self.videoPlayer.idleState];
            [self.videoPlayer.underlyingPlayer releasePlayer];
            return YES;
        }
        
        case NSMVideoPlayerActionReleasePlayer: {
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventReleasePlayer];
            msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
            [self sendMessage:msg];
//            [self sendMessageWithType:NSMVideoPlayerEventReleasePlayer];
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
            if (self.videoPlayer.isAutoPlay) {
                self.videoPlayer.intentToPlay = YES;
                [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventStartPreparing];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
//                [self sendMessageWithType:NSMVideoPlayerEventTryToPrepared];
            } else if (self.videoPlayer.isPreload) {
                [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventStartPreparing];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
//                [self sendMessageWithType:NSMVideoPlayerEventTryToPrepared];
            } else {
                /*to do*/
            }
            return YES;
        }
        
        case NSMVideoPlayerActionPlay: {
            if (self.videoPlayer.currentAsset != nil) {
                [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventStartPreparing];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
//                [self sendMessageWithType:NSMVideoPlayerEventTryToPrepared];
            } else {
//                [self.videoPlayer transitionToState:self.videoPlayer.errorState];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"播放器还没有设定播放URL"}]];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
                //[self sendMessageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"播放器还没有设定播放URL"}]];
            }
            return YES;
        }
        
        case NSMVideoPlayerEventPlayerRestore: {
            NSMPlayerRestoration *restoration = message.userInfo;
            switch (restoration.restoredStatus) {
                case NSMVideoPlayerStatusIdle: {
                    [self.videoPlayer transitionToState:self.videoPlayer.idleState];
                    //
                    self.videoPlayer.tempRestoringConfig = nil;
                    break;
                }
                
                case NSMVideoPlayerStatusFailed: {
                    [self.videoPlayer transitionToState:self.videoPlayer.errorState];
                    self.videoPlayer.tempRestoringConfig = nil;
                    break;
                }
                
                case NSMVideoPlayerStatusPaused:
                case NSMVideoPlayerStatusPlayToEndTime:
                case NSMVideoPlayerStatusPlaying: {
                    if (self.videoPlayer.currentAsset != nil) {
                        [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventStartPreparing];
                        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                        [self sendMessage:msg];
//                        [self sendMessageWithType:NSMVideoPlayerEventPlayerRestorePrepare];
                        self.videoPlayer.tempRestoringConfig = nil;
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
        case NSMVideoPlayerEventPreparingCompleted: {
            if (self.videoPlayer.intentToPlay) {
                [self.videoPlayer transitionToState:self.videoPlayer.readyToPlayState];
//                [self sendMessageWithType:NSMVideoPlayerEventPlay];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPlay];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
            } else {
                [self.videoPlayer transitionToState:self.videoPlayer.readyToPlayState];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPause];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
                //[self sendMessageWithType:NSMVideoPlayerEventPause];
            }
            return YES;
        }
        
        case NSMVideoPlayerEventReplacePlayerItem:
        case NSMVideoPlayerEventStartPreparing: {
            if (self.videoPlayer.currentAsset == nil) {
                [self.videoPlayer transitionToState:self.videoPlayer.idleState];
            } else {
                if ([self.videoPlayer shouldPlayWithWWAN]) {
                    // 是否允许 3G/4G网络播放
                    [self.videoPlayer prepare];
                } else {
                    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
                    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                    [self sendMessage:msg];
                    //[self sendMessageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
                }
            }
            return YES;
        }
        
        case NSMVideoPlayerActionSeek: {
            [self.videoPlayer removeDeferredMessage:NSMVideoPlayerActionSeek];
            [self.videoPlayer deferredMessage:message];
            return YES;
        }
        
        case NSMVideoPlayerEventAllowWWANChange: {
            if ([self.videoPlayer shouldPlayWithWWAN]) {
                // keep preparing
                
            } else {
                //
                [self.videoPlayer.underlyingPlayer releasePlayer];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
//                [self sendMessageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
            }
            return YES;
        }
        
//        case NSMVideoPlayerEventPlayerRestorePrepare: {
//            if (self.videoPlayer.playerSource == nil) {
//                [self.videoPlayer transitionToState:self.videoPlayer.idleState];
//            } else {
//                if ([self.videoPlayer shouldPlayWithWWAN]) {
//                    // 是否允许 3G/4G网络播放
//                    [self.videoPlayer prepare];
//                } else {
//                    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
//                    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
//                    [self sendMessage:msg];
//                    //[self sendMessageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
//                }
//            }
//            return YES;
//        }
        default:
            return NO;
    }
}

@end

@implementation NSMPlayerReayToPlayState

- (void)enter {
    [super enter];
    self.videoPlayer.underlyingPlayer.loopPlayback = self.videoPlayer.isLoopPlayback;
    self.videoPlayer.underlyingPlayer.rate = self.videoPlayer.rate;
    self.videoPlayer.underlyingPlayer.volume = self.videoPlayer.volume;
    self.videoPlayer.underlyingPlayer.muted = self.videoPlayer.isMuted;
    [self.videoPlayer.underlyingPlayer seekToTime:[self.videoPlayer seekTime]];
    [self.videoPlayer.underlyingPlayer setPlayerView:[self.videoPlayer playerView]];
}

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
            if (self.videoPlayer.isLoopPlayback) {
                // 循环播放
                [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            } else {
                [self.videoPlayer transitionToState:self.videoPlayer.completedState];
            }
            return YES;
        }
        
        case NSMVideoPlayerEventPlayerTypeChange:
        case NSMVideoPlayerEventReplacePlayerItem: {
            [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventStartPreparing];
            msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
            [self sendMessage:msg];
//            [self sendMessageWithType:NSMVideoPlayerEventTryToPrepared];
            return YES;
        }
        
        case NSMVideoPlayerActionSeek: {
            [self.videoPlayer seekToTime:[message.userInfo doubleValue]];
            return YES;
        }
        
        case NSMVideoPlayerEventAllowWWANChange: {
            if ([self.videoPlayer shouldPlayWithWWAN]) {
                // 是否允许 3G/4G网络播放
                // 继续播放
            } else {
                [self.videoPlayer.underlyingPlayer releasePlayer];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
                //[self sendMessageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
            }
            return YES;
        }
        
        case NSMVideoPlayerEventAdjustVolume: {
            [self.videoPlayer.underlyingPlayer setVolume:[message.userInfo floatValue]];
            return YES;
        }
        
        case NSMVideoPlayerEventAdjustRate: {
            [self.videoPlayer.underlyingPlayer setRate:[message.userInfo floatValue]];
            return YES;
        }
        
        case NSMVideoPlayerEventSetMuted: {
            [self.videoPlayer.underlyingPlayer setMuted:[message.userInfo boolValue]];
            return YES;
        }
        
        case NSMVideoPlayerEventReplacePlayerView: {
            [self.videoPlayer.underlyingPlayer setPlayerView:self.videoPlayer.playerView];
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


@interface NSMVideoPlayer () {
    NSMPlayerAsset *_currentAsset;
    NSTimeInterval _seekTime;
}

@property (nonatomic, strong) NSThread *stateMachineRunLoopThread;
@property (nonatomic, strong) NSMutableDictionary *players;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation NSMVideoPlayer

@synthesize duration = _duration;
@synthesize currentStatus = _currentStatus;
@synthesize loopPlayback = _loopPlayback;
@synthesize autoPlay = _autoPlay;
@synthesize preload = _preload;
@synthesize muted = _muted;
@synthesize rate = _rate;
@synthesize volume = _volume;
@synthesize allowWWAN = _allowWWAN;
@synthesize playerType = _playerType;
@synthesize playerView = _playerView;

- (instancetype)initWithPlayerType:(NSMVideoPlayerType)playerType {
    self = [super init];
    if (self) {
        _volume = 1;
        _rate = 1;
        _currentStatus =  NSMVideoPlayerStatusUnknown;
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

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

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
- (void)replaceCurrentAssetWithAsset:(NSMPlayerAsset *)asset {
    NSAssert(asset.assetURL, @"playerSource.assetURL is nil");
    if (![self.currentAsset.assetURL.absoluteString isEqualToString:asset.assetURL.absoluteString]) {
        _currentAsset = asset;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventReplacePlayerItem];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
    }
}

- (NSMPlayerAsset *)currentAsset {
    return _currentAsset;
}

- (void)setPlayerView:(id<NSMVideoPlayerViewProtocol>)playerView {
    _playerView = playerView;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventReplacePlayerView];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}


- (NSTimeInterval)currentTime {
    return [self.underlyingPlayer currentTime];
}

- (BFTask *)prepare {
    [self.underlyingPlayer replaceCurrentAssetWithAsset:self.currentAsset];
    return [[self.underlyingPlayer prepare] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.result) {
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPreparingCompleted];
            msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
            [self sendMessage:msg];
        } else if (t.error) {
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure];
            msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
            [self sendMessage:msg];
        }
        return nil;
    }];
}

- (void)play {
    self.intentToPlay = YES;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionPlay];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)pause {
    self.intentToPlay = NO;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionPause];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)releasePlayer {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionReleasePlayer];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)seekToTime:(NSTimeInterval)time {
    _seekTime = time;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionSeek userInfo:@(time)];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}


- (void)setMuted:(BOOL)on {
    if (_muted != on) {
        _muted = on;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventSetMuted userInfo:@(on)];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
    }
}

- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventAdjustVolume userInfo:@(volume)];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)setRate:(CGFloat)rate {
    _rate = rate;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventAdjustRate userInfo:@(rate)];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)setAllowWWAN:(BOOL)allowWWAN {
    if (_allowWWAN != allowWWAN) {
        _allowWWAN = allowWWAN;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventAllowWWANChange];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
    }
}

- (void)setLoopPlayback:(BOOL)loopPlayback {
    if (_loopPlayback != loopPlayback) {
        _loopPlayback = loopPlayback;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventLoopPlayback];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
    }
}

- (void)setAutoPlay:(BOOL)autoPlay {
    if (_autoPlay != autoPlay) {
        _autoPlay = autoPlay;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventStartPreparing];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
    }
}

- (void)setPreload:(BOOL)preload {
    if (_preload != preload) {
        _preload = preload;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventStartPreparing];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
    }
}

- (NSTimeInterval)seekTime {
    return _seekTime;
}

- (void)restorePlayerWithConfig:(NSMPlayerRestoration *)config {
    
    if (self.tempRestoringConfig == nil) {
        _currentAsset = config.playerAsset;
        _playerType = config.playerType;
        _autoPlay = config.isAutoPlay;
        _preload = config.isPreload;
        _loopPlayback = config.isLoopPlayback;
        _allowWWAN = config.isAllowWWAN;
        _muted = config.isMuted;
        _volume = config.volume;
        _rate = config.rate;
        _seekTime = config.seekTime;
        
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPlayerRestore userInfo:config];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
        self.tempRestoringConfig = config;
    } else {
        // 正在恢复
    }
}

- (NSMPlayerRestoration *)savePlayerState {
    if (self.tempRestoringConfig != nil) {
        return self.tempRestoringConfig;
    } else {
        NSMPlayerRestoration *restoration = [[NSMPlayerRestoration alloc] init];
        if ([self isOnCurrentLevelWithLevel:NSMVideoPlayerStatusLevelReadyToPlay]) {
            restoration.restoredStatus = self.intentToPlay ? NSMVideoPlayerStatusPlaying : NSMVideoPlayerStatusPaused;
        } else {
            restoration.restoredStatus = self.currentStatus;
        }
        
        if (NSMVideoPlayerStatusPlayToEndTime == self.currentStatus) {
            restoration.intentToPlay = NO;
            restoration.seekTime = 0;
        } else if (NSMVideoPlayerStatusFailed == self.currentStatus) {
            restoration.intentToPlay = NO;
            restoration.seekTime = self.currentTime;
            restoration.playerError = self.playerError;
        } else {
            restoration.intentToPlay = self.intentToPlay;
            restoration.seekTime = self.currentTime;
        }
        
        restoration.playerAsset = self.currentAsset;
        restoration.playerError = self.playerError;
        restoration.playerType = self.playerType;
        restoration.autoPlay = self.isAutoPlay;
        restoration.preload = self.isPreload;
        restoration.muted = self.isMuted;
        restoration.allowWWAN = self.isAllowWWAN;
        restoration.volume = self.volume;
        restoration.rate = self.rate;
        return restoration;
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
    
    self.smHandler.initialState = self.idleState;
    [super start];
}


- (void)setPlayerType:(NSMVideoPlayerType)playerType {
    if (_playerType != playerType) {
        _playerType = playerType;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPlayerTypeChange userInfo:@(playerType)];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
    }
}

- (void)setupUnderlyingPlayerWithPlayerType:(NSMVideoPlayerType)playerType {
    NSMUnderlyingPlayer * player = self.players[@(playerType)];
    if (!player) {
        if (NSMVideoPlayerAVPlayer == playerType) {
            player = [[NSMAVPlayer alloc] init];
        } else if (NSMVideoPlayerIJKPlayer == playerType) {
            
        }
    }
    self.players[@(playerType)] = player;
    self.underlyingPlayer = player;
}


- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerDidPlayToEndTime:) name:NSMUnderlyingPlayerDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerFailed:) name:NSMUnderlyingPlayerFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerPlaybackBufferEmpty:) name:NSMUnderlyingPlayerPlaybackBufferEmptyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerPlaybackLikelyToKeepUp:) name:NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification object:nil];
}

- (void)underlyingPlayerDidPlayToEndTime:(NSNotification *)notification {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventCompleted];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)underlyingPlayerFailed:(NSNotification *)notification {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:notification.userInfo];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)underlyingPlayerPlaybackBufferEmpty:(NSNotification *)notification {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventWaitingBufferToPlay userInfo:notification.userInfo];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)underlyingPlayerPlaybackLikelyToKeepUp:(NSNotification *)notification {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventEnoughBufferToPlay userInfo:notification.userInfo];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
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
        NSMVideoPlayerStatus oldStatus = _currentStatus;
        _currentStatus = currentStatus;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NSMVideoPlayerStatusDidChange object:self userInfo:@{NSMVideoPlayerOldStatusKey : @(oldStatus), NSMVideoPlayerNewStatusKey : @(currentStatus)}];
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
        
        case NSMVideoPlayerStatusUnknown: {
            return @"Unknown";
        }
    }
}

inline NSString * NSMVideoPlayerMessageDescription (NSMVideoPlayerMessageType messageType) {
    switch (messageType) {
        case NSMVideoPlayerEventReplacePlayerItem:
            return @"EventReplacePlayerItem";
        
        case NSMVideoPlayerEventStartPreparing:
            return @"EventTryToPrepared";
        
        case NSMVideoPlayerEventPreparingCompleted:
            return @"EventPreparingCompleted";
        
        case NSMVideoPlayerEventPlay:
            return @"EventPlay";
        
        case NSMVideoPlayerEventAdjustVolume:
            return @"EventAdjustVolume";
        
        case NSMVideoPlayerEventAdjustRate:
            return @"EventAdjustRate";
        
        case NSMVideoPlayerEventSetMuted:
            return @"EventSetMuted";
        
        case NSMVideoPlayerEventPause:
            return @"EventPause";
        
        case NSMVideoPlayerEventCompleted:
            return @"EventCompleted";
        
        case NSMVideoPlayerEventLoopPlayback:
            return @"EventLoopPlayback";
        
        case NSMVideoPlayerEventWaitingBufferToPlay:
            return @"EventWaitingBufferToPlay";
        
        case NSMVideoPlayerEventEnoughBufferToPlay:
            return @"EventEnoughBufferToPlay";
        
        case NSMVideoPlayerEventReleasePlayer:
            return @"EventReleasePlayer";
        
        case NSMVideoPlayerEventSeek:
            return @"EventSeek";
        
        case NSMVideoPlayerEventFailure:
            return @"EventFailure";
        
        case NSMVideoPlayerEventAllowWWANChange:
            return @"EventAllowWWANChange";
        
        case NSMVideoPlayerEventPlayerTypeChange:
            return @"EventPlayerTypeChange";
        
        case NSMVideoPlayerEventPlayerRestore:
            return @"EventPlayerRestore";

        case NSMVideoPlayerEventReplacePlayerView:
            return @"EventReplacePlayerView";

        case NSMVideoPlayerActionPlay:
            return @"ActionPlay";

        case NSMVideoPlayerActionPause:
            return @"ActionPause";

        case NSMVideoPlayerActionReleasePlayer:
            return @"ActionReleasePlayer";

        case NSMVideoPlayerActionSeek:
            return @"ActionSeek";
        
    }
}

@end
