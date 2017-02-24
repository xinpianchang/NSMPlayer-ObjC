//
//  NSMVideoSourceController.h
//  NSMPlayer
//
//  Created by chengqihan on 2017/2/15.
//  Copyright © 2017年 migrant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSMPlayerAsset;

@protocol NSMVideoSourceControllerDelegate <NSObject>

- (void)videoSourceControllerDidSelectedPlayerItem:(NSMPlayerAsset *)url;

@end

@interface NSMVideoSourceController : UITableViewController

@property (nonatomic, weak) id<NSMVideoSourceControllerDelegate> delegate;

@end

