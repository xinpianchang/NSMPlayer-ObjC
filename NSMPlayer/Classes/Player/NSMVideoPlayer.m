//
//  NSMVideoPlayer.m
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import "NSMVideoPlayer.h"
#import <Bolts/Bolts.h>
#import "NSMPlayerAsset.h"
#import "NSMAVPlayer.h"
#import "Reachability.h"
#import "NSMPlayerError.h"

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
            NSError *error = message.userInfo;
            NSMPlayerRestoration *restoration = [self.videoPlayer savePlayerState];
            NSMPlayerError *playerError = [[NSMPlayerError alloc] init];
            playerError.restoration = restoration;
            playerError.error = error;
            self.videoPlayer.playerError = playerError;
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
        
        case NSMVideoPlayerEventPlayerRestore: {
            self.videoPlayer.tempRestoringConfig = nil;
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
            } else if (self.videoPlayer.isPreload) {
                [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventStartPreparing];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
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
                        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPlayerStartRestorePrepare userInfo:message.userInfo];
                        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                        [self sendMessage:msg];
//                        self.videoPlayer.tempRestoringConfig = nil;
                    }
                    break;
                }
                    
                default:
                    NSLog(@"NSMVideoPlayerEventPlayerRestore");
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

- (void)exit {
    [super exit];
    self.videoPlayer.playerError = nil;
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
            [self.videoPlayer transitionToState:self.videoPlayer.readyToPlayState];
            NSMPlayerRestoration *restoration = self.videoPlayer.tempRestoringConfig;
            if (restoration != nil) {
                
                switch (restoration.restoredStatus) {
                    case NSMVideoPlayerStatusPaused: {
                        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPause];
                        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                        [self sendMessage:msg];
                        break;
                    }
                        
                    case NSMVideoPlayerStatusPlayToEndTime: {
                        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventCompleted];
                        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                        [self sendMessage:msg];
                        break;
                    }
                        
                    case NSMVideoPlayerStatusPlaying: {
                        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPlay];
                        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                        [self sendMessage:msg];
                        break;
                    }
                        
                    default:
                        break;
                        
                }
                self.videoPlayer.tempRestoringConfig = nil;
                
            } else {
                if (self.videoPlayer.intentToPlay) {
                    [self.videoPlayer transitionToState:self.videoPlayer.readyToPlayState];
                    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPlay];
                    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                    [self sendMessage:msg];
                } else {
                    [self.videoPlayer transitionToState:self.videoPlayer.readyToPlayState];
                    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPause];
                    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                    [self sendMessage:msg];
                }
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
                //if avplayer has initialized, release
                [self.videoPlayer.underlyingPlayer releasePlayer];
                NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
                msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                [self sendMessage:msg];
            }
            return YES;
        }
        
        case NSMVideoPlayerEventPlayerStartRestorePrepare: {
            if (self.videoPlayer.currentAsset == nil) {
                [self.videoPlayer transitionToState:self.videoPlayer.idleState];
            } else {
                if ([self.videoPlayer shouldPlayWithWWAN]) {
                    // 是否允许 3G/4G网络播放
                    [self.videoPlayer prepare];
                    NSMPlayerRestoration *restoration = message.userInfo;
                    [self.videoPlayer seekToTime:restoration.seekTime];
                } else {
                    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
                    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
                    [self sendMessage:msg];
                    //[self sendMessageWithType:NSMVideoPlayerEventFailure userInfo:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"不允许使用3G/4G播放"}]];
                }
            }
            return YES;
        }
        default:
            return NO;
    }
}

@end

@implementation NSMPlayerReayToPlayState

- (void)enter {
    [super enter];
//    self.videoPlayer.underlyingPlayer.rate = self.videoPlayer.rate;
    self.videoPlayer.underlyingPlayer.volume = self.videoPlayer.volume;
    self.videoPlayer.underlyingPlayer.muted = self.videoPlayer.isMuted;
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
                [self.videoPlayer.underlyingPlayer seekToTime:0];
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
            return YES;
        }
        
        case NSMVideoPlayerActionSeek: {
            BFTaskCompletionSource *tcs = message.userInfo[@"tcs"];
            // 循环播放
            [[self.videoPlayer.underlyingPlayer seekToTime:[message.userInfo[@"time"] doubleValue]] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                [tcs setResult:nil];
                return nil;
            }];
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
            }
            return YES;
        }
        
        case NSMVideoPlayerEventAdjustVolume: {
            [self.videoPlayer.underlyingPlayer setVolume:[message.userInfo floatValue]];
            return YES;
        }
        
//        case NSMVideoPlayerEventAdjustRate: {
//            [self.videoPlayer.underlyingPlayer setRate:[message.userInfo floatValue]];
//            return YES;
//        }
        
        case NSMVideoPlayerEventSetMuted: {
            [self.videoPlayer.underlyingPlayer setMuted:[message.userInfo boolValue]];
            return YES;
        }
        
        case NSMVideoPlayerEventReplacePlayerView: {
            [self.videoPlayer.underlyingPlayer setPlayerView:self.videoPlayer.playerView];
            return YES;
        }
        
        case NSMVideoPlayerEventEnoughBufferToPlay: {
            self.videoPlayer.buffering = NO;
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventUpdateBuffering];
            msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
            [self sendMessage:msg];
            return YES;
        }
         
        case NSMVideoPlayerEventWaitingBufferToPlay: {
            self.videoPlayer.buffering = YES;
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventUpdateBuffering];
            msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
            [self sendMessage:msg];
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
    if (self.videoPlayer.isBuffering) {
        [self.videoPlayer transitionToState:self.videoPlayer.waitBufferingToPlayState];
    } else {
        [self.videoPlayer transitionToState:self.videoPlayer.playingState];
    }
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        
        case NSMVideoPlayerActionPause: {
            [self.videoPlayer transitionToState:self.videoPlayer.pausingState];
            return YES;
        }
            
        case NSMVideoPlayerEventUpdateBuffering: {
            if (self.videoPlayer.isBuffering) {
                [self.videoPlayer transitionToState:self.videoPlayer.waitBufferingToPlayState];
            } else {
                [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            }
            return YES;
        }
            
        case NSMVideoPlayerActionPlay:
        case NSMVideoPlayerEventPlay:
            return YES;
        
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
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerActionPlay: {
            [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            return YES;
        }
        
        case NSMVideoPlayerActionSeek: {
            [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            [self sendMessage:message];
            return YES;
        }
        
        case NSMVideoPlayerActionPause:
        case NSMVideoPlayerEventPause:
            return YES;
        
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
            if (self.videoPlayer.isLoopPlayback) {
                [self.videoPlayer.underlyingPlayer seekToTime:0];
                [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            }
            return YES;
        }
        
        case NSMVideoPlayerActionSeek: {
            BFTaskCompletionSource *tcs = message.userInfo[@"tcs"];
            // 循环播放
            [[self.videoPlayer.underlyingPlayer seekToTime:[message.userInfo[@"time"] doubleValue]] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                [tcs setResult:nil];
                return nil;
            }];
            [self.videoPlayer transitionToState:self.videoPlayer.playingState];
            return YES;
        }
        
        case NSMVideoPlayerEventAllowWWANChange: {
            
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
@property (nonatomic, strong) NSMPlayerAsset *currentAsset;
@property (nonatomic, strong) Reachability *reach;
- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation NSMVideoPlayer
@dynamic rate;

@synthesize currentStatus = _currentStatus;
@synthesize loopPlayback = _loopPlayback;
@synthesize autoPlay = _autoPlay;
@synthesize preload = _preload;
@synthesize muted = _muted;
@synthesize volume = _volume;
@synthesize allowWWAN = _allowWWAN;
@synthesize playerType = _playerType;
@synthesize playerView = _playerView;

- (instancetype)initWithPlayerType:(NSMVideoPlayerType)playerType {
    self = [super init];
    if (self) {
        _playerType = playerType;
        
        _reach = [Reachability reachabilityForInternetConnection];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        [_reach startNotifier];
        
        _volume = 1;
        _currentStatus =  NSMVideoPlayerStatusUnknown;
        self.players = [NSMutableDictionary dictionary];
        self.stateMachineRunLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(stateMachineRunLoopThreadThreadEntry) object:nil];
        [self.stateMachineRunLoopThread start];
        self.smHandler.runloopThread = self.stateMachineRunLoopThread;
        [self start];
        
        [self registerObserver];
        
        [self setupUnderlyingPlayerWithPlayerType:playerType];
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

//- (void)suspendPlayingback {
//    [self.underlyingPlayer suspendPlayingback];
//}

- (NSProgress *)bufferProgress {
    return self.underlyingPlayer.bufferProgress;
}

- (NSProgress *)playbackProgress {
    return self.underlyingPlayer.playbackProgress;
}

- (void)replaceCurrentAssetWithAsset:(NSMPlayerAsset *)asset {
    NSAssert(asset.assetURL, @"playerSource.assetURL is nil");
    if (![self.currentAsset.assetURL.absoluteString isEqualToString:asset.assetURL.absoluteString]) {
        self.currentAsset = asset;
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventReplacePlayerItem];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
    }
}

- (void)setPlayerView:(id<NSMVideoPlayerViewProtocol>)playerView {
    _playerView = playerView;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventReplacePlayerView];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)setRate:(CGFloat)rate {
    [self.underlyingPlayer setRate:rate];
}

//- (NSTimeInterval)currentTime {
//    return [self.underlyingPlayer currentTime];
//}
//
//- (NSTimeInterval)bufferPercentage {
//    return self.underlyingPlayer.bufferPercentage;
//}

- (BFTask *)prepare {
    [self.underlyingPlayer replaceCurrentAssetWithAsset:self.currentAsset];
    return [[self.underlyingPlayer prepare] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.result) {
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPreparingCompleted];
            msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
            [self sendMessage:msg];
        } else if (t.error) {
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure];
            msg.userInfo  = t.error;
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
    self.tempRestoringConfig = nil;
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionReleasePlayer];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (BFTask *)seekToTime:(NSTimeInterval)time {
    BFTaskCompletionSource *tcs = [BFTaskCompletionSource taskCompletionSource];
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionSeek];
    msg.userInfo = @{@"time": @(time), @"tcs": tcs};
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
    return tcs.task;
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

//- (void)setRate:(CGFloat)rate {
//    _rate = rate;
//    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventAdjustRate userInfo:@(rate)];
//    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
//    [self sendMessage:msg];
//}

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

//- (NSTimeInterval)duration {
//    return self.underlyingPlayer.duration;
//}


- (void)restorePlayerWithRestoration:(NSMPlayerRestoration *)restoration {
    
    if (self.tempRestoringConfig == nil) {
        _currentAsset = restoration.playerAsset;
        _playerType = restoration.playerType;
        _autoPlay = restoration.isAutoPlay;
        _preload = restoration.isPreload;
        _loopPlayback = restoration.isLoopPlayback;
        _allowWWAN = restoration.isAllowWWAN;
        _muted = restoration.isMuted;
        _volume = restoration.volume;
//        _rate = config.rate;
        
        NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPlayerRestore userInfo:restoration];
        msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
        [self sendMessage:msg];
        self.tempRestoringConfig = restoration;
    } else {
        // 正在恢复
    }
}

- (NSMPlayerRestoration *)savePlayerState {
    if (self.tempRestoringConfig != nil) {
        return self.tempRestoringConfig;
    } else {
        NSMPlayerRestoration *restoration = [[NSMPlayerRestoration alloc] init];
        if ([self isOnCurrentLevelWithLevel:NSMVideoPlayerStatusLevelReadyToPlay] || self.currentStatus == NSMVideoPlayerStatusPreparing) {
            restoration.restoredStatus = self.intentToPlay ? NSMVideoPlayerStatusPlaying : NSMVideoPlayerStatusPaused;
        } else {
            restoration.restoredStatus = self.currentStatus;
        }
        
        if (NSMVideoPlayerStatusPlayToEndTime == self.currentStatus) {
            restoration.intentToPlay = NO;
            restoration.seekTime = 0;
        } else if (NSMVideoPlayerStatusFailed == self.currentStatus) {
            restoration.intentToPlay = NO;
            restoration.seekTime = self.playbackProgress.completedUnitCount;
            restoration.playerError = self.playerError;
        } else {
            restoration.intentToPlay = self.intentToPlay;
            restoration.seekTime = self.playbackProgress.completedUnitCount;
        }
        
        restoration.playerAsset = self.currentAsset;
        restoration.playerError = self.playerError;
        restoration.playerType = self.playerType;
        restoration.autoPlay = self.isAutoPlay;
        restoration.preload = self.isPreload;
        restoration.muted = self.isMuted;
        restoration.allowWWAN = self.isAllowWWAN;
        restoration.volume = self.volume;
//        restoration.rate = self.rate;
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
    id<NSMUnderlyingPlayerProtocol>  player = self.players[@(playerType)];
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
    //AFNetworkingReachabilityDidChangeNotification
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerDidPlayToEndTime:) name:NSMUnderlyingPlayerDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerFailed:) name:NSMUnderlyingPlayerFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerPlaybackBufferEmpty:) name:NSMUnderlyingPlayerPlaybackBufferEmptyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerPlaybackLikelyToKeepUp:) name:NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underlyingPlayerPlaybackStallingNotification:) name:NSMUnderlyingPlayerPlaybackStallingNotification object:nil];
}

- (void)underlyingPlayerDidPlayToEndTime:(NSNotification *)notification {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventCompleted];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)underlyingPlayerFailed:(NSNotification *)notification {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure userInfo:notification.userInfo[NSMUnderlyingPlayerErrorKey]];
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

- (void)underlyingPlayerPlaybackStallingNotification:(NSNotification *)notification {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventPause];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
}

- (void)reachabilityChanged:(NSNotification *)notification {
    //AFNetworkReachabilityStatus status = notification.userInfo[AFNetworkingReachabilityNotificationStatusItem];
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventAllowWWANChange];
    msg.messageDescription = NSMVideoPlayerMessageDescription(msg.messageType);
    [self sendMessage:msg];
    
}
- (BOOL)shouldPlayWithWWAN {
    if ([_reach isReachableViaWWAN]) {
        if (self.isAllowWWAN) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
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
        
        case NSMVideoPlayerEventPlayerStartRestorePrepare:
            return @"EventPlayerStartRestorePrepare";
        
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
