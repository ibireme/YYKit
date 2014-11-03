//
//  YYAnimatedImageView.h
//  YYKit
//
//  Created by ibireme on 14/10/19.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 An image view for animated image display.
 
 @discussion It is a fully compatible `UIImageView` subclass. It has the same 
 behaver as UIImageView, unless the `.image` or `.highlightedImage` adopt to the
 `YYAnimatedImage` procotol. The animation can also be controlled with the 
 `UIImageView` methods `-startAnimating`, `-stopAnimating` and `-isAnimating`.
 
 @discussion This view request the frame data just in time. When the device
 has enough free memory, the view may cache some frames in an inner buffer for
 lower CPU usage. Buffer size is dynamically adjusted based on the current state
 of the device memory.
 
 Sample Code:

     // icon@2x.gif
     YYGifImage *image = [YYGifImage imageNamed:@"icon"];
     YYAnimatedImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
     [view addSubView:imageView];
 */
@interface YYAnimatedImageView : UIImageView

@end


/**
 The YYAnimatedImage protocol declares the required methods for animated image
 display with YYAnimatedImageView.
 
 Subclass a UIImage and implement the protocol's method, so that instances of
 that class can be set into a YYAnimatedImageView to display animated image.
 
 see `YYGIFImage` for example.
 */
@protocol YYAnimatedImage <NSObject>
@required

/// Total animated image count.
- (NSUInteger)animatedImageCount;

/// Animation repeat count. 0 means infinite.
- (NSUInteger)animatedImageRepeatCount;

/// Bytes per frame (used for optimize buffer size)
- (NSUInteger)animatedImageBytesPerFrame;

/// Return the image at index (this method is called in background thread).
/// @param index  Index from 0.
- (UIImage *)animatedImageAtIndex:(NSUInteger)index;

/// Return the image's duration at index.
/// @param index  Index from 0.
- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index;

@end
