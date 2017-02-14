//
//  NSMVideoPlayer.m
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import "NSMVideoPlayer.h"
#import "NSMVideoPlayerControllerDataSource.h"


@implementation NSMPlayerState

@end

@implementation NSMPlayerInitialState

@end

@implementation NSMPlayerUnWorkingState
@end

@implementation NSMPlayerIdleState

@end

@implementation NSMPlayerFailedState

@end

@implementation NSMPlayerPreparingState

@end

@implementation NSMPlayerReayToPlayState

@end

@implementation NSMPlayerPlayedState

@end

@implementation NSMPlayerPlayingState

@end

@implementation NSMPlayerWaitBufferingToPlayState

@end

@implementation NSMPlayerPausedState

@end

@implementation NSMPlayerPausingState

@end

@implementation NSMPlayerCompletedState

@end


@interface NSMVideoPlayer ()

@property (nonatomic, strong) NSMVideoPlayerControllerDataSource *videoPlayerDataSource;
@property (nonatomic, strong) NSThread *stateMachineRunLoopThread;


@end

@implementation NSMVideoPlayer


- (instancetype)init {
    self = [super init];
    if (self) {
        _stateMachineRunLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(stateMachineRunLoopThreadThreadEntry) object:nil];
        [_stateMachineRunLoopThread start];
        self.smHandler.runloopThread = _stateMachineRunLoopThread;
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

- (NSMVideoPlayerControllerDataSource *)dataSource {
    return _videoPlayerDataSource;
}

- (void)setDataSource:(NSMVideoPlayerControllerDataSource *)dataSource {
    _videoPlayerDataSource = dataSource;
}


#pragma mark - Action

- (void)play {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionPlay];
    [self.stateMachine sendMessage:msg];
}

- (void)pause {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionPlay];
    [self.stateMachine sendMessage:msg];
}

- (void)releasePlayer {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionReleasePlayer];
    [self.stateMachine sendMessage:msg];
}

- (void)seekToTime:(NSTimeInterval)time {
    NSMMessage *msg = [NSMMessage messageWithType:NSMVideoPlayerActionSeek];
    msg.userInfo = @(time);
    [self.stateMachine sendMessage:msg];
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
    
    self.preparedState = [[NSMPlayerReayToPlayState alloc] initWithStateMachine:self];
    [self addState:self.preparedState parentState:self.initialState];

    self.playedState = [[NSMPlayerPlayedState alloc] initWithStateMachine:self];
    [self addState:self.playedState parentState:self.preparedState];
    
    self.playingState = [[NSMPlayerPlayingState alloc] initWithStateMachine:self];
    self.waitBufferingToPlayState = [[NSMPlayerWaitBufferingToPlayState alloc] initWithStateMachine:self];
    [self addState:self.playingState parentState:self.playedState];
    [self addState:self.waitBufferingToPlayState parentState:self.playedState];
    
    
    self.pausedState = [[NSMPlayerPausedState alloc] initWithStateMachine:self];
    [self addState:self.pausedState parentState:self.preparedState];
    self.pausingState = [[NSMPlayerPausingState alloc] initWithStateMachine:self];
    self.completedState = [[NSMPlayerCompletedState alloc] initWithStateMachine:self];
    [self addState:self.pausingState parentState:self.pausedState];
    [self addState:self.completedState parentState:self.pausedState];

    // Player 的 State 需要记在内存中吗？我们的播放器在页面切换的时候需要主动的 Release Player 吗？如果需要就需要 RestoreState
    // 还有状态机的生命周期？
    [self setInitialState:self.idleState];
}

@end
