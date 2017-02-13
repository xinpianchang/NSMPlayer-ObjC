//
//  NSMPlayerAccessoryViewProtocol.h
//  Pods
//
//  Created by linlin on 2017/2/10.
//
//

#import <Foundation/Foundation.h>

@protocol NSMPlayerAccessoryViewDelegate;

@protocol NSMPlayerAccessoryViewProtocol <NSObject>

@property (nonatomic, weak) id<NSMPlayerAccessoryViewDelegate> delegate;

@property (nonatomic, strong) NSProgress *progress;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
