//
//  CPMessagesQueue.h
//  GCD的其他用法
//
//  Created by cqh on 15/1/27.
//  Copyright (c) 2015年 Cnepay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMMessageOperation.h"

@class NSMMessage;

@interface NSMMessagesQueue : NSOperationQueue <NSMMessageOperationDelegate>

@property (readwrite, nonatomic, strong) NSThread *runloopThread;

- (void)addOperationAtFrontOfQueue:(NSMMessage *)op;
- (void)addOperationAtEndOfQueue:(NSMMessage *)op;
- (void)delayOperationAtEndOfQueue:(NSMMessage *)op delay:(NSTimeInterval)delay;
- (void)removeOperationWithMessage:(NSMMessage *)message;

@end
