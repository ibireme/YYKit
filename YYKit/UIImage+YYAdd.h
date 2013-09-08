//
//  UIImage+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import <UIKit/UIKit.h>


/**
 Provide some commen method for `UIImage`.
 */
@interface UIImage (YYAdd)


///=============================================================================
/// @name Create image
///=============================================================================



/**
 Create and return a new 1x1 px image with the given color.
 
 @param color The color to create image.
 @return A new 1x1 px image with the given color.
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


/**
 Create and return a new image which is scaled from this image.
 The image will be strethed as needed.
 
 @param size The size to scaled.
 @return The new image with the given size.
 */
- (UIImage *)imageScaledToSize:(CGSize)size;




///=============================================================================
/// @name Get info from image
///=============================================================================


/**
 Create and return a new UIColor object from the pixel pointed in this image.
 
 @param point The point in this image.
    The range of point.x and point.y is [0,image.width-1].
    If the point is out of this image, it will return nil.
 
 @return The UIColor object, or nil when error occured.
 */
- (UIColor *)colorAtPoint:(CGPoint )point;


/**
 Return if this image has alpha channel.
 */
- (BOOL)hasAlphaChannel;






@end
