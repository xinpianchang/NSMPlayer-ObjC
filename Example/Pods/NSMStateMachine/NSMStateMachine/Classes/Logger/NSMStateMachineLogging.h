
//
//  NSMStateMachineLogging.h
//  Pods
//
//  Created by chengqihan on 2017/2/14.
//
//

@import CocoaLumberjack;

#ifdef DEBUG
static const DDLogLevel SMLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel SMLogLevel = DDLogLevelWarning;
#endif

#ifndef NSMStateMachineLogging_h
#define NSMStateMachineLogging_h

#undef LOG_LEVEL_DEF // Undefine first only if needed
#define LOG_LEVEL_DEF SMLogLevel

#define LOG_PREFIX @"[NSMStateMachine]"

#define NSM_STATE_MACHINE_LOG_CONTEXT 1024

#define NSM_STATE_MACHINE_LOG [NSMStateMachineLogging sharedLog]

#define NSMSMLogError(frmt, ...)   LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, NO,                LOG_LEVEL_DEF, DDLogFlagError,   NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)
#define NSMSMLogWarn(frmt, ...)    LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)
#define NSMSMLogInfo(frmt, ...)    LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)
#define NSMSMLogDebug(frmt, ...)   LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)
#define NSMSMLogVerbose(frmt, ...) LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)



#endif /* NSMStateMachineLogging_h */

@interface NSMStateMachineLogging : NSObject

+ (DDLog *)sharedLog;

@end
