//
//  UIBezierPath+YYAdd.h
//  YYKit
//
//  Created by ibireme on 14/10/30.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Provides extensions for `UIBezierPath`.
 */
@interface UIBezierPath (YYAdd)

/**
 Creates and returns a new UIBezierPath object initialized with the text glyphs
 generated from the specified font.
 
 @discussion It don't support apple emoji. If you want get emoji image, try
 [UIImage imageWithEmoji:size:] in `UIImage(YYAdd)`.
 
 @param text The text to generate glyph path.
 
 @param font The font to generate glyph path.
 
 @return A new path object with the text and font, or nil when an error occurs.
 */
+ (UIBezierPath *)bezierPathWithText:(NSString *)text font:(UIFont *)font;

@end
