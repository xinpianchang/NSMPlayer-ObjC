//
//  NSMAVPlayerView.m
//  Pods
//
//  Created by chengqihan on 2017/2/10.
//
//

#import "NSMAVPlayerView.h"

@implementation NSMAVPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return ((AVPlayerLayer *)[self layer]).player;
}

- (void)setPlayer:(AVPlayer *)avplayer {
    ((AVPlayerLayer *)[self layer]).player = avplayer;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

@end
