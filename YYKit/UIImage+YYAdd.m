//
//  UIImage+YYAdd.m
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import "UIImage+YYAdd.h"
#import "UIDevice+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYCoreMacro.h"
DUMMY_CLASS(UIImage_YYDebug)

#define X2 @"@2x"

@implementation UIImage (YYAdd)

+ (UIImage *)imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName {
	if (!bundleName) {
		return [UIImage imageNamed:imageName];
	}
	
    NSString *imageName2x = nil;
    if ([UIDevice currentDevice].isRetina) {
        imageName2x = [imageName stringByAdd2XPath];
    }
    
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
	
    if (imageName2x) {
        NSString *imagePath = [bundlePath stringByAppendingPathComponent:imageName2x];
        NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *img = [UIImage imageWithData:imgData scale:2.0];
        if (img)
            return img;
    }
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:imageName];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}


- (UIImage *)imageCroppedToRect:(CGRect)rect {
	CGFloat scale = self.scale;
	rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
	
	CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:scale orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	return cropped;
}


- (UIImage *)squareImage {
	CGSize imageSize = self.size;
	CGFloat shortestSide = fminf(imageSize.width, imageSize.height);
	return [self imageCroppedToRect:CGRectMake(0.0f, 0.0f, shortestSide, shortestSide)];
}


- (UIColor *)colorAtPoint:(CGPoint )point{
    UIColor *result = nil;

    CGImageRef imageRef = [self CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    result =  [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return result;
}

/// copy from http://developer.apple.com/library/ios/#qa/qa1708/_index.html
///没有放到head
- (UIImage *)resizeImage:(UIImage *)image toWidth:(NSInteger)width height:(NSInteger)height {
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize size = CGSizeMake(width, height);
    if (NULL != UIGraphicsBeginImageContextWithOptions) UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    else UIGraphicsBeginImageContext(size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Draw the original image to the context
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), image.CGImage);

    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return imageOut;
}


- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

@end
