// NSMVideoTableViewController.m
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

#import "NSMVideoTableViewController.h"
#import "NSMVideoTableViewCell.h"
#import "NSMDisplayVideoViewController.h"

@import NSMPlayer;

@interface NSMVideoObject : NSObject

@property (nonatomic, strong) NSMPlayerRestoration *restoration;
@property (nonatomic, getter=isActive) BOOL active;

@end

@implementation NSMVideoObject


@end

@interface NSMVideoTableViewController () <NSMDisplayVideoViewControllerDelegate>

@property (nonatomic, strong) NSMVideoPlayerController *playerController;
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, strong) NSIndexPath *activeIndexPath;

@end

@implementation NSMVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[NSMVideoTableViewCell class] forCellReuseIdentifier:@"cell2"];

    NSMVideoObject *object1 = [NSMVideoObject new];
    NSMPlayerRestoration *restoration1 = [[NSMPlayerRestoration alloc] init];
    NSMPlayerAsset *asset1 = [[NSMPlayerAsset alloc] init];
    asset1.assetURL = [NSURL URLWithString:@"http://qiniu.vmovier.molihecdn.com/5783402ed3469_lower.mp4"];
    restoration1.playerAsset = asset1;
    object1.restoration = restoration1;
    
    NSMVideoObject *object2 = [NSMVideoObject new];
    NSMPlayerRestoration *restoration2 = [[NSMPlayerRestoration alloc] init];
    NSMPlayerAsset *asset2 = [[NSMPlayerAsset alloc] init];
    asset2.assetURL = [NSURL URLWithString:@"http://qiniu.vmovier.molihecdn.com/5720929e7600d.mp4"];
    restoration2.playerAsset = asset2;
    object2.restoration = restoration2;
    
    NSMVideoObject *object3 = [NSMVideoObject new];
    NSMPlayerRestoration *restoration3 = [[NSMPlayerRestoration alloc] init];
    NSMPlayerAsset *asset3 = [[NSMPlayerAsset alloc] init];
    asset3.assetURL = [NSURL URLWithString:@"http://bbd.qiniu.vmovier.vmoiver.com//57946a902e4c2_lower.mp4"];
    restoration3.playerAsset = asset3;
    object3.restoration = restoration3;
    
    
    NSMVideoObject *object4 = [NSMVideoObject new];
    NSMPlayerRestoration *restoration4 = [[NSMPlayerRestoration alloc] init];
    NSMPlayerAsset *asset4 = [[NSMPlayerAsset alloc] init];
    asset4.assetURL = [NSURL URLWithString:@"http://qiniu.vmovier.molihecdn.com/5783402ed3469_lower.mp4"];
    restoration4.playerAsset = asset4;
    object4.restoration = restoration4;
    
    
    NSMVideoObject *object5 = [NSMVideoObject new];
    NSMPlayerRestoration *restoration5 = [[NSMPlayerRestoration alloc] init];
    restoration5.restoredStatus = NSMVideoPlayerStatusPlaying;
    NSMPlayerAsset *asset5 = [[NSMPlayerAsset alloc] init];
    asset5.assetURL = [NSURL URLWithString:@"http://qiniu.vmovier.molihecdn.com/5720929e7600d.mp4"];
    restoration5.playerAsset = asset5;
    object5.restoration = restoration5;
    
    NSMVideoObject *object6 = [NSMVideoObject new];
    NSMPlayerRestoration *restoration6 = [[NSMPlayerRestoration alloc] init];
    restoration6.restoredStatus = NSMVideoPlayerStatusPlaying;
    NSMPlayerAsset *asset6 = [[NSMPlayerAsset alloc] init];
    asset6.assetURL = [NSURL URLWithString:@"http://bbd.qiniu.vmovier.vmoiver.com//57946a902e4c2_lower.mp4"];
    restoration6.playerAsset = asset6;
    object6.restoration = restoration6;
    
    self.videos = [NSMutableArray arrayWithObjects:object1, object2, object3, object4, object5, object6, nil];
    
    [self setupPlayerController];
}

- (void)setupPlayerController {
    NSMVideoPlayerController *playerController = [[NSMVideoPlayerController alloc] init];
    self.playerController = playerController;
    //        [playerController.videoPlayer.playbackProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(totalUnitCount)) options:0 context:nil];
    //        [playerController.videoPlayer.playbackProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount)) options:0 context:nil];
    //        [playerController.videoPlayer.bufferProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount)) options:0 context:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    [cell.playerAccessoryView.zoomInOutButton addTarget:self action:@selector(zoomInAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.playerAccessoryView.startOrPauseButton addTarget:self action:@selector(startOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.postView addTarget:self action:@selector(restorePlayer:) forControlEvents:UIControlEventTouchUpInside];
    NSMVideoObject *object = self.videos[indexPath.row];
    cell.postView.hidden = object.isActive;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    NSLog(@"%s section:%zd, row:%zd", __func__, indexPath.section, indexPath.row);
    NSMVideoObject *videoObject = self.videos[indexPath.row];
    if (videoObject.isActive) {
        videoObject.active = NO;
        videoObject.restoration = [self.playerController.videoPlayer savePlayerState];
        self.videos[indexPath.row] = videoObject;
        ((NSMVideoTableViewCell *)cell).playerView.playerLayer.player = nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s section:%zd, row:%zd", __func__, indexPath.section, indexPath.row);
}

#pragma mark - NSMDisplayVideoViewControllerDelegate

- (void)displayVideoViewControllerDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.activeIndexPath];
    [self.playerController.videoPlayer setPlayerView:cell.playerView];
}

#pragma mark - Actions

- (void)zoomInAction:(UIView *)sender {
    
    while (![sender isMemberOfClass:[NSMVideoTableViewCell class]]) {
        sender = sender.superview;
    }
    
    if ([sender isMemberOfClass:[NSMVideoTableViewCell class]]) {
        NSMVideoTableViewCell *cell = (NSMVideoTableViewCell *)sender;
        cell.playerView.playerLayer.player = nil;

        NSMDisplayVideoViewController *vc = [[NSMDisplayVideoViewController alloc] initWithVideoPlayer:self.playerController];
        vc.delegate = self;
        [self presentViewController:vc animated:NO completion:nil];
        
    }
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

- (void)restorePlayer:(UIView *)sender {
    sender.hidden = YES;
    
    while (![sender isMemberOfClass:[NSMVideoTableViewCell class]]) {
        sender = sender.superview;
    }
    
    if ([sender isMemberOfClass:[NSMVideoTableViewCell class]]) {
        NSMVideoTableViewCell *cell = (NSMVideoTableViewCell *)sender;
        
        if (self.activeIndexPath) {
            if([[self.tableView indexPathsForVisibleRows] containsObject:self.activeIndexPath]) {
                NSMVideoObject *videoObject = self.videos[self.activeIndexPath.row];
                if (videoObject.isActive) {
                    videoObject.active = NO;
                    NSMPlayerRestoration *savedRestoration = [self.playerController.videoPlayer savePlayerState];
                    videoObject.restoration = savedRestoration;
                    self.videos[self.activeIndexPath.row] = videoObject;
                    cell.playerView.playerLayer.player = nil;
                    [self.tableView reloadRowsAtIndexPaths:@[self.activeIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSLog(@"section:%zd, row:%zd", indexPath.section, indexPath.row);
        NSMVideoObject *videoObject = self.videos[indexPath.row];
        videoObject.active = YES;
        [self.playerController.videoPlayer replaceCurrentAssetWithAsset:videoObject.restoration.playerAsset];
        [self.playerController.videoPlayer seekToTime:videoObject.restoration.seekTime];
        [self.playerController.videoPlayer setPlayerView:cell.playerView];
        self.activeIndexPath = indexPath;
    }
}

@end
