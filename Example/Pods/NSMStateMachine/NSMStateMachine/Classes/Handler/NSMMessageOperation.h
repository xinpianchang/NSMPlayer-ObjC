// NSMMessageOperation.h
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
@property (nonatomic, copy) NSString *messageDescription;

+ (instancetype)messageWithType:(NSInteger)type;
+ (instancetype)messageWithType:(NSInteger)type userInfo:(id)userInfo;
- (instancetype)initWithType:(NSInteger)type userInfo:(id)userInfo;

@end
