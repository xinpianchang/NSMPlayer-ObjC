// NSMUnderlyingPlayer.m
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

#import "NSMUnderlyingPlayer.h"
#import "NSMPlayerAsset.h"

NSString * const NSMUnderlyingPlayerErrorDomain = @"NSMUnderlyingPlayerErrorDomain";

 NSString *const NSMUnderlyingPlayerDidPlayToEndTimeNotification = @"NSMUnderlyingPlayerDidPlayToEndTimeNotification";

NSString *const NSMUnderlyingPlayerFailedNotification = @"NSMUnderlyingPlayerFailedNotification";

 NSString *const NSMUnderlyingPlayerLoadedTimeRangesDidChangeNotification = @"NSMUnderlyingPlayerLoadedTimeRangesDidChangeNotification";

NSString *const NSMUnderlyingPlayerPlaybackBufferEmptyNotification = @"NSMUnderlyingPlayerPlaybackBufferEmptyNotification";

NSString *const NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification = @"NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification";

NSString *const NSMUnderlyingPlayerPlaybackStallingNotification = @"NSMUnderlyingPlayerPlaybackStallingNotification";

//NSString *const NSMUnderlyingPlayerPlaybackResignStallingNotification = @"NSMUnderlyingPlayerPlaybackResignStallingNotification";

//NSString *const NSMUnderlyingPlayerPlayheadDidChangeNotification = @"NSMUnderlyingPlayerPlayheadDidChangeNotification";

//NSString *const NSMUnderlyingPlayerPeriodicPlayTimeChangeKey = @"NSMUnderlyingPlayerPeriodicPlayTimeChangeKey";

NSString *const NSMUnderlyingPlayerErrorKey = @"NSMUnderlyingPlayerErrorKey";

//NSString *const NSMUnderlyingPlayerLoadedTimeRangesKey = @"NSMUnderlyingPlayerErrorKey";

//NSString *const NSMUnderlyingPlayerPlaybackLikelyToKeepUpKey = @"NSMUnderlyingPlayerPlaybackLikelyToKeepUpKey";

//NSString *const NSMUnderlyingPlayerPlaybackBufferEmptyKey = @"NSMUnderlyingPlayerPlaybackBufferEmptyKey";

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wprotocol"
//
//
//@implementation NSMUnderlyingPlayer
//
//@dynamic currentStatus, currentAsset, loopPlayback, autoPlay, preload, muted, volume, allowWWAN, playerType, playerView;
//
//#pragma clang diagnostic pop
//
//@end
