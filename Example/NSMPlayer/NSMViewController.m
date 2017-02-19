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
#import "NSMVideoPlayerControllerDataSource.h"
#import "NSMVideoPlayer.h"
#import "NSMPlayerLogging.h"

@interface NSMViewController () <NSMVideoSourceControllerDelegate>

@property (nonatomic, strong) NSMVideoPlayerController *playerController;
@property (weak, nonatomic) IBOutlet UILabel *playerStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerTypeLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumSlider;
@property (weak, nonatomic) IBOutlet UISlider *playHeadSlider;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgress;

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
}

- (IBAction)ciclePlayChange:(UISwitch *)sender {
}

- (IBAction)mutedChange:(UISwitch *)sender {
}


- (IBAction)volumChange:(UISlider *)sender {
    
}
- (IBAction)play:(UIButton *)sender {
    [self.playerController.videoPlayer play];
}

- (IBAction)pause:(UIButton *)sender {
    [self.playerController.videoPlayer pause];
}


- (IBAction)retry:(UIButton *)sender {
    [self.playerController.videoPlayer retry];
}

- (IBAction)playHeaderChange:(UISlider *)sender {
    [self.playerController.videoPlayer seekToTime:sender.value * 200];
}

- (IBAction)playerTypeChange:(UISwitch *)sender {
    if (sender.isOn) {
        [self.playerController.videoPlayer choosePlayerWithType:NSMVideoPlayerAVPlayer];
    } else {
        NSMPlayerLogDebug(@"IJKPlayer还没有添加");
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
            playerController.assetURL = [NSURL URLWithString:@"http://qiniu.vmagic.vmoviercdn.com/57aad69c25a41_lower.mp4"];
            self.playerController = playerController;
        }
    }
}

#pragma mark - NSMVideoSourceControllerDelegate

- (void)videoSourceControllerDidSelectedVideoDataSource:(NSMVideoPlayerControllerDataSource *)dataSource {
    
    [self.playerController.videoPlayer setPlayerSource:dataSource];
}

@end
