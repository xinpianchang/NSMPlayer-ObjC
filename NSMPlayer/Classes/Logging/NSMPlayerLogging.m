//
//  NSMStateMachineLogging.m
//  Pods
//
//  Created by chengqihan on 2017/2/14.
//
//

#import "NSMPlayerLogging.h"

@implementation NSMPlayerLogging

+ (void)load {
    DDTTYLogger *logger = [DDTTYLogger sharedInstance];
    [DDLog addLogger:logger];
}

@end
