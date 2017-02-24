//
//  NSMVideoPlayerController.h
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import <UIKit/UIKit.h>
#import "NSMPlayerAsset.h"
#import "NSMVideoPlayerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMVideoPlayerController : UIViewController

@property (nonatomic, strong) id <NSMVideoPlayerProtocol> videoPlayer;

@end

NS_ASSUME_NONNULL_END
