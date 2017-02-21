//
//  NSMPlayerRestoration.h
//  Pods
//
//  Created by chengqihan on 2017/2/16.
//
//

#import <Foundation/Foundation.h>
#import "NSMVideoPlayerController.h"

@protocol NSMVideoPlayerProtocol;

@class NSMPlayerAsset;

@interface NSMPlayerRestoration : NSObject

//+ (instancetype)videoPlayerRestoration;

@property (nonatomic, assign, getter=isAllowWWAN) BOOL allowWWAN;

@property (nonatomic, assign, getter=isLoopPlayback) BOOL loopPlayback;

@property (nonatomic, assign, getter=isAutoPlay) BOOL autoPlay;

@property (nonatomic, assign, getter=isPreload) BOOL preload;

@property (nonatomic, assign, getter=isMuted) BOOL muted;

@property (nonatomic, strong) NSMPlayerAsset *playerAsset;

@property (nonatomic, assign) NSMVideoPlayerType playerType;

@property (nonatomic, strong) NSError *playerError;

@property (nonatomic, assign) NSMVideoPlayerStatus restoredStatus;

@property (nonatomic, assign, getter=isRestoring) BOOL restoring;

@property (nonatomic, assign, getter=isIntentToPlay) BOOL intentToPlay;

@property (nonatomic, assign) NSTimeInterval seekTime;

@property (nonatomic, assign) CGFloat rate;

@property (nonatomic, assign) CGFloat volume;


@end
