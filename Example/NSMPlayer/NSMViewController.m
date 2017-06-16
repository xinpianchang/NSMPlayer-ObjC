// NSMViewController.m
//
// Copyright (c) 2017 NSMPlayer
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

@import Bolts;
@import NSMPlayer;
@import MediaPlayer;

#import "NSMViewController.h"
#import "NSMVideoSourceController.h"
#import "NSMVideoPlayerViewController.h"

@interface NSMViewController () <NSMVideoSourceControllerDelegate>

@property (nonatomic, strong) NSMVideoPlayerViewController *playerViewController;
@property (weak, nonatomic) IBOutlet UILabel *failReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerTypeLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumSlider;
@property (nonatomic, strong) NSMPlayerRestoration *saveConfig;
@property (nonatomic, strong) UISlider *volumSliderView;
@property (nonatomic, assign) BOOL allowWWAN;

@end

@implementation NSMViewController

#pragma mark - Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureDefaults];
    }
    return self;
}

- (void)configureDefaults {
    //should add observer before initilize NSMVideoPlayerController object
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerStatusDidChange:) name:NSMVideoPlayerStatusDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:NSStringFromSelector(@selector(outputVolume)) options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Build:#%@",[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
    self.volumSlider.value = [AVAudioSession sharedInstance].outputVolume;
    [self setupVolumeView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"videoPlayer"]) {
        NSMVideoPlayerViewController *playerViewController = segue.destinationViewController;
        if ([playerViewController isKindOfClass:[NSMVideoPlayerViewController class]]) {
            self.playerViewController = playerViewController;
            NSMPlayerAsset *playerAsset = [[NSMPlayerAsset alloc] init];
            playerAsset.assetURL = [NSURL URLWithString:@"http://vjs.zencdn.net/v/oceans.mp4"];
            [self.playerViewController.playerController.videoPlayer replaceCurrentAssetWithAsset:playerAsset];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (void)setupVolumeView {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    [volumeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UISlider class]]){
            _volumSliderView = obj;
        }
    }];
}

- (IBAction)retry:(UIButton *)sender {
    if (NSMVideoPlayerStatusFailed == [self.playerViewController.playerController.videoPlayer currentStatus]) {
        NSMPlayerError *playerError = [self.playerViewController.playerController.videoPlayer playerError];
        if (playerError != nil) {
            NSMPlayerRestoration *restoration = playerError.restoration;
            [self.playerViewController.playerController.videoPlayer restorePlayerWithRestoration:restoration];
        }
    }
}

- (IBAction)chooseSource:(UIButton *)sender {
    NSMVideoSourceController *meauVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"source"];
    meauVC.delegate = self;
    [self presentViewController:meauVC animated:YES completion:nil];
}

- (IBAction)allowMobileNetworkChange:(UISwitch *)sender {
    self.allowWWAN = sender.isOn;
    if (NSMVideoPlayerStatusFailed == [self.playerViewController.playerController.videoPlayer currentStatus]) {
        NSMPlayerError *playerError = [self.playerViewController.playerController.videoPlayer playerError];
        if (playerError != nil) {
            NSMPlayerRestoration *restoration = playerError.restoration;
            restoration.allowWWAN = sender.isOn;
            [self.playerViewController.playerController.videoPlayer restorePlayerWithRestoration:restoration];
        }
    } else {
        [self.playerViewController.playerController.videoPlayer setAllowWWAN:sender.isOn];
    }
}

- (IBAction)ciclePlayChange:(UISwitch *)sender {
    [self.playerViewController.playerController.videoPlayer setLoopPlayback:sender.isOn];
}

- (IBAction)mutedChange:(UISwitch *)sender {
    [self.playerViewController.playerController.videoPlayer setMuted:sender.isOn];
}

- (IBAction)volumChange:(UISlider *)sender {
    [self.playerViewController.playerController.videoPlayer setVolume:sender.value];
    self.volumSliderView.value = sender.value;
}

- (IBAction)play:(UIButton *)sender {
    [self.playerViewController.playerController.videoPlayer play];
}

- (IBAction)pause:(UIButton *)sender {
    
    [self.playerViewController.playerController.videoPlayer pause];
}

- (IBAction)releasePlayer:(UIButton *)sender {
    if (self.playerViewController.playerController.videoPlayer.currentStatus != NSMVideoPlayerStatusIdle) {
        NSMPlayerRestoration *saveConfig = [self.playerViewController.playerController.videoPlayer savePlayerState];
        self.saveConfig = saveConfig;
    }
    [self.playerViewController.playerController.videoPlayer releasePlayer];
    NSLog(@"releasePlayer");
}

- (IBAction)restore:(UIButton *)sender {
    self.saveConfig.allowWWAN = self.allowWWAN;
    [self.playerViewController.playerController.videoPlayer restorePlayerWithRestoration:self.saveConfig];
    NSLog(@"restore");
}

- (IBAction)separate:(UISwitch *)sender {
    ((NSMAVPlayerView *)self.playerViewController.playerController.videoPlayer.playerView).hidden = sender.isOn;
}

- (IBAction)playerTypeChange:(UISwitch *)sender {
    if (sender.isOn) {
        self.playerViewController.playerController.videoPlayer.playerType = NSMVideoPlayerAVPlayer;
    } else {
        NSLog(@"IJKPlayer还没有添加");
        self.playerViewController.playerController.videoPlayer.playerType = NSMVideoPlayerIJKPlayer;
    }
}

- (IBAction)accessoryShowOrHide:(UISwitch *)sender {
    if (sender.isOn) {
        [self.playerViewController.accessoryView show:YES];
    } else {
        [self.playerViewController.accessoryView hide:YES];
    }
}

#pragma mark - NSNotificationCenter

- (void)applicationDidBecomeActiveNotification {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.volumSlider.value = [AVAudioSession sharedInstance].outputVolume;
}

- (void)videoPlayerStatusDidChange:(NSNotification *)notification {
    
    if (self.playerViewController.playerController.videoPlayer.currentStatus == NSMVideoPlayerStatusFailed) {
        self.failReasonLabel.text = [self.playerViewController.playerController.videoPlayer.playerError.error localizedDescription];
    } else {
        self.failReasonLabel.text = @"";
    }
    
    self.playerStateLabel.text = NSMVideoPlayerStatusDescription(self.playerViewController.playerController.videoPlayer.currentStatus);
}

#pragma mark - NSMVideoSourceControllerDelegate

- (void)videoSourceControllerDidSelectedPlayerItem:(NSMPlayerAsset *)playerAsset {
    [self.playerViewController.playerController.videoPlayer replaceCurrentAssetWithAsset:playerAsset];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"outputVolume"]) {
        self.volumSlider.value = [AVAudioSession sharedInstance].outputVolume;
    }
}

@end
