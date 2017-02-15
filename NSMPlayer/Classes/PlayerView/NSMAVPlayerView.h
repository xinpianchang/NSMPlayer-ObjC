//
//  NSMAVPlayerView.h
//  Pods
//
//  Created by chengqihan on 2017/2/10.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class NSMUnderlyingPlayer;

@protocol NSMVideoPlayerViewProtocol <NSObject>

@property (nonatomic, strong) NSMUnderlyingPlayer *player;

@end

@interface NSMAVPlayerView : UIView <NSMVideoPlayerViewProtocol>


@end

