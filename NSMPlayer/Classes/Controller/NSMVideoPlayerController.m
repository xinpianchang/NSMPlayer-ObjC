//
//  NSMVideoPlayerController.m
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//
#import "NSMVideoPlayerController.h"
#import "NSMVideoPlayer.h"
@import MediaPlayer;

@implementation NSMVideoPlayerController

- (instancetype)init {
    self = [super init];
    if (self) {
        _videoPlayer = [[NSMVideoPlayer alloc] initWithPlayerType:NSMVideoPlayerAVPlayer];
        [_videoPlayer setAutoPlay:YES];
    }
    return self;
}

@end
