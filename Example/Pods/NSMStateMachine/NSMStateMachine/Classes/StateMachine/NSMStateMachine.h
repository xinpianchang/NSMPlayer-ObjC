//
//  CPState.h
//  Model
//
//  Created by cnepayzx on 15-1-21.
//  Copyright (c) 2015年 cnepay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMMessageOperation.h"
#import "NSMSMHandler.h"
#import "NSMState.h"

FOUNDATION_EXPORT NSInteger const NSMMessageTypeActionInit;
FOUNDATION_EXPORT NSInteger const NSMMessageTypeActionQuit;

@class NSMMessagesQueue, NSMSMHandler;

@interface NSMSMQuittingState : NSMState

@end


@interface NSMStateMachine : NSObject

@property (nonatomic, readonly, strong) NSMSMQuittingState *quittingState;
@property (nonatomic, strong) NSMState *destState;

@property (readonly, nonatomic, strong) NSMSMHandler *smHandler;

+ (instancetype)stateMachine;

//顺序发送事件
- (void)sendMessage:(NSMMessage *)message;
- (void)sendMessageType:(NSInteger)type;
//插入到队列的前面
- (void)sendMessageFront:(NSMMessage *)message;
- (void)sendMessageFrontType:(NSInteger)type;
- (void)removeMessageWithType:(NSInteger)type;
//缓存
- (void)deferredMessage:(NSMMessage *)message;
- (BOOL)hasDeferredMessage:(NSInteger)type;
- (void)removeDeferredMessage:(NSInteger)type;

//设置初始的状态
- (void)initialState:(NSMState *)state;

- (void)addState:(NSMState *)state parentState:(NSMState *)parentState;

- (void)transitionToState:(NSMState *)destState;

- (void)sendMessageDelayed:(NSMMessage *)msg delay:(NSTimeInterval)delay;

- (void)start;
/**
 *  退出状态机
 */
- (void)quitNow;

/**
 *  根据msg判断是否是退出message
 *
 *  @param msg 消息
 *
 *  @return 是否退出
 */
- (BOOL)isQuit:(NSMMessage *)msg;

/**
 *  smHandlerProcessFinalMessage
 *  自定义的method,在performTransition的时候调用,做数据库使用
 *
 *  @param msg 消息
 */

- (void)smHandlerProcessFinalMessage:(NSMMessage *)msg;

@end

