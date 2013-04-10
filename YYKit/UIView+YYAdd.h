//
//  UIView+Add.h
//  YYCore
//
//  Created by ibireme on 13-4-3.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface UIView (YYAdd)

///snap the content with subview, All transation will be ignore
- (UIImage *)snapshot;

///take snapshot and add 1 pixel transparency edge
- (UIImage *)snapshotAntialiasing;

- (void)removeAllSubviews;

///try to find the view's controller
@property (nonatomic, readonly) UIViewController *viewController;

@end
