//
//  NSMQuickSwitchViewController.m
//  NSMPlayer
//
//  Created by chengqihan on 2017/9/5.
//  Copyright © 2017年 migrant. All rights reserved.
//

#import "NSMQuickSwitchViewController.h"
@import NSMPlayer;

@interface NSMQuickSwitchViewController ()
@property (weak, nonatomic) IBOutlet NSMAVPlayerView *playerView1;
@property (weak, nonatomic) IBOutlet NSMAVPlayerView *playerView2;

@property (nonatomic, strong) NSMAVPlayerView *playerView;
@property (nonatomic, strong) NSMVideoPlayerController *videoPlayerController;
@property (nonatomic, strong) NSMutableArray<NSMPlayerRestoration*> *restorations;

@end

@implementation NSMQuickSwitchViewController

- (IBAction)view1DidTap:(UITapGestureRecognizer *)sender {
    NSMAVPlayerView *playerView = (NSMAVPlayerView *)sender.view;
    if (self.playerView != playerView) {
        if (self.playerView.playerLayer.player != nil) {
            self.playerView.playerLayer.player = nil;
        }
        [self.videoPlayerController.videoPlayer replaceCurrentAssetWithAsset:self.restorations[0].playerAsset];
        self.videoPlayerController.videoPlayer.playerView = playerView;
        self.playerView = playerView;
    }
}

- (IBAction)view2DidTap:(UITapGestureRecognizer *)sender {
    NSMAVPlayerView *playerView = (NSMAVPlayerView *)sender.view;
    if (self.playerView != playerView) {
        if (self.playerView.playerLayer.player != nil) {
            self.playerView.playerLayer.player = nil;
        }
        [self.videoPlayerController.videoPlayer replaceCurrentAssetWithAsset:self.restorations[1].playerAsset];
        self.videoPlayerController.videoPlayer.playerView = playerView;
        self.playerView = playerView;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.videoPlayerController = [[NSMVideoPlayerController alloc] init];
    NSMPlayerRestoration *restoration1 = [[NSMPlayerRestoration alloc] init];
    NSMPlayerAsset *asset1 = [[NSMPlayerAsset alloc] init];
    asset1.assetURL = [NSURL URLWithString:@"http://qiniu.vmovier.molihecdn.com/5783402ed3469_lower.mp4"];
    restoration1.playerAsset = asset1;
    self.videoPlayerController.videoPlayer.playerView = self.playerView1;
    self.playerView = self.playerView1;
    [self.videoPlayerController.videoPlayer replaceCurrentAssetWithAsset:asset1];
     
    NSMPlayerRestoration *restoration2 = [[NSMPlayerRestoration alloc] init];
    NSMPlayerAsset *asset2 = [[NSMPlayerAsset alloc] init];
    asset2.assetURL = [NSURL URLWithString:@"http://qiniu.vmovier.molihecdn.com/5720929e7600d.mp4"];
    restoration2.playerAsset = asset2;
    
    self.restorations = [NSMutableArray arrayWithObjects:restoration1, restoration2, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.videoPlayerController.videoPlayer releasePlayer];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
