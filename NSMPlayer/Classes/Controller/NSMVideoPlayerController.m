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
        [_videoPlayer setAutoPlay:YES];
    }
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _videoPlayer = [[NSMVideoPlayer alloc] initWithPlayerType:NSMVideoPlayerAVPlayer];
        [_videoPlayer setAutoPlay:YES];
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
    [playerView setPlayer:self.videoPlayer.player];
}

- (void)setAssetURL:(NSURL *)assetURL {
    NSMVideoPlayerControllerDataSource *playerSource = [[NSMVideoPlayerControllerDataSource alloc] init];
    playerSource.assetURL = assetURL;
    [self.videoPlayer setPlayerSource:playerSource];
    _assetURL = assetURL;
}
@end
