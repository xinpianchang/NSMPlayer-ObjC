//
//  NSMVideoPlayerController.m
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import "NSMVideoPlayerController.h"
#import "NSMAVPlayerView.h"
#import "NSMVideoPlayer.h"
#import <Masonry/Masonry.h>

@interface NSMVideoPlayerController ()


@end

@implementation NSMVideoPlayerController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _videoPlayer = [[NSMVideoPlayer alloc] initWithPlayerType:NSMVideoPlayerAVPlayer];
    }
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _videoPlayer = [[NSMVideoPlayer alloc] initWithPlayerType:NSMVideoPlayerAVPlayer];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    
    NSMAVPlayerView *playerView = [[NSMAVPlayerView alloc] init];
    [self.view addSubview:playerView];
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.videoPlayer setVideoPlayerRenderView:playerView];
}


@end
