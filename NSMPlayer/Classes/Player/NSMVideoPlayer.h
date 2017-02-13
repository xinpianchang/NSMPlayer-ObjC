//
//  NSMVideoPlayer.h
//  Pods
//
//  Created by chengqihan on 2017/2/13.
//
//

#import <Foundation/Foundation.h>
#import "NSMUnderlyingPlayer.h"
#import "NSMVideoPlayerController.h"

@interface NSMVideoPlayer : NSObject <NSMVideoPlayerProtocol>

@property (nonatomic, strong) id<NSMUnderlyingPlayerProtocol> underlyingPlayer;

@end
