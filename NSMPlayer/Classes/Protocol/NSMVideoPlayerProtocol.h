//
//  NSMVideoPlayerProtocol.h
//  Pods
//
//  Created by chengqihan on 2017/2/20.
//
//

#import "NSMPlayerProtocol.h"

@class NSMPlayerRestoration;

@protocol NSMVideoPlayerProtocol <NSMPlayerProtocol>

- (void)restorePlayerWithConfig:(NSMPlayerRestoration *)config;
- (NSMPlayerRestoration *)savePlayerState;
//- (void)setPlayerView:(UIView *)playerView;

@end
