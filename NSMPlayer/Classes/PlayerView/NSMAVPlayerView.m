//
//  NSMAVPlayerView.m
//  Pods
//
//  Created by chengqihan on 2017/2/10.
//
//

#import "NSMAVPlayerView.h"
#import "NSMAVPlayer.h"

@implementation NSMAVPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setPlayer:(id)player {
    ((AVPlayerLayer *)[self layer]).player = (AVPlayer *)player;
}

@end
