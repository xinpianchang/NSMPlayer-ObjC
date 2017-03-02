//
//  CPState.m
//  Model
//
//  Created by cnepayzx on 15-1-21.
//  Copyright (c) 2015年 cnepay. All rights reserved.
//

#import "NSMStateMachine.h"
#import "NSMState.h"
#import "NSMMessagesQueue.h"
#import "NSMMessageOperation.h"
#import "NSMSMHandler.h"
#import "NSMStateMachineLogging.h"

NSInteger const NSMMessageTypeActionQuit = -1;
NSInteger const NSMMessageTypeActionInit = -2;

@implementation NSMSMQuittingState

- (BOOL)processMessage:(NSMMessage *)message {
    return NO;
}

@end

@interface NSMStateMachine()

@property(nonatomic,strong) NSMState *currentState;
@property (readwrite, nonatomic, strong) NSMSMHandler *smHandler;
@property (readwrite, nonatomic, strong) NSMSMQuittingState *quittingState;

@end

@implementation NSMStateMachine

- (void)initialState:(NSMState *)state {
    [self.smHandler setInitialState:state];
}

- (void)transitionToState:(NSMState *)destState
{
    [self.smHandler transitionToState:destState];
}

+ (instancetype)stateMachine {
    return [[self alloc] init];
}

- (void)quitNow {
    [self.smHandler quitNow];
}

- (void)onQuitting {
    
}

- (BOOL)isQuit:(NSMMessage *)msg {
    
    if (self.smHandler) {
        return [self.smHandler isQuit:msg];
    }else {
        return msg.messageType = NSMMessageTypeActionQuit;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _quittingState = [[NSMSMQuittingState alloc] initWithStateMachine:self];
        _smHandler = [[NSMSMHandler alloc] init];
        [_smHandler addState:_quittingState parentState:nil];
        _smHandler.handlerDelegate = self;
    }
    return self;
}

- (void)start {
    NSMSMLogDebug(@"self %@ %@",self,[NSThread currentThread]);
    [self.smHandler completeConstruction];
}


- (BOOL)hasDeferredMessage:(NSInteger)type {
    for (NSMMessage *msg in self.smHandler.deferredMessages) {
        if (msg.messageType == type) {
            return YES;
        }
    }
    return NO;
    
}

- (void)removeDeferredMessage:(NSInteger)type {
    NSMutableArray *tempDeferredArray = [NSMutableArray array];
    for (NSMMessage *msg in self.smHandler.deferredMessages) {
        if (msg.messageType != type) {
            [tempDeferredArray addObject:msg];
        }
    }
    [self.smHandler.deferredMessages removeAllObjects];
    self.smHandler.deferredMessages = tempDeferredArray;
}

- (void)sendMessage:(NSMMessage *)message {
    [self.smHandler addOperationAtEndOfQueue:message];
}

- (void)sendMessageType:(NSInteger)type {
    [self.smHandler addOperationAtEndOfQueue:[NSMMessage messageWithType:type]];
}

- (void)sendMessageFront:(NSMMessage *)message {
    [self.smHandler addOperationAtFrontOfQueue:message];
}

- (void)sendMessageFrontType:(NSInteger)type {
    [self.smHandler addOperationAtFrontOfQueue:[NSMMessage messageWithType:type]];
}

- (void)removeMessageWithType:(NSInteger)type {
    [self.smHandler.operations enumerateObjectsUsingBlock:^(__kindof NSMMessageOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.message.messageType == type && ![obj isExecuting]) {
            [obj cancel];
        }
    }];
}

- (void)sendMessageDelayed:(NSMMessage *)msg delay:(NSTimeInterval)delay {
    [self.smHandler delayOperationAtEndOfQueue:msg delay:delay];
}

- (void)deferredMessage:(NSMMessage *)message {
    [self.smHandler.deferredMessages addObject:message];
}

- (void)addState:(NSMState *)state parentState:(NSMState *)parentState {
    [self.smHandler addState:state parentState:parentState];
}

- (void)smHandlerProcessFinalMessage:(NSMMessage *)msg {
    
}

@end
