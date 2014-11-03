//
//  YYGIFImage.h
//  YYKit
//
//  Created by ibireme on 14/10/20.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAnimatedImageView.h"

/**
 An image to display animated gif.
 
 @discussion It is a fully compatible `UIImage` subclass. It has the same
 behaver as UIImage, unless it being displayed in an `YYAnimatedImageView`.

 Sample Code:
     
     // icon@2x.gif
     YYGifImage *image = [YYGifImage imageNamed:@"icon"];
     YYAnimatedImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
     [view addSubView:imageView];
 */
@interface YYGIFImage : UIImage <YYAnimatedImage>

// The declaration below (same as UIImage) returns YYGIFImage just for avoid incompatible type warning.
+ (YYGIFImage *)imageNamed:(NSString *)name; // do not cache!
+ (YYGIFImage *)imageWithContentsOfFile:(NSString *)path;
+ (YYGIFImage *)imageWithData:(NSData *)data;
+ (YYGIFImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;

@end
