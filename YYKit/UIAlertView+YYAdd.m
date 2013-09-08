//
//  UIAlertView+YYAdd.m
//  YYKit
//
//  Created by ibireme on 13-8-25.
//  Copyright (c) 2013年 ibireme. All rights reserved.
//

#import "UIAlertView+YYAdd.h"
#import "YYKitMacro.h"

DUMMY_CLASS(UIAlertView_YYDebug)


@implementation UIAlertView (YYAdd)

+ (void)showWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil];
    [alert show];
}
@end
