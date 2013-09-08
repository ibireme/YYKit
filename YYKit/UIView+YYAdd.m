//
//  UIView+Add.m
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright 2013 ibireme.
//

#import "UIView+YYAdd.h"
#import <QuartzCore/QuartzCore.h>
#import "YYKitMacro.h"


DUMMY_CLASS(UIView_YYAdd)

@implementation UIView (YYAdd)

- (UIImage *)snapshotImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)snapshotImageAntialiasing {
    return [self.class renderImageForAntialiasing:[self snapshotImage]
                                       withInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image
                             withInsets:(UIEdgeInsets)insets {
    CGSize imageSizeWithBorder = CGSizeMake([image size].width + insets.left
                                            + insets.right, [image size].height
                                            + insets.top + insets.bottom);

    UIGraphicsBeginImageContextWithOptions(imageSizeWithBorder,
                    UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);

    [image drawInRect:(CGRect) {{ insets.left, insets.top }, [image size] }];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}


- (void)removeAllSubviews{
    while (self.subviews.count) {
        UIView* subView = self.subviews.lastObject;
        [subView removeFromSuperview];
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












- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
