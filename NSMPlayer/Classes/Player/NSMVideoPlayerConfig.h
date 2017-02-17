//
//  NSMVideoPlayerConfig.h
//  Pods
//
//  Created by chengqihan on 2017/2/16.
//
//

#import <Foundation/Foundation.h>
#import "NSMVideoPlayerController.h"

@protocol NSMVideoPlayerProtocol;

@class NSMVideoPlayerControllerDataSource;

@interface NSMVideoPlayerConfig : NSObject

+ (instancetype)videoPlayerConfig;

@property (assign, nonatomic, getter=isAllowWWAN) BOOL allowWWAN;

@property (assign, nonatomic, getter=isLoopPlayback) BOOL loopPlayback;

@property (assign, nonatomic, getter=isAutoPlay) BOOL autoPlay;

@property (assign, nonatomic, getter=isPreload) BOOL preload;

@property (assign, nonatomic, getter=isMuted) BOOL muted;

@property (nonatomic, strong) NSMVideoPlayerControllerDataSource *playerSource;

@property (nonatomic, assign) NSMVideoPlayerType playerType;

@property (nonatomic, strong) NSError *playerError;

@property (nonatomic, assign) NSMVideoPlayerStatus restoredStatus;

@property (assign, nonatomic, getter=isRestoring) BOOL restoring;

@end
