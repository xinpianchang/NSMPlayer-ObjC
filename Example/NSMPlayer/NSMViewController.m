//
//  NSMViewController.m
//  NSMPlayer
//
//  Created by migrant on 02/10/2017.
//  Copyright (c) 2017 migrant. All rights reserved.
//

#import "NSMViewController.h"
#import <NSMPlayer/NSMVideoPlayerController.h>
#import <Masonry/Masonry.h>
#import "NSMVideoSourceController.h"
#import "NSMPlayerAsset.h"
#import "NSMVideoPlayer.h"
#import "NSMPlayerLogging.h"

@interface NSMViewController () <NSMVideoSourceControllerDelegate>

@property (nonatomic, strong) NSMVideoPlayerController *playerController;
@property (weak, nonatomic) IBOutlet UILabel *playerStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerTypeLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumSlider;
@property (weak, nonatomic) IBOutlet UISlider *playHeadSlider;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgress;
@property (nonatomic, strong) NSMPlayerRestoration *saveConfig;

@end

@implementation NSMViewController

- (IBAction)chooseSource:(UIBarButtonItem *)sender {
    NSMVideoSourceController *meauVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"source"];
    meauVC.delegate = self;
    meauVC.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *detailPopover = meauVC.popoverPresentationController;
    detailPopover.barButtonItem = sender;
    detailPopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:meauVC animated:YES completion:nil];
}

- (IBAction)allowMobileNetworkChange:(UISwitch *)sender {
    [self.playerController.videoPlayer setAllowWWAN:sender.isOn];
}

- (IBAction)ciclePlayChange:(UISwitch *)sender {
    [self.playerController.videoPlayer setLoopPlayback:sender.isOn];
}

- (IBAction)mutedChange:(UISwitch *)sender {
    [self.playerController.videoPlayer setMuted:sender.isOn];
}


- (IBAction)volumChange:(UISlider *)sender {
    [self.playerController.videoPlayer setVolume:sender.value];
}
- (IBAction)play:(UIButton *)sender {
    [self.playerController.videoPlayer play];
}

- (IBAction)pause:(UIButton *)sender {
    [self.playerController.videoPlayer pause];
}


- (IBAction)releasePlayer:(UIButton *)sender {
    NSMPlayerRestoration *saveConfig = [self.playerController.videoPlayer savePlayerState];
    self.saveConfig = saveConfig;
    [self.playerController.videoPlayer releasePlayer];
}

- (IBAction)restore:(UIButton *)sender {
    [self.playerController.videoPlayer restorePlayerWithConfig:self.saveConfig];
}

- (IBAction)playHeaderChange:(UISlider *)sender {
    [self.playerController.videoPlayer seekToTime:sender.value * 200];
}

- (IBAction)playerTypeChange:(UISwitch *)sender {
    if (sender.isOn) {
        self.playerController.videoPlayer.playerType = NSMVideoPlayerAVPlayer;
    } else {
        NSLog(@"IJKPlayer还没有添加");
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //should add observer before initilize NSMVideoPlayerController object
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerStatusDidChange) name:NSMVideoPlayerStatusDidChange object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadProgress.progress = 0.5;
}

- (void)videoPlayerStatusDidChange {
    self.playerStateLabel.text = NSMVideoPlayerStatusDescription(self.playerController.videoPlayer.currentStatus);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"videoPlayer"]) {
        NSMVideoPlayerController *playerController = segue.destinationViewController;
        if ([playerController isKindOfClass:[NSMVideoPlayerController class]]) {
            NSMPlayerAsset *playerAsset = [[NSMPlayerAsset alloc] init];
            playerAsset.assetURL = [NSURL URLWithString:@"http://qiniu.vmagic.vmoviercdn.com/57aad69c25a41_lower.mp4"];
            [playerController.videoPlayer setPlayerAsset:playerAsset];
            self.playerController = playerController;
        }
    }
}

#pragma mark - NSMVideoSourceControllerDelegate

- (void)videoSourceControllerDidSelectedPlayerItem:(NSMPlayerAsset *)playerAsset {
    [self.playerController.videoPlayer setPlayerAsset:playerAsset];
}

@end
