#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSMVideoPlayerController.h"
#import "NSMPlayerLogging.h"
#import "NSMPlayerAsset.h"
#import "NSMPlayerRestoration.h"
#import "NSMVideoPlayer.h"
#import "NSMPlayerAccessoryView.h"
#import "NSMPlayerAccessoryViewDelegate.h"
#import "NSMPlayerAccessoryViewProtocol.h"
#import "NSMAVPlayerView.h"
#import "NSMPlayerProtocol.h"
#import "NSMUnderlyingPlayerProtocol.h"
#import "NSMVideoPlayerProtocol.h"
#import "NSMVideoPlayerViewProtocol.h"
#import "NSMAVPlayer.h"
#import "NSMUnderlyingPlayer.h"

FOUNDATION_EXPORT double NSMPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char NSMPlayerVersionString[];

