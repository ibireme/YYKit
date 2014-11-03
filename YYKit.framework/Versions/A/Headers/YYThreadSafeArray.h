//
//  YYThreadSafeArray.h
//  YYKit
//
//  Created by ibireme on 14-10-21.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A simple implementation of thread safe mutable array.
 
 @discussion Generally, access performance is lower than NSMutableArray, 
 but higher than using @synchronized, NSLock, or pthread_mutex_t.
 
 @discussion Fast enumerate(for..in) and enumerator is not thread safe, 
 use enumerate using block instead. When enumerate or sort with block/callback,
 do *NOT* send message to the array inside the block/callback.
 
 @discussion It's also compatible with the custom methods in `NSArray(YYAdd)`
 and `NSMutableArray(YYAdd)`
 */
@interface YYThreadSafeArray : NSMutableArray

@end
