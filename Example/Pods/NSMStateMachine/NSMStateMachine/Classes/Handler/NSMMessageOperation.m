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
/*
 * 利用无名扩展 让readOnly属性,在内部可以变成可读可写属性。
 */
@property (assign, nonatomic, getter=isExecuting) BOOL executing;
@property (assign, nonatomic, getter=isFinished) BOOL finished;

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
        if(self.isCancelled)
        {
            self.finished = YES;
            return;

        } else if ([self isReady]){
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

//- (instancetype)initWithType:(MessageType)type obj:(id)object {
//    return [self initWithType:type subType:0 code:0 obj:object];
//}
//
//+ (instancetype)messageWithType:(MessageType)type obj:(id)object {
//    return  [[self alloc] initWithType:type obj:object];
//}
//
//+ (instancetype)messageWithType:(MessageType)type {
//    return [[self alloc] initWithType:type subType:0 code:0 obj:nil];
//}
//
//- (instancetype)initWithType:(MessageType)type {
//    return [self initWithType:type subType:0 code:0 obj:nil];
//}
//
//+ (instancetype)messageWithType:(MessageType)type subType:(int)subType code:(int)code obj:(id)object {
//    return [[self alloc] initWithType:type subType:subType code:code obj:object];
//}
//
//- (instancetype)initWithType:(MessageType)type subType:(int)subType code:(int)code obj:(id)object {
//    if (self == [super init]) {
//        _type = type;
//        _subType = subType;
//        _code = code;
//        _obj = object;
//    }
//    return self;
//}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"type:%zd subType:%d code:%d id:%@",_type,_subType,_code,_obj];
//}

@end

