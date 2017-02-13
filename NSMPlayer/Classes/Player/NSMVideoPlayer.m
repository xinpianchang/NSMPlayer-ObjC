//
//  NSMVideoPlayer.m
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import "NSMVideoPlayer.h"
#import "NSMVideoPlayerControllerDataSource.h"

@interface NSMVideoPlayer ()

@property (nonatomic, strong) NSMVideoPlayerControllerDataSource *videoPlayerDataSource;

@end

@implementation NSMVideoPlayer

- (NSMVideoPlayerControllerDataSource *)dataSource {
    return _videoPlayerDataSource;
}

- (void)setDataSource:(NSMVideoPlayerControllerDataSource *)dataSource {
    _videoPlayerDataSource = dataSource;
}

@end
