//
//  SmHandler.h
//  Pods
//
//  Created by chengqihan on 16/4/7.
//
//

#import "NSMMessagesQueue.h"

@class NSMStateMachine, NSMState;

@interface NSMStateInfo : NSObject

@property (nonatomic, strong) NSMState *state;
@property (nonatomic, strong) NSMStateInfo *parentStateInfo;
@property (nonatomic, assign) BOOL active;

- (instancetype)initWithState:(NSMState *)state;
+ (instancetype)stateInfoWithState:(NSMState *)state;

@end

@interface NSMSMHandler : NSMMessagesQueue

@property (nonatomic, strong) NSMutableArray *deferredMessages;
@property (nonatomic, strong) NSMState *initialState;
@property (nonatomic, readonly, strong) NSMutableDictionary *mapStateInfo;
@property (nonatomic, readonly, strong) NSMMessage *currentMessage;
@property (nonatomic, weak) NSMStateMachine* handlerDelegate;

- (void)completeConstruction;
- (void)transitionToState:(NSMState *)state;
- (NSMStateInfo *)addState:(NSMState *)state parentState:(NSMState *)parentState;
- (void)quitNow;

- (BOOL)isQuit:(NSMMessage *)msg;

@end
