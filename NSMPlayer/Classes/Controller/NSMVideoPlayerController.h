//
//  NSMVideoPlayerController.h
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import <UIKit/UIKit.h>
#import "NSMVideoPlayerControllerDataSource.h"

@protocol NSMVideoPlayerProtocol <NSObject>

@property (nonatomic, strong) NSMVideoPlayerControllerDataSource *dataSource;

- (void)play;
- (void)pause;
- (void)releasePlayer;
- (void)seekToTime:(NSTimeInterval)time;

@end

@interface NSMVideoPlayerController : UIViewController

@property (nonatomic, strong) id <NSMVideoPlayerProtocol> videoPlayer;

@end

