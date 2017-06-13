// NSMVideoPlayerViewController.m
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

#import "NSMVideoPlayerViewController.h"
@import NSMPlayer;
@import Bolts;

@interface NSMVideoPlayerViewController ()

@property (nonatomic, strong) NSMVideoPlayerController *playerController;
@property (nonatomic, getter=isSrubbing) BOOL srubbing;

@end

@implementation NSMVideoPlayerViewController

#pragma mark - Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self configureDefaults];
    }
    return self;
}

- (void)configureDefaults {
    NSMVideoPlayerController *playerController = [[NSMVideoPlayerController alloc] init];
    self.playerController = playerController;
    playerController.videoPlayer.allowWWAN = NO;
    [playerController.videoPlayer.playbackProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(totalUnitCount)) options:0 context:nil];
    [playerController.videoPlayer.playbackProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount)) options:0 context:nil];
    [playerController.videoPlayer.bufferProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount)) options:0 context:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.accessoryView.sliderView addTarget:self action:@selector(beginSrubbing:) forControlEvents:UIControlEventTouchDown];
    [self.accessoryView.sliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.accessoryView.sliderView addTarget:self action:@selector(endSrubbing:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    
    [self.accessoryView.startOrPauseButton addTarget:self action:@selector(startOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [self.playerController.videoPlayer.playbackProgress removeObserver:self forKeyPath:NSStringFromSelector(@selector(totalUnitCount))];
    [self.playerController.videoPlayer.playbackProgress removeObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount))];
    [self.playerController.videoPlayer.bufferProgress removeObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount))];
    [self.playerController.videoPlayer releasePlayer];
    //NSLog(@"MFVideoPlayerViewController  dealloc");
}

#pragma mark - Actions

- (void)beginSrubbing:(UISlider *)sender {
    self.srubbing = YES;
}

- (void)sliderValueChange:(UISlider *)sender {
    NSTimeInterval currentTime = sender.value;
    NSInteger currentMinutes = (int)trunc(currentTime / 60);
    
    NSTimeInterval totalTime = self.playerController.videoPlayer.playbackProgress.totalUnitCount;
    NSInteger totalMinutes = (int)trunc(totalTime / 60);
    self.accessoryView.progressLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld", (long)currentMinutes, (long)((int)trunc(currentTime) - currentMinutes * 60), (long)totalMinutes, (long)((int)trunc(totalTime) - totalMinutes * 60)];
}

- (void)endSrubbing:(UISlider *)sender {
    
    [[self.playerController.videoPlayer seekToTime:sender.value] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull t) {
        self.srubbing = NO;
        return nil;
    }];
}

- (void)startOrPauseAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [self.playerController.videoPlayer pause];
    } else {
        if (self.playerController.videoPlayer.currentStatus == NSMVideoPlayerStatusPlayToEndTime) {
            [self.playerController.videoPlayer seekToTime:0];
            [self.playerController.videoPlayer play];
        } else {
            [self.playerController.videoPlayer play];
        }
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //playbackProgress
    if (object == self.playerController.videoPlayer.playbackProgress) {
        NSProgress *playbackProgress = (NSProgress *)object;
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(totalUnitCount))]) {
            NSTimeInterval douration = playbackProgress.totalUnitCount;
            NSInteger wholeMinutes = (int)trunc(douration / 60);
            self.accessoryView.progressLabel.text = [NSString stringWithFormat:@"00:00/%02ld:%02ld", (long)wholeMinutes, (long)((int)trunc(douration) - wholeMinutes * 60)];
            self.accessoryView.sliderView.maximumValue = playbackProgress.totalUnitCount;
            
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(completedUnitCount))]) {
            if (!self.isSrubbing) {
                NSTimeInterval currentTime = playbackProgress.completedUnitCount;
                NSInteger currentMinutes = (int)trunc(currentTime / 60);
                NSTimeInterval totalTime = playbackProgress.totalUnitCount;
                NSInteger totalMinutes = (int)trunc(totalTime / 60);
                self.accessoryView.progressLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld", (long)currentMinutes, (long)((int)trunc(currentTime) - currentMinutes * 60), (long)totalMinutes, (long)((int)trunc(totalTime) - totalMinutes * 60)];
                self.accessoryView.sliderView.value = playbackProgress.completedUnitCount;
            }
        }
    } else {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(completedUnitCount))]) {
            NSProgress *bufferProgress = (NSProgress *)object;
            self.accessoryView.progressView.progress = bufferProgress.fractionCompleted;
        }
    }
}
@end
