//
//  NSMAVPlayerView.h
//  Pods
//
//  Created by chengqihan on 2017/2/10.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NSMAVPlayerView : UIView

- (AVPlayer *)player;
- (void)setPlayer:(AVPlayer *)player;
- (AVPlayerLayer *)playerLayer;

@end
