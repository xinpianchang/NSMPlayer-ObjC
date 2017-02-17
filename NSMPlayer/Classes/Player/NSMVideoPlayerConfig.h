//
//  NSMVideoPlayerConfig.h
//  Pods
//
//  Created by chengqihan on 2017/2/16.
//
//

#import <Foundation/Foundation.h>

@protocol NSMVideoPlayerProtocol;

@interface NSMVideoPlayerConfig : NSObject

+ (instancetype)videoPlayerConfig;

@property (assign, nonatomic, getter=isAllowWWAN) BOOL allowWWAN;

@property (assign, nonatomic, getter=isLoopPlayback) BOOL loopPlayback;

@property (assign, nonatomic, getter=isAutoPlay) BOOL autoPlay;

@property (assign, nonatomic, getter=isPreload) BOOL preload;

@property (assign, nonatomic, getter=isMuted) BOOL muted;


@end
