//
//  State.h
//  Model1
//
//  Created by cnepayzx on 15-1-19.
//  Copyright (c) 2015年 cnepay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSMStateMachine, NSMMessage;

@interface NSMState : NSObject

@property (nonatomic, weak) NSMStateMachine *stateMachine;

- (instancetype)initWithStateMachine:(NSMStateMachine *)stateMachine;
+ (instancetype)stateWithStateMachine:(NSMStateMachine *)stateMachine;

- (void)enter;
- (void)exit;
- (BOOL)processMessage:(NSMMessage *)message;
- (NSString *)getName;

- (void)sendMessageWithType:(NSInteger)type;
- (void)sendMessageWithType:(NSInteger)type userInfo:(id)obj;
- (void)deferredMessage:(NSMMessage *)message;

@end


