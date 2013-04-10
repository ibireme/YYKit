//
//  UIColor+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

/// All the value is a float number in the range `0.0` to `1.0`.
/// RGB HSL HSB(HSV) CMYK YUV
extern void RGB2HSL(CGFloat r, CGFloat g, CGFloat b, CGFloat *h, CGFloat *s, CGFloat *l);
extern void HSL2RGB(CGFloat h, CGFloat s, CGFloat l, CGFloat *r, CGFloat *g, CGFloat *b);
extern void RGB2HSB(CGFloat r, CGFloat g, CGFloat b, CGFloat *h, CGFloat *s, CGFloat *v);
extern void HSB2RGB(CGFloat h, CGFloat s, CGFloat v, CGFloat *r, CGFloat *g, CGFloat *b);
extern void HSB2HSL(CGFloat h, CGFloat s, CGFloat b, CGFloat *hh, CGFloat *ss, CGFloat *ll);
extern void HSL2HSB(CGFloat h, CGFloat s, CGFloat l, CGFloat *hh, CGFloat *ss, CGFloat *bb);
extern void RGB2CMYK(CGFloat r, CGFloat g, CGFloat b, CGFloat *c, CGFloat *m, CGFloat *y, CGFloat *k);
extern void CMYK2RGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k, CGFloat *r, CGFloat *g, CGFloat *b);
extern void RGB2YUV(CGFloat r, CGFloat g, CGFloat b, CGFloat *y, CGFloat *u, CGFloat *v);
extern void YUV2RGB(CGFloat y, CGFloat u, CGFloat v, CGFloat *r, CGFloat *g, CGFloat *b);

#define UIColorRGB(r, g, b)     [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
#define UIColorHSB(h, s, b)     [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:1]
#define UIColorHSBA(h, s, b, a) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:(a)]
#define UIColorHSL(h, s, l)     [UIColor colorWithHue:(h) saturation:(s) lightness:(l) alpha:1]
#define UIColorHSLA(h, s, l, a) [UIColor colorWithHue:(h) saturation:(s) lightness:(l) alpha:(a)]
#define UIColorCMYK(c, m, y, k) [UIColor colorWithCyan:(c) magenta:(m) yellow:(y) black:(k) alpha:1]
#define UIColorCMYKA(c,m,y,k,a) [UIColor colorWithCyan:(c) magenta:(m) yellow:(y) black:(k) alpha:(a)]


/**
 * value from 0.0 to 1.0
 *
 * RGB      :Red, Green, Blue
 * HSB(HSV) :Hue, Saturation, Brightness(Value)
 * HSL      :Hue, Saturation, Lightness
 * CMYK     :Cyan, Magenta, Yellow, BlacK
 * YUV(YCbCr/YPbPr): Luminance, Chrominance, Chroma
 * 
 * Apple use RGB & HSB default
 *
 * R=G=B    : Hue=NaN
 * R=G=B=0  : Hue=NaN, Saturation=NaN
 * when value is NaN, I set it to Zero
 */
@interface UIColor (YYAdd)

/// HSL with Alpha, value between 0.0 and 1.0
+ (UIColor *)colorWithHue:(CGFloat)hue
               saturation:(CGFloat)saturation
                lightness:(CGFloat)lightness
                    alpha:(CGFloat)alpha;

/// CMYK with Alpha, value between 0.0 and 1.0
+ (UIColor *)colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha;

////////////////////////////////////////////////////////////////////////////////
/// 0xFF00AA
+ (UIColor *) colorWithRGB:(uint32_t)rgbValue;

/// 0xFF00AAFF
+ (UIColor *) colorWithRGBA:(uint32_t)rgbaValue;

/// 0xFF00AA 0.5
+ (UIColor *) colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/// 0xFF00AA
- (uint32_t)rgbValue;

/// 0xFF00AAFF
- (uint32_t)rgbaValue;


////////////////////////////////////////////////////////////////////////////////
/**
 * #00FF00  0x00FF00 #FF00AAff #fff #0F0f  All OK~
 * return color or nil
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr;

///return "00ff23" or nil
- (NSString *)hexString;

///return "00ff23ff" or nil
- (NSString *)hexStringWithAlpha;

////////////////////////////////////////////////////////////////////////////////

/// HSL with Alpha, value between 0.0 and 1.0
- (BOOL)getHue:(CGFloat *)hue
    saturation:(CGFloat *)saturation
     lightness:(CGFloat *)lightness
         alpha:(CGFloat *)alpha;

/// CMYK with Alpha, value between 0.0 and 1.0
- (BOOL)getCyan:(CGFloat *)cyan
        magenta:(CGFloat *)magenta
         yellow:(CGFloat *)yellow
          black:(CGFloat *)black
          alpha:(CGFloat *)alpha;



////////////////////////////////////////////////////////////////////////////////
@property (nonatomic, readonly) CGFloat alpha;

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;

@property (nonatomic, readonly) CGFloat hue;
@property (nonatomic, readonly) CGFloat saturation;
@property (nonatomic, readonly) CGFloat brightness;

@end
