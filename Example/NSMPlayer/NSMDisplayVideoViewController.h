//
//  NSMDisplayVideoViewController.h
//  NSMPlayer
//
//  Created by chengqihan on 2017/7/14.
//  Copyright © 2017年 migrant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSMVideoPlayerController;

@protocol NSMDisplayVideoViewControllerDelegate <NSObject>

- (void)displayVideoViewControllerDismiss;

@end

@interface NSMDisplayVideoViewController : UIViewController

@property (nonatomic, weak) id<NSMDisplayVideoViewControllerDelegate> delegate;
- (instancetype)initWithVideoPlayer:(NSMVideoPlayerController *)playerController;

@end
