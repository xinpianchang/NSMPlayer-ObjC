//
//  NSMVideoTableViewCell.h
//  NSMPlayer
//
//  Created by chengqihan on 2017/7/13.
//  Copyright © 2017年 migrant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSMAVPlayerView, NSMPlayerAccessoryView;

@interface NSMVideoTableViewCell : UITableViewCell

//@property (nonatomic, assign) BOOL active;

@property (nonatomic, readonly, strong) NSMAVPlayerView *playerView;
@property (nonatomic, readonly, strong) NSMPlayerAccessoryView *playerAccessoryView;
@property (nonatomic, readonly, strong) UIButton *postView;

@end
