//
//  NSMVideoPlayerProtocol.h
//  Pods
//
//  Created by chengqihan on 2017/2/20.
//
//

#import "NSMPlayerProtocol.h"

@class NSMPlayerRestoration;

@protocol NSMVideoPlayerProtocol <NSMPlayerProtocol>

- (void)restorePlayerWithRestoration:(NSMPlayerRestoration *)restoration;
- (NSMPlayerRestoration *)savePlayerState;

@end
