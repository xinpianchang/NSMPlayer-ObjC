//
//  NSMUnderlyingPlayer.m
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//

#import "NSMUnderlyingPlayer.h"
#import "NSMVideoPlayerControllerDataSource.h"

NSString * const NSMUnderlyingPlayerErrorDomain = @"NSMUnderlyingPlayerErrorDomain";

 NSString *const NSMUnderlyingPlayerDidPlayToEndTimeNotification = @"NSMUnderlyingPlayerDidPlayToEndTimeNotification";

NSString *const NSMUnderlyingPlayerFailedNotification = @"NSMUnderlyingPlayerFailedNotification";

 NSString *const NSMUnderlyingPlayerLoadedTimeRangesDidChangeNotification = @"NSMUnderlyingPlayerLoadedTimeRangesDidChangeNotification";

NSString *const NSMUnderlyingPlayerPlaybackBufferEmptyNotification = @"NSMUnderlyingPlayerPlaybackBufferEmptyNotification";

NSString *const NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification = @"NSMUnderlyingPlayerPlaybackLikelyToKeepUpNotification";

NSString *const NSMUnderlyingPlayerPlayheadDidChangeNotification = @"NSMUnderlyingPlayerPlayheadDidChangeNotification";

NSString *const NSMUnderlyingPlayerPeriodicPlayTimeChangeKey = @"NSMUnderlyingPlayerPeriodicPlayTimeChangeKey";

NSString *const NSMUnderlyingPlayerErrorKey = @"NSMUnderlyingPlayerErrorKey";

NSString *const NSMUnderlyingPlayerLoadedTimeRangesKey = @"NSMUnderlyingPlayerErrorKey";


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"

@implementation NSMUnderlyingPlayer

//- (instancetype)initWithAssetURL:(NSURL *)assetURL {
//    self = [super init];
//    if (self) {
//        _playerURL = assetURL;
//    }
//    return self;
//}

- (void)setPlayerSource:(NSMVideoPlayerControllerDataSource *)playerSource {
    _playerURL = playerSource.assetURL;
}
#pragma clang diagnostic pop

@end
