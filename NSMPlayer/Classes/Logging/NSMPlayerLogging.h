// NSMPlayerLogging.h
//
// Copyright (c) 2017 NSMPlayer
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

@import CocoaLumberjack;

#ifdef DEBUG
static const DDLogLevel NSMPlayerLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel NSMPlayerLogLevel = DDLogLevelWarning;
#endif

#ifndef NSMPlayerLogging_h
#define NSMPlayerLogging_h

#undef LOG_LEVEL_DEF // Undefine first only if needed
#define LOG_LEVEL_DEF NSMPlayerLogLevel

#define LOG_PREFIX @"[NSMPlayer]"

#define NSM_PLAYER_LOG_CONTEXT 1025

#define NSM_PLAYER_LOG_ [NSMPlayerLogging sharedLog]

#define NSMPlayerLogError(frmt, ...)   LOG_MAYBE_TO_DDLOG(NSM_PLAYER_LOG_, NO,                LOG_LEVEL_DEF, DDLogFlagError,   NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"E" frmt, ##__VA_ARGS__)
#define NSMPlayerLogWarn(frmt, ...)    LOG_MAYBE_TO_DDLOG(NSM_PLAYER_LOG_, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"W" frmt, ##__VA_ARGS__)
#define NSMPlayerLogInfo(frmt, ...)    LOG_MAYBE_TO_DDLOG(NSM_PLAYER_LOG_, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"I" frmt, ##__VA_ARGS__)
#define NSMPlayerLogDebug(frmt, ...)   LOG_MAYBE_TO_DDLOG(NSM_PLAYER_LOG_, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"D" frmt, ##__VA_ARGS__)
#define NSMPlayerLogVerbose(frmt, ...) LOG_MAYBE_TO_DDLOG(NSM_PLAYER_LOG_, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, NSM_PLAYER_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"V" frmt, ##__VA_ARGS__)

#endif /* NSMPlayerLogging_h */

@interface NSMPlayerLogging : NSObject

+ (DDLog *)sharedLog;

+ (void)setLogEnabled:(BOOL)enabled;

@end
