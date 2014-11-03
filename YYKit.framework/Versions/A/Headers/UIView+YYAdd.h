//
//  UIView+Add.h
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright (c) 2013 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Provides extensions for `UIView`.
 */
@interface UIView (YYAdd)

/**
 Create a snapshot image of the complete view hierarchy.
 This method should be called in main thread.
 */
- (UIImage *)snapshotImage;

/**
 Create a snapshot PDF of the complete view hierarchy.
 This method should be called in main thread.
 */
- (NSData *)snapshotPDF;

/**
 Shortcut to set the view.layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)removeAllSubviews;

/**
 Returns the view's view controller (may be nil).
 */
@property (nonatomic, readonly) UIViewController *viewController;

@property (nonatomic) CGFloat left;    ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;     ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;   ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;  ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;   ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;  ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX; ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY; ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;  ///< Shortcut for frame.origin.
@property (nonatomic) CGSize size;     ///< Shortcut for frame.size.
@property (nonatomic, readonly) CGRect screenFrame; ///< View frame on the screen, taking into account scroll views.

@end
