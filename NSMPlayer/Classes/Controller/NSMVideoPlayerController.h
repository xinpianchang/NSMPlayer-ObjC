//
//  NSMVideoPlayerController.h
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import <UIKit/UIKit.h>
#import "NSMVideoPlayerControllerDataSource.h"
#import "NSMPlayerProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@protocol NSMVideoPlayerViewProtocol;

@class NSMVideoPlayerControllerDataSource, NSMVideoPlayerConfig;

@protocol NSMVideoPlayerProtocol <NSMPlayerProtocol>

- (void)restorePlayerWithConfig:(NSMVideoPlayerConfig *)config;
- (NSMVideoPlayerConfig *)savePlayerState;

@end

@interface NSMVideoPlayerController : UIViewController

@property (nonatomic, strong) id <NSMVideoPlayerProtocol> videoPlayer;

@property (nonatomic, strong) NSURL *assetURL;


@end

NS_ASSUME_NONNULL_END
