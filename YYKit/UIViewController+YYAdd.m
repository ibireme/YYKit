//
//  UIViewController+YYAdd.m
//  YYKit
//
//  Created by Andrii Tishchenko on 21.04.15.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "UIViewController+YYAdd.h"
#import "YYKitMacro.h"
SYNTH_DUMMY_CLASS(UIViewController_YYAdd)

@implementation UIViewController (YYAdd)
- (void)containerRemoveChildViewController:(UIViewController *)childViewController {
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
}
- (void)containerAddChildViewController:(UIViewController *)childViewController {
    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}
@end
