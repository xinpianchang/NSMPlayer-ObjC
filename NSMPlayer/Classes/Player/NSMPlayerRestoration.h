// NSMPlayerRestoration.h
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

#import <Foundation/Foundation.h>
#import "NSMVideoPlayerController.h"

@protocol NSMVideoPlayerProtocol;

@class NSMPlayerAsset, NSMPlayerError;

@interface NSMPlayerRestoration : NSObject

@property (nonatomic, assign, getter=isAllowWWAN) BOOL allowWWAN;

@property (nonatomic, assign, getter=isLoopPlayback) BOOL loopPlayback;

@property (nonatomic, assign, getter=isAutoPlay) BOOL autoPlay;

@property (nonatomic, assign, getter=isPreload) BOOL preload;

@property (nonatomic, assign, getter=isMuted) BOOL muted;

@property (nonatomic, strong) NSMPlayerAsset *playerAsset;

@property (nonatomic, assign) NSMVideoPlayerType playerType;

@property (nonatomic, strong) NSMPlayerError *playerError;

@property (nonatomic, assign) NSMVideoPlayerStatus restoredStatus;

@property (nonatomic, assign, getter=isIntentToPlay) BOOL intentToPlay;

@property (nonatomic, assign) NSTimeInterval seekTime;

@property (nonatomic, assign) CGFloat volume;

@end
