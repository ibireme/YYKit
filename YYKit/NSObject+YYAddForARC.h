//
//  NSObject+YYAddForARC.h
//  YYKit
//
//  Created by ibireme on 13-12-25.
//  Copyright (c) 2013 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Debug method for NSObject when using ARC.
 */
@interface NSObject (YYAddForARC)

/// Same as `retain`
- (instancetype)arcDebugRetain;

/// Same as `release`
- (oneway void)arcDebugRelease;

/// Same as `autorelease`
- (instancetype)arcDebugAutorelease;

/// Same as `retainCount`
- (NSUInteger)arcDebugRetainCount;

@end
