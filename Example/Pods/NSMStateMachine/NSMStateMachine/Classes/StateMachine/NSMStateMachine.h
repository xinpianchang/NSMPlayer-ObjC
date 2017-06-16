// NSMStateMachine.h
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
@property (nonatomic, readonly, strong) NSMState *currentState;
@property (nonatomic, readonly, strong) NSMSMHandler *smHandler;

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

- (void)onQuitting;

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

