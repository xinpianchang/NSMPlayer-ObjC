// NSMSMHandler.h
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

@class NSMStateMachine, NSMState, NSMMessage;

@interface NSMStateInfo : NSObject

@property (nonatomic, strong) NSMState *state;
@property (nonatomic, strong) NSMStateInfo *parentStateInfo;
@property (nonatomic, assign) BOOL active;

- (instancetype)initWithState:(NSMState *)state;
+ (instancetype)stateInfoWithState:(NSMState *)state;

@end

@interface NSMSMHandler : NSObject

@property (nonatomic, strong) NSThread *runloopThread;
@property (nonatomic, strong) NSMutableArray *deferredMessages;
@property (nonatomic, strong) NSMState *initialState;
@property (nonatomic, readonly, strong) NSMutableDictionary<NSString *, NSMStateInfo *> *mapStateInfo;
@property (nonatomic, readonly, strong) NSMMessage *currentMessage;
@property (nonatomic, weak) NSMStateMachine* handlerDelegate;
@property (nonatomic, readonly, strong) NSOperationQueue *operationQueue;
@property (nonatomic, readonly, strong) NSMState *currentState;

- (void)addMessageAtFront:(NSMMessage *)message;
- (void)addMessage:(NSMMessage *)message;
- (void)delayMessage:(NSMMessage *)message delay:(NSTimeInterval)delay;
- (void)removeMessage:(NSMMessage *)message;
- (void)removeMessageWithType:(NSInteger)type;

- (void)completeConstruction;
- (void)transitionToState:(NSMState *)state;
- (NSMStateInfo *)addState:(NSMState *)state parentState:(NSMState *)parentState;
- (void)quitNow;

- (BOOL)isQuit:(NSMMessage *)msg;

@end
