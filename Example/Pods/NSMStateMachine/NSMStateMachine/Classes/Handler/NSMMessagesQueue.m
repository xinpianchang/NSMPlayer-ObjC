//
//  CPMessagesQueue.m
//  GCD的其他用法
//
//  Created by cqh on 15/1/27.
//  Copyright (c) 2015年 Cnepay. All rights reserved.
//

#import "NSMMessagesQueue.h"
#import "NSMMessageOperation.h"

@interface NSMMessagesQueue ()

@property (nonatomic ,weak) NSMMessageOperation *lastOperation;

@end

@implementation NSMMessagesQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)addOperationAtEndOfQueue:(NSMMessage *)message {
    NSMMessageOperation *op = [NSMMessageOperation sendMessageOperationWithTask:message];
    op.runloopThread = self.runloopThread;
    op.delegate = self;
    
    if (self.lastOperation) {
        [op addDependency:self.lastOperation];
    }
    @synchronized (self) {
        self.lastOperation = op;
    }
    [super addOperation:op];
}


- (void)addOperationAtFrontOfQueue:(NSMMessage *)message {
    NSMMessageOperation *op = [NSMMessageOperation sendMessageOperationWithTask:message];
    op.runloopThread = self.runloopThread;
    op.delegate = self;
    
    NSArray *operations = self.operations;
    [operations enumerateObjectsUsingBlock:^(NSMMessageOperation* operation, NSUInteger idx, BOOL *stop) {
        if([operation isExecuting]){
            [op addDependency:operation];
        }else{
            [operation addDependency:op];
        }
    }];
    [super addOperation:op];
}


- (void)removeOperationWithMessage:(NSMMessage *)message {
    
    NSArray *operations = self.operations;
    [operations enumerateObjectsUsingBlock:^(NSMMessageOperation* operation, NSUInteger idx, BOOL *stop){
        if(message.messageType == operation.message.messageType) {
            [operation cancel];
        }
    }];
}

- (void)delayOperationAtEndOfQueue:(NSMMessage *)message delay:(NSTimeInterval)delay {
    
    NSMMessageOperation *op = [NSMMessageOperation sendMessageOperationWithTask:message];
    op.runloopThread = self.runloopThread;
    op.delegate = self;
    op.delayTime = delay;
    if (self.lastOperation) {
        [op addDependency:self.lastOperation];
    }
    @synchronized (self) {
        self.lastOperation = op;
    }
    [super addOperation:op];
}


- (void)sendMessageOperation:(NSMMessageOperation *)operation didFinishSendMessage:(NSMMessage *)message {
}

@end

