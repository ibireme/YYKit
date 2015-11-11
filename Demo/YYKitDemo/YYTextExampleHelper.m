//
//  YYTextExampleHelper.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTextExampleHelper.h"
#import "YYKit.h"

static BOOL DebugEnabled = NO;

@implementation YYTextExampleHelper

+ (void)addDebugOptionToViewController:(UIViewController *)vc {
    UISwitch *switcher = [UISwitch new];
    switcher.layer.transformScale = 0.8;
    
    [switcher setOn:DebugEnabled];
    [switcher addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch *sender) {
        [self setDebug:sender.isOn];
    }];
    
    UIView *view = [UIView new];
    view.size = CGSizeMake(40, 44);
    [view addSubview:switcher];
    switcher.centerX = view.width / 2;
    switcher.centerY = view.height / 2;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    vc.navigationItem.rightBarButtonItem = item;
}

+ (void)setDebug:(BOOL)debug {
    YYTextDebugOption *debugOptions = [YYTextDebugOption new];
    if (debug) {
        debugOptions.baselineColor = [UIColor redColor];
        debugOptions.CTFrameBorderColor = [UIColor redColor];
        debugOptions.CTLineFillColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:0.180];
        debugOptions.CGGlyphBorderColor = [UIColor colorWithRed:1.000 green:0.524 blue:0.000 alpha:0.200];
    } else {
        [debugOptions clear];
    }
    [YYTextDebugOption setSharedDebugOption:debugOptions];
    DebugEnabled = debug;
}

+ (BOOL)isDebug {
    return DebugEnabled;
}

@end
