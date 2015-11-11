//
//  YYControl.h
//  YYKitExample
//
//  Created by ibireme on 15/9/14.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

@interface YYControl : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^touchBlock)(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event);
@property (nonatomic, copy) void (^longPressBlock)(YYControl *view, CGPoint point);
@end
