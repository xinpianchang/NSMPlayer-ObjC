//
//  CPSendMessageOperation.h
//  GCD的其他用法
//
//  Created by cqh on 15/1/27.
//  Copyright (c) 2015年 Cnepay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSMMessage, NSMMessageOperation;

@protocol NSMMessageOperationDelegate <NSObject>

@optional

- (void)sendMessageOperationDidStart:(NSMMessageOperation *)operation message:(NSMMessage *)message;

@end

@interface NSMMessageOperation : NSOperation

@property (nonatomic ,weak) id<NSMMessageOperationDelegate> delegate;
@property (nonatomic ,strong) NSMMessage *message;
@property (nonatomic, strong) NSThread *runloopThread;
@property (nonatomic, assign) NSTimeInterval delayTime;

- (instancetype)initWithTask:(NSMMessage *)message;
+ (instancetype)sendMessageOperationWithTask:(NSMMessage *)message;

@end

@interface NSMMessage : NSObject

@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, strong) id userInfo;

+ (instancetype)messageWithType:(NSInteger)type;
+ (instancetype)messageWithType:(NSInteger)type userInfo:(id)userInfo;
- (instancetype)initWithType:(NSInteger)type userInfo:(id)userInfo;

@end
