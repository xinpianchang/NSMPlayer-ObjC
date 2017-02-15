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
        case NSMVideoPlayerActionReplacePlayerItem: {
            [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
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

@end

@implementation NSMPlayerIdleState
- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusIdle;
}
//- (BOOL)processMessage:(NSMMessage *)message {
//    switch (message.messageType) {
//
//        case NSMVideoPlayerActionPlay : {
//            [self.videoPlayer transitionToState:self.videoPlayer.preparingState];
//        }
//        return YES;
//
//        default:
//        break;
//    }
//    return NO;
//}

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
    [[self.videoPlayer.underlyingPlayer prepare] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.result) {
            //            [self.videoPlayer play];
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventReadyToPlay];
            [self.stateMachine sendMessage:msg];
        } else if (t.error) {
            NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerEventFailure];
            [self.stateMachine sendMessage:msg];
        }
        return nil;
    }];
}

- (BOOL)processMessage:(NSMMessage *)message {
    switch (message.messageType) {
        case NSMVideoPlayerEventReadyToPlay: {
            [self.videoPlayer transitionToState:self.videoPlayer.playedState];
            return YES;
        }
        default:
            return NO;
    }
    return NO;
}

@end

@implementation NSMPlayerReayToPlayState

@end

@implementation NSMPlayerPlayedState

- (void)enter {
    [super enter];
    [self.videoPlayer.underlyingPlayer play];
}

@end

@implementation NSMPlayerPlayingState
- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusPlaying;
}

@end

@implementation NSMPlayerWaitBufferingToPlayState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusWaitBufferingToPlay;
}

@end

@implementation NSMPlayerPausedState

@end

@implementation NSMPlayerPausingState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusPaused;
}

@end

@implementation NSMPlayerCompletedState

- (void)enter {
    [super enter];
    self.videoPlayer.currentStatus = NSMVideoPlayerStatusPlayToEndTime;
}

@end


@interface NSMVideoPlayer ()

@property (nonatomic, strong) NSMVideoPlayerControllerDataSource *dataSource;
@property (nonatomic, strong) NSThread *stateMachineRunLoopThread;
@property (nonatomic, strong) NSMutableDictionary *players;

@end

@implementation NSMVideoPlayer

- (void)stateMachineRunLoopThreadThreadEntry {
    @autoreleasepool {
        NSThread * currentThread = [NSThread currentThread];
        currentThread.name = @"StateMachineOfPlayerThread";
        NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
        [currentRunloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [currentRunloop run];
    }
}


- (NSMVideoPlayerControllerDataSource *)videoPlayerDataSource {
    return _dataSource;
}
- (void)setVideoPlayerDataSource:(NSMVideoPlayerControllerDataSource *)dataSource {
    _dataSource = dataSource;
    [self.underlyingPlayer setPlayerSource:dataSource];
}


#pragma mark - NSMVideoPlayerProtocol

- (void)play {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionPlay];
    [self sendMessage:msg];
}

- (void)pause {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionPlay];
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

- (void)replaceItem {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionReplacePlayerItem];
    [self sendMessage:msg];
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
        self.players = [NSMutableDictionary dictionary];
        self.stateMachineRunLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(stateMachineRunLoopThreadThreadEntry) object:nil];
        [self.stateMachineRunLoopThread start];
        self.smHandler.runloopThread = self.stateMachineRunLoopThread;
        self.playerType = playerType;
        [self start];
    }
    return self;
}

- (void)setPlayerType:(NSMVideoPlayerType)playerType {
    
    if (_playerType != playerType) {
        NSMUnderlyingPlayer * player = self.players[@(playerType)];
        if (!player) {
            if (NSMVideoPlayerAVPlayer == playerType) {
                player = [[NSMAVPlayer alloc] initWithAssetURL:self.dataSource.assetURL];
            } else if (NSMVideoPlayerIJKPlayer == playerType) {
                
            }
        }
        self.players[@(playerType)] = player;
        self.underlyingPlayer = player;
        _playerType = playerType;
        //切换播放器内核
    }
}

- (id)player {
    return self.underlyingPlayer.player;
}
@end
