//
//  NSMPlayerError.h
//  Pods
//
//  Created by chengqihan on 2017/2/24.
//
//

#import <Foundation/Foundation.h>
#import "NSMPlayerRestoration.h"

@interface NSMPlayerError : NSObject

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMPlayerRestoration *restoration;

@end
