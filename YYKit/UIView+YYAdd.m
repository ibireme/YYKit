//
//  UIView+Add.m
//  YYCore
//
//  Created by ibireme on 13-4-3.
//  2013 ibireme.
//

#import "UIView+YYAdd.h"
#import "YYCoreMacro.h"
#import <QuartzCore/QuartzCore.h>

DUMMY_CLASS(UIView_YYAdd)

@implementation UIView (YYAdd)

- (UIImage *)snapshot{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)snapshotAntialiasing {
    return [self.class renderImageForAntialiasing:[self snapshot]
                                       withInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image withInsets:(UIEdgeInsets)insets {
    CGSize imageSizeWithBorder = CGSizeMake([image size].width + insets.left + insets.right,
                                            [image size].height + insets.top + insets.bottom);

    UIGraphicsBeginImageContextWithOptions(imageSizeWithBorder,
                                           UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);

    [image drawInRect:(CGRect) {{ insets.left, insets.top }, [image size] }];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}


- (void)removeAllSubviews{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

- (UIViewController *)viewController {
    for (UIView *view = [self superview]; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
