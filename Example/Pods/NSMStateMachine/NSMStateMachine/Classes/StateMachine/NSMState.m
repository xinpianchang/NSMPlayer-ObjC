//
//  State.m
//  Model1
//
//  Created by cnepayzx on 15-1-19.
//  Copyright (c) 2015年 cnepay. All rights reserved.
//

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

-(NSString *)getName {
    return NSStringFromClass(self.class);
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

- (void)deferredMessage:(NSMMessage *)message {
    [self.stateMachine deferredMessage:message];
}

@end
