//
//  NSObject+YYAddForARC.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/12/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
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
