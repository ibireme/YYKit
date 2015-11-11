//
//  T1Helper.h
//  YYKitExample
//
//  Created by ibireme on 15/10/10.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@interface T1Helper : NSObject

/// Image resource bundle
+ (NSBundle *)bundle;

/// Image cache
+ (YYMemoryCache *)imageCache;

/// Get image from bundle with cache.
+ (UIImage *)imageNamed:(NSString *)name;

/// Convert date to friendly description.
+ (NSString *)stringWithTimelineDate:(NSDate *)date;

/// Convert number to friendly description.
+ (NSString *)shortedNumberDesc:(NSUInteger)number;

@end
