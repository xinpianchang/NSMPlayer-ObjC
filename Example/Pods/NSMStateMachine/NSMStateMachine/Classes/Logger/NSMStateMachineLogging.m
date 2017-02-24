//
//  NSMStateMachineLogging.m
//  Pods
//
//  Created by chengqihan on 2017/2/14.
//
//

#import "NSMStateMachineLogging.h"

@implementation NSMStateMachineLogging

+ (DDLog *)sharedLog {
    static DDLog *sharedLog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLog = [[DDLog alloc] init];
        [sharedLog addLogger:[DDTTYLogger sharedInstance]];
    });
    return sharedLog;
}

@end
