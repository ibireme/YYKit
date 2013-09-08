//
//  UIView+Add.h
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright 2013 ibireme.
//

#import <UIKit/UIKit.h>


/**
 Provide some some common method for `UIView`.
 */
@interface UIView (YYAdd)

///snap the view's content with subview

/**
 Create a snapshot image from this view (and subviews).
 
 @return A snapshot image with view.size.
 */
- (UIImage *)snapshotImage;

///take snapshot and add 1 pixel transparency edge

/**
 Create a snapshot image and add 1 px transparency edge (for antialiasing).
 
 @see snapshotImage
 @return A snapshot image.
 */
- (UIImage *)snapshotImageAntialiasing;


/**
 Remove all subviews.
 */
- (void)removeAllSubviews;

///try to find the view's controller

/**
 Return the view's ViewController.
 */
@property (nonatomic, strong, readonly) UIViewController *viewController;

/**
 Shortcut for view.frame.size.width.
 */
@property (nonatomic, assign) CGFloat width;

/**
 Shortcut for view.frame.size.height.
 */
@property (nonatomic, assign) CGFloat height;

/**
 Shortcut for view.frame.origin.
 */
@property (nonatomic, assign) CGPoint origin;

/**
 Shortcut for view.frame.size.
 */
@property (nonatomic, assign) CGSize size;

@end
