//
//  NSMStateMachineLogging.m
//  Pods
//
//  Created by chengqihan on 2017/2/14.
//
//

#import "NSMStateMachineLogging.h"

@implementation NSMStateMachineLogging

+ (void)load {
    DDTTYLogger *logger = [DDTTYLogger sharedInstance];
    [DDLog addLogger:logger];
}

@end
