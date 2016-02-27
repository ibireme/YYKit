//
//  NSNotificationCenter+YYAdd.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/8/24.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some method for `NSNotificationCenter`
 to post notification in different thread.
 */
@interface NSNotificationCenter (YYAdd)

/**
 Posts a given notification to the receiver on main thread.
 If current thread is main thread, the notification is posted synchronously;
 otherwise, is posted asynchronously.
 
 @param notification  The notification to post.
                      An exception is raised if notification is nil.
 */
- (void)postNotificationOnMainThread:(NSNotification *)notification;

/**
 Posts a given notification to the receiver on main thread.
 
 @param notification The notification to post.
                     An exception is raised if notification is nil.
 
 @param wait         A Boolean that specifies whether the current thread blocks 
                     until after the specified notification is posted on the 
                     receiver on the main thread. Specify YES to block this 
                     thread; otherwise, specify NO to have this method return 
                     immediately.
 */
- (void)postNotificationOnMainThread:(NSNotification *)notification
                       waitUntilDone:(BOOL)wait;

/**
 Creates a notification with a given name and sender and posts it to the 
 receiver on main thread. If current thread is main thread, the notification 
 is posted synchronously; otherwise, is posted asynchronously.
 
 @param name    The name of the notification.
 
 @param object  The object posting the notification.
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object;

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread. If current thread is main thread, the notification
 is posted synchronously; otherwise, is posted asynchronously.
 
 @param name      The name of the notification.
 
 @param object    The object posting the notification.
 
 @param userInfo  Information about the the notification. May be nil.
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object
                                    userInfo:(nullable NSDictionary *)userInfo;

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread.
 
 @param name     The name of the notification.
 
 @param object   The object posting the notification.
 
 @param userInfo Information about the the notification. May be nil.
 
 @param wait     A Boolean that specifies whether the current thread blocks
                 until after the specified notification is posted on the
                 receiver on the main thread. Specify YES to block this
                 thread; otherwise, specify NO to have this method return
                 immediately.
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object
                                    userInfo:(nullable NSDictionary *)userInfo
                               waitUntilDone:(BOOL)wait;

@end

NS_ASSUME_NONNULL_END
