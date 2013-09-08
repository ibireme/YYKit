//
//  UIAlertView+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-8-25.
//  Copyright (c) 2013年 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Provide a quick method for `UIAlertView` to show message.
 */
@interface UIAlertView (YYAdd)

/**
 Quick show a message with an "OK" button.
 @param title AlertView's Title.
 @param message AlertView's content.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message;

@end
