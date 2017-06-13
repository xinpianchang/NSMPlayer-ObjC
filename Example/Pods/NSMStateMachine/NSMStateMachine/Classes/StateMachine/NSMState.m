// NSMState.m
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

#import "NSMState.h"
#import "NSMStateMachine.h"
#import "NSMMessageOperation.h"
#import "NSMStateMachineLogging.h"

@implementation NSMState

#pragma mark - Init

- (instancetype)initWithStateMachine:(NSMStateMachine *)stateMachine {
    if (self = [super init]) {
        _stateMachine = stateMachine;
    }
    return self;
}

+ (instancetype)stateWithStateMachine:(NSMStateMachine *)stateMachine {
    return [[self alloc] initWithStateMachine:stateMachine];
}

#pragma mark - State

- (void)enter {
}

- (void)exit {
}

- (BOOL)processMessage:(NSMMessage *)message {
    return NO;
}


#pragma mark - Send Message

- (void)sendMessageWithType:(NSInteger)type {
    NSMMessage *message = [NSMMessage messageWithType:type];
    [self.stateMachine sendMessage:message];
}

- (void)sendMessageWithType:(NSInteger)type userInfo:(id)obj {
    NSMMessage *message = [NSMMessage messageWithType:type];
    message.userInfo = obj;
    [self.stateMachine sendMessage:message];
}

- (void)sendMessage:(NSMMessage *)message {
    [self.stateMachine sendMessage:message];
}

- (void)deferredMessage:(NSMMessage *)message {
    [self.stateMachine deferredMessage:message];
}

@end
