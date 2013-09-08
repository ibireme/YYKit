//
//  NSNotificationCenter+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-8-24.
//  Copyright (c) 2013年 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

//PSFouncaton

/**
 Provide some method for `NSNotificationCenter`
 to post notification in different thread.
 */
@interface NSNotificationCenter (YYAdd)

- (void)postNotificationOnMainThread:(NSNotification *)notification;

- (void)postNotificationOnMainThread:(NSNotification *)notification
                       waitUntilDone:(BOOL)wait;

- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object;

- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
                                    userInfo:(NSDictionary *)userInfo;

- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
                                    userInfo:(NSDictionary *)userInfo
                               waitUntilDone:(BOOL)wait;

@end
