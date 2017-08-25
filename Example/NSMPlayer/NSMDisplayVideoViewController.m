//
//  NSMDisplayVideoViewController.m
//  NSMPlayer
//
//  Created by chengqihan on 2017/7/14.
//  Copyright © 2017年 migrant. All rights reserved.
//

#import "NSMDisplayVideoViewController.h"
@import NSMPlayer;

@interface NSMDisplayVideoViewController ()

@property (nonatomic, strong) NSMAVPlayerView *playerView;
@property (nonatomic, strong) NSMVideoPlayerController *playerController;

@end

@implementation NSMDisplayVideoViewController

- (instancetype)initWithVideoPlayer:(NSMVideoPlayerController *)playerController {
    if (self = [self initWithNibName:nil bundle:nil]) {
        _playerController = playerController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMAVPlayerView *playerView = [[NSMAVPlayerView alloc] init];
    self.playerView = playerView;
    [self.playerController.videoPlayer setPlayerView:playerView];
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:playerView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(playerView);
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playerView]|" options:0 metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playerView]|" options:0 metrics:nil views:views]];
    
    
    NSMPlayerAccessoryView *playerAccessoryView = [[NSMPlayerAccessoryView alloc] init];
    playerAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:playerAccessoryView];
    [playerAccessoryView.zoomInOutButton addTarget:self action:@selector(zoomOutAction:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *playerAccessoryViews = NSDictionaryOfVariableBindings(playerAccessoryView);
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playerAccessoryView]|" options:0 metrics:nil views:playerAccessoryViews]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playerAccessoryView]|" options:0 metrics:nil views:playerAccessoryViews]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeLeft) forKey:@"orientation"];
}

- (BOOL)shouldAutorotate {
    return YES;
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}

- (void)zoomOutAction:(UIButton *)sender {
    self.playerView.playerLayer.player = nil;
    if ([self.delegate respondsToSelector:@selector(displayVideoViewControllerDismiss)]) {
        [self.delegate displayVideoViewControllerDismiss];
    }
}

- (void)setAvPlayer:(AVPlayer *)avplayer {
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}

@end
