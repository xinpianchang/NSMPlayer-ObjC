//
//  NSMAVPlayer.m
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//

#import "NSMAVPlayer.h"
#import <Bolts/Bolts.h>
#import "NSMVideoAssetInfo.h"
#import "NSMAVPlayerView.h"
#import "NSMPlayerProtocol.h"

@interface NSMAVPlayer ()

@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) id timeObserverToken;
@property (nonatomic, strong) BFTaskCompletionSource *prepareSouce;

@end

@implementation NSMAVPlayer

// MARK: - Properties

- (AVPlayer *)avplayer {
    if (!_avplayer) {
        _avplayer = [[AVPlayer alloc] init];
    }
    return _avplayer;
}

// Will attempt load and test these asset keys before playing
+ (NSArray *)assetKeysRequiredToPlay {
    return @[@"tracks", @"playable", @"hasProtectedContent"];
}

/**
 Preparing an Asset for Use
 If you want to prepare an asset for playback, you should load its tracks property
 */
- (BFTask *)prepare {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.playerURL options:nil];
    self.asset = asset;
    return [self asynchronouslyLoadURLAsset:asset];
}


// MARK: - Asset Loading

- (BFTask *)asynchronouslyLoadURLAsset:(AVURLAsset *)newAsset {
    BFTaskCompletionSource *source = [BFTaskCompletionSource taskCompletionSource];
    self.prepareSouce = source;
    /*
     Using AVAsset now runs the risk of blocking the current thread
     (the main UI thread) whilst I/O happens to populate the
     properties. It's prudent to defer our work until the properties
     we need have been loaded.
     */
    [newAsset loadValuesAsynchronouslyForKeys:self.class.assetKeysRequiredToPlay completionHandler:^{
        
        /*
         The asset invokes its completion handler on an arbitrary queue.
         To avoid multiple threads using our internal state at the same time
         we'll elect to use the main thread at all times, let's dispatch
         our handler to the main queue.
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (newAsset != self.asset) {
                /*
                 self.asset has already changed! No point continuing because
                 another newAsset will come along in a moment.
                 */
                [source setError:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"asset has already changed"}]];
                return;
            }
            
            /*
             Test whether the values of each of the keys we need have been
             successfully loaded.
             */
            for (NSString *key in self.class.assetKeysRequiredToPlay) {
                NSError *error = nil;
                AVKeyValueStatus status = [newAsset statusOfValueForKey:key error:&error];
                if (status == AVKeyValueStatusFailed) {
                    [source setError:error];
                    return;
                }
            }
            
            // We can't play this asset.
            if (!newAsset.playable || newAsset.hasProtectedContent) {
                [source setError:[NSError errorWithDomain:NSMUnderlyingPlayerErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : @"Can't use this AVAsset because it isn't playable or has protected content"}]];
                return;
            }
            
            /*
             We can play this asset. Create a new AVPlayerItem and make it
             our player's current item.
             */
            [self setupAVPlayerWithAsset:newAsset];
            
        });
    }];
    return source.task;
}

- (void)setupAVPlayerWithAsset:(AVAsset *)asset {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    // ensure that this is done before the playerItem is associated with the player
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionInitial context:nil];
    
    //waitingBufferToPlay
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionInitial context:nil];
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionInitial context:nil];
    
    //playToEndTime
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];

    [self removeTimeObserverToken];
    [self removeCurrentItemObserver];
    
    [self.avplayer replaceCurrentItemWithPlayerItem:playerItem];
    
//    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    // Invoke callback every half second
    //    __weak __typeof(self) weakself = self;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.timeObserverToken = [self.avplayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC) queue:mainQueue usingBlock:^(CMTime time) {
        NSTimeInterval currenTimeInterval = CMTimeGetSeconds(time);
        NSLog(@"currenTimeInterval : %.2f",currenTimeInterval);
    }];
}


// MARK: - NSMUnderlyingPlayerProtocol

- (void)play {
    [self.avplayer play];
}

- (void)pause {
    [self.avplayer pause];
}

- (void)seekToTime:(NSTimeInterval)seconds {
    CMTime time = CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
    [self.avplayer seekToTime:time];
}

- (void)releasePlayer {
    [self removeCurrentItemObserver];
    [self removeTimeObserverToken];
    self.avplayer = nil;
}

- (void)adjustVolume:(CGFloat)volum {
    self.avplayer.volume = volum;
}

- (void)switchMuted:(BOOL)on {
    self.avplayer.muted = on;
}

- (void)adjustRate:(CGFloat)rate {
    self.avplayer.rate = rate;
}


// MARK: - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        //POST
        if (self.avplayer.currentItem.status == AVPlayerItemStatusReadyToPlay){
            //Prepared finish
            if (self.prepareSouce && !self.prepareSouce.task.isCompleted) {
                NSMVideoAssetInfo *assetInfo = [[NSMVideoAssetInfo alloc] init];
                assetInfo.duration = CMTimeGetSeconds(self.avplayer.currentItem.duration);
                [self.prepareSouce setResult:assetInfo];
            }
        } else {
            //If the receiver's status is AVPlayerStatusFailed, this describes the error that caused the failure
            NSLog(@"AVPlayerStatusFailed error:%@",self.avplayer.error);
            
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //The array contains NSValue objects containing a CMTimeRange value indicating the times ranges for which the player item has media data readily available. The time ranges returned may be discontinuous.
        NSArray *loadedTimeRanges = self.avplayer.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        CGFloat rangeStartSeconds = CMTimeGetSeconds(timeRange.start);
        CGFloat rangeDurationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSLog(@"rangeStartSeconds:%f rangeDurationSeconds:%f",rangeStartSeconds,rangeDurationSeconds);
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //indicates that playback has consumed all buffered media and that playback will stall or end
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        //Indicates whether the item will likely play through without stalling
    }
}

// MARK: - NSNotification

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
}

- (void)dealloc {
    [self removeTimeObserverToken];
    [self removeCurrentItemObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeTimeObserverToken {
    if (self.timeObserverToken) {
        /*
         * 只能保证调用下面方法的时候，只能保证这个方法 - (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block 中的block不会被再次触发，而不能保证已经触发的 block 中断执行，可以用这个做到 dispatch_sync(queue, ^{} 。
         */
        [self.avplayer removeTimeObserver:self.timeObserverToken];
        self.timeObserverToken = nil;
    }
}

- (void)removeCurrentItemObserver {
    if (self.avplayer.currentItem) {
        [self.avplayer.currentItem removeObserver:self forKeyPath:@"status" context:nil];
        [self.avplayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        [self.avplayer.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
        [self.avplayer.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    }
}

- (void)setPlayerRenderView:(id<NSMVideoPlayerViewProtocol>)playerRenderView {
    [playerRenderView setPlayer:self];
}

- (UIImage *)thumnailImageWithTime:(CMTime)requestTime {
    AVAsset *myAsset = self.asset;
    if ([[myAsset tracksWithMediaType:AVMediaTypeVideo] count] > 0) {
        AVAssetImageGenerator *imageGenerator =
        [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
        NSError *error;
        CMTime actualTime;
        CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
        if (halfWayImage != NULL) {
            return [UIImage imageWithCGImage:halfWayImage];
        }
    }
    return nil;
}

- (id)player {
    return self.avplayer;
}
@end
