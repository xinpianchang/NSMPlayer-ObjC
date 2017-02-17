//
//  NSMAVPlayerView.h
//  Pods
//
//  Created by chengqihan on 2017/2/10.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol NSMVideoPlayerViewProtocol <NSObject>

- (void)setPlayer:(id)player;
- (id)player;

@end

@interface NSMAVPlayerView : UIView <NSMVideoPlayerViewProtocol>

@end

