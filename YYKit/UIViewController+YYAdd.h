//
//  UIViewController+YYAdd.h
//  YYKit
//
//  Created by Andrii Tishchenko on 21.04.15.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YYAdd)
- (void)containerRemoveChildViewController:(UIViewController *)childViewController ;
- (void)containerAddChildViewController:(UIViewController *)childViewController;
@end
