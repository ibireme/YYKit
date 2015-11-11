//
//  YYThreadSafeDictionary.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/10/21.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

/**
 A simple implementation of thread safe mutable dictionary.
 
 @discussion Generally, access performance is lower than NSMutableDictionary,
 but higher than using @synchronized, NSLock, or pthread_mutex_t.
 
 @discussion It's also compatible with the custom methods in `NSDictionary(YYAdd)`
 and `NSMutableDictionary(YYAdd)`
 
 @warning Fast enumerate(for...in) and enumerator is not thread safe,
 use enumerate using block instead. When enumerate or sort with block/callback,
 do *NOT* send message to the dictionary inside the block/callback.
 */
@interface YYThreadSafeDictionary : NSMutableDictionary

@end
