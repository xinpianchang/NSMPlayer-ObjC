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

//- (AVPlayer *)player {
//    return ((AVPlayerLayer *)[self layer]).player;
//}
//
//- (void)setPlayer:(AVPlayer *)avplayer {
//    ((AVPlayerLayer *)[self layer]).player = avplayer;
//}
//
//- (AVPlayerLayer *)playerLayer {
//    return (AVPlayerLayer *)self.layer;
//}

//- (void)setPlayer:(NSMUnderlyingPlayer *)player {
//    ((AVPlayerLayer *)[self layer]).player = [(NSMAVPlayer *)player player];
//}

//- (AVPlayer *)player {
//    return ((AVPlayerLayer *)[self layer]).player;
//}

- (void)setPlayer:(id)player {
    ((AVPlayerLayer *)[self layer]).player = (AVPlayer *)player;
}

- (id)player {
    return ((AVPlayerLayer *)[self layer]).player;
}

@end
