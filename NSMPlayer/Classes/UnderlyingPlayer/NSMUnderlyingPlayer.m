//
//  NSMUnderlyingPlayer.m
//  AVFoundataion_Playback
//
//  Created by chengqihan on 2017/2/9.
//  Copyright © 2017年 chengqihan. All rights reserved.
//

#import "NSMUnderlyingPlayer.h"
#import "NSMPlayerAsset.h"

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

@synthesize duration = _duration;
@synthesize currentStatus = _currentStatus;
//@synthesize currentAsset = _currentAsset;
@synthesize loopPlayback = _loopPlayback;
@synthesize autoPlay = _autoPlay;
@synthesize preload = _preload;
@synthesize muted = _muted;
@synthesize rate = _rate;
@synthesize volume = _volume;
@synthesize allowWWAN = _allowWWAN;
@synthesize playHeadTime = _playHeadTime;
@synthesize playerType = _playerType;

- (id)player {
    return nil;
}
//- (instancetype)initWithAssetURL:(NSURL *)assetURL {
//    self = [super init];
//    if (self) {
//        _playerURL = assetURL;
//    }
//    return self;
//}

//- (void)setPlayerSource:(NSMVideoPlayerControllerDataSource *)playerSource {
//    _playerURL = playerSource.assetURL;
//}
#pragma clang diagnostic pop

@end
