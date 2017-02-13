//
//  NSMAVPlayer.h
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//

#import "NSMUnderlyingPlayer.h"

@interface NSMAVPlayer : NSMUnderlyingPlayer

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) NSURL *playerURL;

@end
