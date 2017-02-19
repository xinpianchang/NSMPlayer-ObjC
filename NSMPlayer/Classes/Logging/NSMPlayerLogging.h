
//
//  NSMStateMachineLogging.h
//  Pods
//
//  Created by chengqihan on 2017/2/14.
//
//

@import CocoaLumberjack;

static const DDLogLevel NSMPlayerLogLevel = DDLogLevelVerbose;

#ifndef NSMPlayerLogging_h
#define NSMPlayerLogging_h

#undef LOG_LEVEL_DEF // Undefine first only if needed
#define LOG_LEVEL_DEF NSMPlayerLogLevel

#define LOG_PREFIX @"[NSMPlayer]"

#define NSM_PLAYER_LOG_CONTEXT 1025

#define NSMPlayerLogError(frmt, ...)   LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)
#define NSMPlayerLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)
#define NSMPlayerLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)
#define NSMPlayerLogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)
#define NSMPlayerLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX frmt, ##__VA_ARGS__)

#endif /* NSMPlayerLogging_h */

