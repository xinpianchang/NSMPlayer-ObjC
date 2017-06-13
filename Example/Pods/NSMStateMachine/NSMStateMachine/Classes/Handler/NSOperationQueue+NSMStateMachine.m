// NSOperationQueue+NSMStateMachine.m
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

#import "NSOperationQueue+NSMStateMachine.h"
#import "NSMMessageOperation.h"

@implementation NSOperationQueue (NSMStateMachine)

- (void)nsm_addOperationAtFrontOfQueue:(NSOperation *)op {
    @synchronized (self) {
        BOOL wasSuspended = self.isSuspended;
        self.suspended = YES;
        NSArray *operations = self.operations;
        [operations enumerateObjectsUsingBlock:^(NSOperation* operation, NSUInteger idx, BOOL *stop) {
            if(![operation isExecuting]){
                [operation addDependency:op];
                *stop = YES;
            }
        }];
        [self addOperation:op];
        self.suspended = wasSuspended;
    }
}

- (void)nsm_addOperation:(NSOperation *)op {
    @synchronized (self) {
        BOOL wasSuspended = self.isSuspended;
        self.suspended = YES;
        NSInteger maxOperations = ([self maxConcurrentOperationCount] > 0) ? [self maxConcurrentOperationCount]: INT_MAX;
        NSArray *operations = [self operations];
        NSInteger index = [operations count] - maxOperations;
        if (index >= 0) {
            NSOperation *operation = operations[index];
            if (![operation isExecuting]) {
                [op addDependency:operation];
            }
        }
        [self addOperation:op];
        self.suspended = wasSuspended;
    }
}

- (void)nsm_removeOperationWithType:(NSInteger)type {
    @synchronized (self) {
        BOOL wasSuspended = self.isSuspended;
        self.suspended = YES;
        NSArray *operations = self.operations;
        [operations enumerateObjectsUsingBlock:^(NSMMessageOperation* operation, NSUInteger idx, BOOL *stop){
            if(type == operation.message.messageType) {
                [operation cancel];
            }
        }];
        self.suspended = wasSuspended;
    }
}

@end
