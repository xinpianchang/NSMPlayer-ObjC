// NSMStateMachineLogging.h
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

#define NSMSMLogError(frmt, ...)   LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, NO,                LOG_LEVEL_DEF, DDLogFlagError,   NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"[E]" frmt, ##__VA_ARGS__)
#define NSMSMLogWarn(frmt, ...)    LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"[W]" frmt, ##__VA_ARGS__)
#define NSMSMLogInfo(frmt, ...)    LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"[I]" frmt, ##__VA_ARGS__)
#define NSMSMLogDebug(frmt, ...)   LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"[D]" frmt, ##__VA_ARGS__)
#define NSMSMLogVerbose(frmt, ...) LOG_MAYBE_TO_DDLOG(NSM_STATE_MACHINE_LOG, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, NSM_STATE_MACHINE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, LOG_PREFIX @"[V]" frmt, ##__VA_ARGS__)



#endif /* NSMStateMachineLogging_h */

@interface NSMStateMachineLogging : NSObject

+ (DDLog *)sharedLog;

+ (void)setLogEnabled:(BOOL)logEnabled;

@end
