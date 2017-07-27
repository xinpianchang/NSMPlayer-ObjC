//
//  NSMVideoTableViewCell.m
//  NSMPlayer
//
//  Created by chengqihan on 2017/7/13.
//  Copyright © 2017年 migrant. All rights reserved.
//

#import "NSMVideoTableViewCell.h"
@import NSMPlayer;

@interface NSMVideoTableViewCell ()

@property (nonatomic, strong) NSMAVPlayerView *playerView;
@property (nonatomic, strong) NSMPlayerAccessoryView *playerAccessoryView;
@property (nonatomic, strong) UIButton *postView;

@end

@implementation NSMVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureView];
    }
    return self;
}
- (void)configureView {
    
    NSMAVPlayerView *playerView = [[NSMAVPlayerView alloc] init];
    playerView.translatesAutoresizingMaskIntoConstraints = NO;
    playerView.backgroundColor = [UIColor blackColor];
    self.playerView = playerView;
    [self.contentView addSubview:playerView];
    
    NSDictionary *playerViews =  NSDictionaryOfVariableBindings(playerView);
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playerView]|" options:0 metrics:nil views:playerViews]];

    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[playerView(300)]-|" options:0 metrics:nil views:playerViews]];
    
    NSMPlayerAccessoryView *playerAccessoryView = [[NSMPlayerAccessoryView alloc] init];
    playerAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerAccessoryView = playerAccessoryView;
    [playerView addSubview:playerAccessoryView];
    
    NSDictionary *playerAccessoryViews = NSDictionaryOfVariableBindings(playerAccessoryView);
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[playerAccessoryView]|" options:0 metrics:nil views:playerAccessoryViews]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playerAccessoryView]|" options:0 metrics:nil views:playerAccessoryViews]];
    
    UIButton *postView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.postView = postView;
    postView.translatesAutoresizingMaskIntoConstraints = NO;
    postView.backgroundColor = [UIColor grayColor];
    [playerView addSubview:postView];
    NSDictionary *postViews = NSDictionaryOfVariableBindings(postView);
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[postView]|" options:0 metrics:nil views:postViews]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[postView]|" options:0 metrics:nil views:postViews]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
