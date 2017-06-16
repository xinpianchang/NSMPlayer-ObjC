// NSMStateMachine.m
//
// Copyright (c) 2017 NSMStateMachine
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

#import "NSMStateMachine.h"
#import "NSMState.h"
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

@property (nonatomic, strong) NSMSMHandler *smHandler;
@property (nonatomic, strong) NSMSMQuittingState *quittingState;

@end

@implementation NSMStateMachine

- (void)initialState:(NSMState *)state {
    [self.smHandler setInitialState:state];
}

- (void)transitionToState:(NSMState *)destState
{
    [self.smHandler transitionToState:destState];
}

- (NSMState *)currentState {
    return self.smHandler.currentState;
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
    if (self = [super init]) {
        _quittingState = [[NSMSMQuittingState alloc] initWithStateMachine:self];
        _smHandler = [[NSMSMHandler alloc] init];
        [_smHandler addState:_quittingState parentState:nil];
        _smHandler.handlerDelegate = self;
    }
    return self;
}

- (void)start {
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
    [self.smHandler addMessage:message];
}

- (void)sendMessageType:(NSInteger)type {
    [self.smHandler addMessage:[NSMMessage messageWithType:type]];
}

- (void)sendMessageFront:(NSMMessage *)message {
    [self.smHandler addMessageAtFront:message];
}

- (void)sendMessageFrontType:(NSInteger)type {
    [self.smHandler addMessageAtFront:[NSMMessage messageWithType:type]];
}

- (void)removeMessageWithType:(NSInteger)type {
    [self.smHandler removeMessageWithType:type];
}

- (void)sendMessageDelayed:(NSMMessage *)msg delay:(NSTimeInterval)delay {
    [self.smHandler delayMessage:msg delay:delay];
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
