//
//  NSMPlayerLogging.m
//  Pods
//
//  Created by chengqihan on 2017/2/20.
//
//

#import "NSMPlayerLogging.h"

@implementation NSMPlayerLogging

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
