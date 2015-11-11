//
//  NSThread+YYAdd.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/7/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

@interface NSThread (YYAdd)

/**
 Add an autorelease pool to current runloop for current thread.
 
 @discussion If you create your own thread (NSThread/pthread), and you use 
 runloop to manage your task, you may use this method to add an autorelease pool
 to the runloop. Its behavior is the same as the main thread's autorelease pool.
 */
+ (void)addAutoreleasePoolToCurrentRunloop;

@end
