//
//  YYThreadSafeDictionary.h
//  YYKit
//
//  Created by ibireme on 14-10-21.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A simple implementation of thread safe mutable dictionary.
 
 @discussion Generally, access performance is lower than NSMutableDictionary,
 but higher than using @synchronized, NSLock, or pthread_mutex_t.
 
 @discussion Fast enumerate(for...in) and enumerator is not thread safe,
 use enumerate using block instead. When enumerate or sort with block/callback,
 do *NOT* send message to the dictionary inside the block/callback.
 
 @discussion It's also compatible with the custom methods in `NSDictionary(YYAdd)`
 and `NSMutableDictionary(YYAdd)`
 */
@interface YYThreadSafeDictionary : NSMutableDictionary

@end
