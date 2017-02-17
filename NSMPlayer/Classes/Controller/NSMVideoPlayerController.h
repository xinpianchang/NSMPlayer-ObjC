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
#import "NSMVideoPlayerConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NSMVideoPlayerType) {
    NSMVideoPlayerAVPlayer = 1,
    NSMVideoPlayerIJKPlayer,
};

@protocol NSMVideoPlayerViewProtocol;

@class NSMVideoPlayerControllerDataSource;

@protocol NSMVideoPlayerProtocol <NSMPlayerProtocol>

- (void)choosePlayerWithType:(NSMVideoPlayerType)type;
- (void)retry;
- (void)resotrePlayerWithConfig:(NSMVideoPlayerConfig *)config;
- (NSMVideoPlayerConfig *)savePlayerState;

@end

@interface NSMVideoPlayerController : UIViewController

@property (nonatomic, strong) id <NSMVideoPlayerProtocol> videoPlayer;

@property (nonatomic, strong) NSURL *assetURL;


@end

NS_ASSUME_NONNULL_END
