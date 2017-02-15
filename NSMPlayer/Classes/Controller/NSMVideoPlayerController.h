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

typedef NS_ENUM(NSUInteger, NSMVideoPlayerType) {
    NSMVideoPlayerAVPlayer = 1,
    NSMVideoPlayerIJKPlayer,
};

@protocol NSMVideoPlayerViewProtocol;

@class NSMVideoPlayerControllerDataSource;

@protocol NSMVideoPlayerProtocol <NSMPlayerProtocol>

@property (nonatomic, strong) NSMVideoPlayerControllerDataSource *videoPlayerDataSource;
@property (nonatomic, strong) id videoPlayerRenderView;

- (void)choosePlayerWithType:(NSMVideoPlayerType)type;
- (void)play;
- (void)pause;
- (void)releasePlayer;
- (void)seekToTime:(NSTimeInterval)time;
- (void)retry;
- (void)replaceItem;

@end

@interface NSMVideoPlayerController : UIViewController

@property (nonatomic, strong) id <NSMVideoPlayerProtocol> videoPlayer;

@property (nonatomic, strong) NSURL *assetURL;

- (instancetype)initWithURL:(NSURL *)assetURL;
@end

NS_ASSUME_NONNULL_END
