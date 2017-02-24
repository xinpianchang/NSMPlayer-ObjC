//
//  NSMPlayerRestoration.m
//  Pods
//
//  Created by chengqihan on 2017/2/16.
//
//

#import "NSMPlayerRestoration.h"
#import "NSMVideoPlayerController.h"


static NSString * const NSMVideoPlayerPlayLoopKey = @"NSMVideoPlayerPlayLoopKey";

static NSString * const NSMVideoPlayerMutedKey = @"NSMVideoPlayerMutedKey";

static NSString * const NSMVideoPlayerPreloadKey = @"NSMVideoPlayerPreloadKey";

static NSString * const NSMVideoPlayerAutoPlayKey = @"NSMVideoPlayerAutoPlayKey";

static NSString * const NSMVideoPlayerAllowMeteredNetworkKey = @"NSMVideoPlayerAllowMeteredNetworkKey";


@interface NSMPlayerRestoration ()

@property (nonatomic, strong) NSMutableDictionary *configs;

@end

@implementation NSMPlayerRestoration

+ (instancetype)videoPlayerConfig {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.configs = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
