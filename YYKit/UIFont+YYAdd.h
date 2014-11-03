//
//  UIFont+YYAdd.h
//  YYKit
//
//  Created by ibireme on 14-5-11.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>

/**
 Provides extensions for `UIFont`.
 */
@interface UIFont (YYAdd)


#pragma mark - Create font
///=============================================================================
/// @name Create font
///=============================================================================

/**
 Creates and returns a font object for the specified CTFontRef.
 
 @param CTFont  CoreText font.
 */
+ (UIFont *)fontWithCTFont:(CTFontRef)CTFont;

/**
 Creates and returns a font object for the specified CGFontRef and size.
 
 @param CGFont  CoreGraphic font.
 @param size    Font size.
 */
+ (UIFont *)fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;

/**
 Creates and returns the CTFontRef object. (need call CFRelease() after used)
 */
- (CTFontRef)CTFont CF_RETURNS_RETAINED;

/**
 Creates and returns the CGFontRef object. (need call CFRelease() after used)
 */
- (CGFontRef)CGFont CF_RETURNS_RETAINED;


#pragma mark - Load and unload font
///=============================================================================
/// @name Load and unload font
///=============================================================================

/**
 Load the font from file path. Support format:TTF,OTF.
 If return YES, font can be load use it PostScript Name: [UIFont fontWithName:...]
 
 @param path    font file's full path
 */
+ (BOOL)loadFontFromPath:(NSString *)path;

/**
 Unload font from file path.
 
 @param path    font file's full path
 */
+ (void)unloadFontFromPath:(NSString *)path;

/**
 Load the font from data. Support format:TTF,OTF.
 
 @param data  Font data.
 
 @return UIFont object if load success, otherwise nil.
 */
+ (UIFont *)loadFontFromData:(NSData *)data;

/**
 Unload font which is loaded by loadFontFromData: function.
 
 @param font the font loaded by loadFontFromData: function
 
 @return YES if success, otherwise NO.
 */
+ (BOOL)unloadFontFromData:(UIFont *)font;


#pragma mark - Dump font data
///=============================================================================
/// @name Dump font data
///=============================================================================

/**
 Serialize and return the font data.
 
 @param font The font.
 
 @return data in TTF, or nil if an error occurs.
 */
+ (NSData *)dataFromFont:(UIFont *)font;

/**
 Serialize and return the font data.
 
 @param cgFont The font.
 
 @return data in TTF, or nil if an error occurs.
 */
+ (NSData *)dataFromCGFont:(CGFontRef)cgFont;

@end
