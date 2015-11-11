//
//  YYTextExampleHelper.h
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTextExampleHelper : NSObject

+ (void)addDebugOptionToViewController:(UIViewController *)vc;
+ (void)setDebug:(BOOL)debug;
+ (BOOL)isDebug;
@end
