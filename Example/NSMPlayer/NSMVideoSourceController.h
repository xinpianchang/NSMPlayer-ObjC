//
//  NSMVideoSourceController.h
//  NSMPlayer
//
//  Created by chengqihan on 2017/2/15.
//  Copyright © 2017年 migrant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSMVideoPlayerControllerDataSource;

@protocol NSMVideoSourceControllerDelegate <NSObject>

- (void)videoSourceControllerDidSelectedVideoDataSource:(NSMVideoPlayerControllerDataSource *)url;

@end

@interface NSMVideoSourceController : UITableViewController

@property (nonatomic, weak) id<NSMVideoSourceControllerDelegate> delegate;

@end

