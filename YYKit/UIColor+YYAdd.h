//
//  UIColor+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import <UIKit/UIKit.h>



void RGB2HSL(CGFloat r, CGFloat g, CGFloat b,
             CGFloat *h, CGFloat *s, CGFloat *l);

void HSL2RGB(CGFloat h, CGFloat s, CGFloat l,
             CGFloat *r, CGFloat *g, CGFloat *b);

void RGB2HSB(CGFloat r, CGFloat g, CGFloat b,
             CGFloat *h, CGFloat *s, CGFloat *v);

void HSB2RGB(CGFloat h, CGFloat s, CGFloat v,
             CGFloat *r, CGFloat *g, CGFloat *b);

void RGB2CMYK(CGFloat r, CGFloat g, CGFloat b,
              CGFloat *c, CGFloat *m, CGFloat *y, CGFloat *k);

void CMYK2RGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k,
              CGFloat *r, CGFloat *g, CGFloat *b);

void HSB2HSL(CGFloat h, CGFloat s, CGFloat b,
             CGFloat *hh, CGFloat *ss, CGFloat *ll);

void HSL2HSB(CGFloat h, CGFloat s, CGFloat l,
             CGFloat *hh, CGFloat *ss, CGFloat *bb);


#define UIColorRGB(r, g, b)     [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

#define UIColorHSB(h, s, b)     [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:1]
#define UIColorHSBA(h, s, b, a) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:(a)]

#define UIColorHSL(h, s, l)     [UIColor colorWithHue:(h) saturation:(s) lightness:(l) alpha:1]
#define UIColorHSLA(h, s, l, a) [UIColor colorWithHue:(h) saturation:(s) lightness:(l) alpha:(a)]

#define UIColorCMYK(c, m, y, k) [UIColor colorWithCyan:(c) magenta:(m) yellow:(y) black:(k) alpha:1]
#define UIColorCMYKA(c,m,y,k,a) [UIColor colorWithCyan:(c) magenta:(m) yellow:(y) black:(k) alpha:(a)]



/**
 Provide some method for `UIColor` to convert color between
 RGB,HSB,HSL,CMYK and Hex.
 
 | Color space | Meaning                                |
 |-------------|----------------------------------------|
 | RGB         | Red, Green, Blue                       |
 | HSB(HSV)    | Hue, Saturation, Brightness (Value)    |
 | HSL         | Hue, Saturation, Lightness             |
 | CMYK        | Cyan, Magenta, Yellow, Black           |
 
 Apple use RGB & HSB default.
 
 All the value in this category is float number in the range `0.0` to `1.0`.
 Values below `0.0` are interpreted as `0.0`,
 and values above `1.0` are interpreted as `1.0`.
 
 If you want convert color between more color space (CIEXYZ,Lab,YUV...),
 see https://github.com/ibireme/yy_color_convertor on Github
 */
@interface UIColor (YYAdd)

///=============================================================================
/// @name Creating a UIColor Object
///=============================================================================


/**
 Creates and returns a color object using the specified opacity 
 and HSL color space component values.
 
 @param hue The hue component of the color object in the HSL color space,
 specified as a value from 0.0 to 1.0.
 
 @param saturation The saturation component of the color object 
 in the HSL color space, specified as a value from 0.0 to 1.0.
 
 @param lightness The lightness component of the color object 
 in the HSL color space, specified as a value from 0.0 to 1.0.
 
 @param alpha The opacity value of the color object, 
 specified as a value from 0.0 to 1.0.
 
 @return The color object. 
 The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *)colorWithHue:(CGFloat)hue
               saturation:(CGFloat)saturation
                lightness:(CGFloat)lightness
                    alpha:(CGFloat)alpha;


/**
 Creates and returns a color object using the specified opacity
 and CMYK color space component values.
 
 @param cyan The cyan component of the color object in the CMYK color space,
 specified as a value from 0.0 to 1.0.
 
 @param magenta The magenta component of the color object
 in the CMYK color space, specified as a value from 0.0 to 1.0.
 
 @param yellow The yellow component of the color object
 in the CMYK color space, specified as a value from 0.0 to 1.0.
 
 @param black The black component of the color object
 in the CMYK color space, specified as a value from 0.0 to 1.0.
 
 @param alpha The opacity value of the color object,
 specified as a value from 0.0 to 1.0.
 
 @return The color object.
 The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *)colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha;



/// 0xFF00AA

/**
 Creates and returns a color object using the hex RGB color values.
 
 @param rgbValue The rgb value such as 0x66ccff.
 
 @return The color object.
 The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *) colorWithRGB:(uint32_t)rgbValue;



/**
 Creates and returns a color object using the hex RGBA color values.
 
 @param rgbaValue The rgb value such as 0x66ccffff.
 
 @return The color object.
 The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *) colorWithRGBA:(uint32_t)rgbaValue;


/**
 Creates and returns a color object using the specified opacity
 and RGB hex value.
 
 @param rgbValue The rgb value such as 0x66ccff.
 
 @param alpha The opacity value of the color object,
 specified as a value from 0.0 to 1.0.
 
 @return The color object.
 The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *) colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;




/**
 Creates and returns an UIColor object from a hex string.
 
 These formats is valid: #rgb #rgba #rrggbb #rrggbbaa 0xrgb ...
 The `#` or "0x" sign is not required.
 The alpha show be set to 1.0 if there is no alpha component.
 It will return nil when error occured in parsing.

 @param hexStr The hex string value for the new color.
 
 @return An UIColor object from string, or nil when error occurd.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr;


///=============================================================================
/// @name Get color's description
///=============================================================================


/**
 Return the rgb value in hex.
 
 @return hex value of RGB,such as 0x66ccff.
 */
- (uint32_t)rgbValue;

/**
 Return the rgba value in hex.
 
 @return hex value of RGBA,such as 0x66ccffff.
 */
- (uint32_t)rgbaValue;


/**
 Returns the color's RGB value as a hex string (lowercase).
 Such as @"0066cc".
 
 It will return nil when the color space is not RGB
 
 @return The color's value as a hex string.
 */
- (NSString *)hexString;


/**
 Returns the color's RGBA value as a hex string (lowercase).
 Such as @"0066ccff".
 
 It will return nil when the color space is not RGBA
 
 @return The color's value as a hex string.
 */
- (NSString *)hexStringWithAlpha;



///=============================================================================
/// @name Retrieving Color Information
///=============================================================================


/**
 Returns the components that make up the color in the HSL color space.
 
 @param hue On return, the hue component of the color object, 
 specified as a value between 0.0 and 1.0.
 
 @param saturation On return, the saturation component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param lightness On return, the lightness component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param alpha On return, the alpha component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @return YES if the color could be converted, NO otherwise.
 */
- (BOOL)getHue:(CGFloat *)hue
    saturation:(CGFloat *)saturation
     lightness:(CGFloat *)lightness
         alpha:(CGFloat *)alpha;


/**
 Returns the components that make up the color in the CMYK color space.
 
 @param cyan On return, the cyan component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param magenta On return, the magenta component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param yellow On return, the yellow component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param black On return, the black component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param alpha On return, the alpha component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @return YES if the color could be converted, NO otherwise.
 */
- (BOOL)getCyan:(CGFloat *)cyan
        magenta:(CGFloat *)magenta
         yellow:(CGFloat *)yellow
          black:(CGFloat *)black
          alpha:(CGFloat *)alpha;




/**
 The color's red component value in RGB color space.
 
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat red;

/**
 The color's green component value in RGB color space.
 
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat green;

/**
 The color's blue component value in RGB color space.
 
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat blue;

/**
 The color's hue component value in HSB color space.
 
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat hue;

/**
 The color's saturation component value in HSB color space.
 
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat saturation;

/**
 The color's brightness component value in HSB color space.
 
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat brightness;


/**
 The color's alpha component value.
 
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat alpha;


@end
