//
//  CPSendMessageOperation.m
//  GCD的其他用法
//
//  Created by cqh on 15/1/27.
//  Copyright (c) 2015年 Cnepay. All rights reserved.
//

#import "NSMMessageOperation.h"
#import "NSMStateMachineLogging.h"

@interface NSMMessageOperation ()

@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;

@end

@implementation NSMMessageOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

+ (instancetype)sendMessageOperationWithTask:(NSMMessage *)message {
    return [[self alloc] initWithTask:message];
}

- (instancetype)initWithTask:(NSMMessage *)message {
    self = [super init];
    if (self) {
        self.message = message;
    }
    return self;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}


- (void)start {
    @synchronized(self) {
        if(self.isCancelled) {
            self.finished = YES;
            return;
        } else if ([self isReady]) {
            self.executing = YES;
            [self performSelector:@selector(operationDidStart) onThread:[self runloopThread] withObject:nil waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
        }
    }
}

- (void)operationDidStart {
    if (self.delayTime != 0.0) {
        [self performSelector:@selector(operationDidStart) withObject:nil afterDelay:self.delayTime inModes:@[NSRunLoopCommonModes]];
        self.delayTime = 0.0;
    } else {
        if ([self.delegate respondsToSelector:@selector(sendMessageOperationDidStart:message:)]) {
            [self.delegate sendMessageOperationDidStart:self message:self.message];
            self.finished = YES;
        }
    }
}

- (void)dealloc {
    NSMSMLogDebug(@"%@-dealloc",self);
}

@end

@implementation NSMMessage

+ (instancetype)messageWithType:(NSInteger)type {
    return [self messageWithType:type userInfo:nil];
}

+ (instancetype)messageWithType:(NSInteger)type userInfo:(id)userInfo {
    return [[self alloc] initWithType:type userInfo:userInfo];
}

- (instancetype)initWithType:(NSInteger)type userInfo:(id)userInfo {
    if (self == [super init]) {
        self.messageType = type;
        self.userInfo = userInfo;
    }
    return self;
}

@end

