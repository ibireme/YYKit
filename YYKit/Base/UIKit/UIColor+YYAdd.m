//
//  UIColor+YYAdd.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIColor+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYKitMacro.h"

YYSYNTH_DUMMY_CLASS(UIColor_YYAdd)


#define CLAMP_COLOR_VALUE(v) (v) = (v) < 0 ? 0 : (v) > 1 ? 1 : (v)

void YY_RGB2HSL(CGFloat r, CGFloat g, CGFloat b,
                CGFloat *h, CGFloat *s, CGFloat *l) {
    CLAMP_COLOR_VALUE(r);
    CLAMP_COLOR_VALUE(g);
    CLAMP_COLOR_VALUE(b);
    
    CGFloat max, min, delta, sum;
    max = fmaxf(r, fmaxf(g, b));
    min = fminf(r, fminf(g, b));
    delta = max - min;
    sum = max + min;
    
    *l = sum / 2;           // Lightness
    if (delta == 0) {       // No Saturation, so Hue is undefined (achromatic)
        *h = *s = 0;
        return;
    }
    *s = delta / (sum < 1 ? sum : 2 - sum);             // Saturation
    if (r == max) *h = (g - b) / delta / 6;             // color between y & m
    else if (g == max) *h = (2 + (b - r) / delta) / 6;  // color between c & y
    else *h = (4 + (r - g) / delta) / 6;                // color between m & y
    if (*h < 0) *h += 1;
}

void YY_HSL2RGB(CGFloat h, CGFloat s, CGFloat l,
                CGFloat *r, CGFloat *g, CGFloat *b) {
    CLAMP_COLOR_VALUE(h);
    CLAMP_COLOR_VALUE(s);
    CLAMP_COLOR_VALUE(l);
    
    if (s == 0) { // No Saturation, Hue is undefined (achromatic)
        *r = *g = *b = l;
        return;
    }
    
    CGFloat q;
    q = (l <= 0.5) ? (l * (1 + s)) : (l + s - (l * s));
    if (q <= 0) {
        *r = *g = *b = 0.0;
    } else {
        *r = *g = *b = 0;
        int sextant;
        CGFloat m, sv, fract, vsf, mid1, mid2;
        m = l + l - q;
        sv = (q - m) / q;
        if (h == 1) h = 0;
        h *= 6.0;
        sextant = h;
        fract = h - sextant;
        vsf = q * sv * fract;
        mid1 = m + vsf;
        mid2 = q - vsf;
        switch (sextant) {
            case 0: *r = q; *g = mid1; *b = m; break;
            case 1: *r = mid2; *g = q; *b = m; break;
            case 2: *r = m; *g = q; *b = mid1; break;
            case 3: *r = m; *g = mid2; *b = q; break;
            case 4: *r = mid1; *g = m; *b = q; break;
            case 5: *r = q; *g = m; *b = mid2; break;
        }
    }
}

void YY_RGB2HSB(CGFloat r, CGFloat g, CGFloat b,
                CGFloat *h, CGFloat *s, CGFloat *v) {
    CLAMP_COLOR_VALUE(r);
    CLAMP_COLOR_VALUE(g);
    CLAMP_COLOR_VALUE(b);
    
    CGFloat max, min, delta;
    max = fmax(r, fmax(g, b));
    min = fmin(r, fmin(g, b));
    delta = max - min;
    
    *v = max;               // Brightness
    if (delta == 0) {       // No Saturation, so Hue is undefined (achromatic)
        *h = *s = 0;
        return;
    }
    *s = delta / max;       // Saturation
    
    if (r == max) *h = (g - b) / delta / 6;             // color between y & m
    else if (g == max) *h = (2 + (b - r) / delta) / 6;  // color between c & y
    else *h = (4 + (r - g) / delta) / 6;                // color between m & c
    if (*h < 0) *h += 1;
}

void YY_HSB2RGB(CGFloat h, CGFloat s, CGFloat v,
                CGFloat *r, CGFloat *g, CGFloat *b) {
    CLAMP_COLOR_VALUE(h);
    CLAMP_COLOR_VALUE(s);
    CLAMP_COLOR_VALUE(v);
    
    if (s == 0) {
        *r = *g = *b = v; // No Saturation, so Hue is undefined (Achromatic)
    } else {
        int sextant;
        CGFloat f, p, q, t;
        if (h == 1) h = 0;
        h *= 6;
        sextant = floor(h);
        f = h - sextant;
        p = v * (1 - s);
        q = v * (1 - s * f);
        t = v * (1 - s * (1 - f));
        switch (sextant) {
            case 0: *r = v; *g = t; *b = p; break;
            case 1: *r = q; *g = v; *b = p; break;
            case 2: *r = p; *g = v; *b = t; break;
            case 3: *r = p; *g = q; *b = v; break;
            case 4: *r = t; *g = p; *b = v; break;
            case 5: *r = v; *g = p; *b = q; break;
        }
    }
}

void YY_RGB2CMYK(CGFloat r, CGFloat g, CGFloat b,
                 CGFloat *c, CGFloat *m, CGFloat *y, CGFloat *k) {
    CLAMP_COLOR_VALUE(r);
    CLAMP_COLOR_VALUE(g);
    CLAMP_COLOR_VALUE(b);
    
    *c = 1 - r;
    *m = 1 - g;
    *y = 1 - b;
    *k = fmin(*c, fmin(*m, *y));
    
    if (*k == 1) {
        *c = *m = *y = 0;   // Pure black
    } else {
        *c = (*c - *k) / (1 - *k);
        *m = (*m - *k) / (1 - *k);
        *y = (*y - *k) / (1 - *k);
    }
}

void YY_CMYK2RGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k,
                 CGFloat *r, CGFloat *g, CGFloat *b) {
    CLAMP_COLOR_VALUE(c);
    CLAMP_COLOR_VALUE(m);
    CLAMP_COLOR_VALUE(y);
    CLAMP_COLOR_VALUE(k);
    
    *r = (1 - c) * (1 - k);
    *g = (1 - m) * (1 - k);
    *b = (1 - y) * (1 - k);
}

void YY_HSB2HSL(CGFloat h, CGFloat s, CGFloat b,
                CGFloat *hh, CGFloat *ss, CGFloat *ll) {
    CLAMP_COLOR_VALUE(h);
    CLAMP_COLOR_VALUE(s);
    CLAMP_COLOR_VALUE(b);
    
    *hh = h;
    *ll = (2 - s) * b / 2;
    if (*ll <= 0.5) {
        *ss = (s) / ((2 - s));
    } else {
        *ss = (s * b) / (2 - (2 - s) * b);
    }
}

void YY_HSL2HSB(CGFloat h, CGFloat s, CGFloat l,
                CGFloat *hh, CGFloat *ss, CGFloat *bb) {
    CLAMP_COLOR_VALUE(h);
    CLAMP_COLOR_VALUE(s);
    CLAMP_COLOR_VALUE(l);
    
    *hh = h;
    if (l <= 0.5) {
        *bb = (s + 1) * l;
        *ss = (2 * s) / (s + 1);
    } else {
        *bb = l + s * (1 - l);
        *ss = (2 * s * (1 - l)) / *bb;
    }
}

@implementation UIColor (YYAdd)

+ (UIColor *)colorWithHue:(CGFloat)hue
               saturation:(CGFloat)saturation
                lightness:(CGFloat)lightness
                    alpha:(CGFloat)alpha {
    CGFloat r, g, b;
    YY_HSL2RGB(hue, saturation, lightness, &r, &g, &b);
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}
+ (UIColor *)colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha {
    CGFloat r, g, b;
    YY_CMYK2RGB(cyan, magenta, yellow, black, &r, &g, &b);
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue {
    return [UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24) / 255.0f
                           green:((rgbaValue & 0xFF0000) >> 16) / 255.0f
                            blue:((rgbaValue & 0xFF00) >> 8) / 255.0f
                           alpha:(rgbaValue & 0xFF) / 255.0f];
}

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}

- (uint32_t)rgbValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)rgbaValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [[str stringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

+ (instancetype)colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

- (NSString *)hexString {
    return [self hexStringWithAlpha:NO];
}

- (NSString *)hexStringWithAlpha {
    return [self hexStringWithAlpha:YES];
}

- (NSString *)hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx",
               (unsigned long)(self.alpha * 255.0 + 0.5)];
    }
    return hex;
}

- (UIColor *)colorByAddColor:(UIColor *)add blendMode:(CGBlendMode)blendMode {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    uint8_t pixel[4] = { 0 };
    CGContextRef context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, bitmapInfo);
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextSetBlendMode(context, blendMode);
    CGContextSetFillColorWithColor(context, add.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIColor colorWithRed:pixel[0] / 255.0f green:pixel[1] / 255.0f blue:pixel[2] / 255.0f alpha:pixel[3] / 255.0f];
}

- (UIColor *)colorByChangeHue:(CGFloat)h saturation:(CGFloat)s brightness:(CGFloat)b alpha:(CGFloat)a {
    CGFloat hh, ss, bb, aa;
    if (![self getHue:&hh saturation:&ss brightness:&bb alpha:&aa]) {
        return nil;
    }
    hh += h;
    ss += s;
    bb += b;
    aa += a;
    hh -= (int)hh;
    hh = hh < 0 ? hh + 1 : hh;
    ss = ss < 0 ? 0 : ss > 1 ? 1 : ss;
    bb = bb < 0 ? 0 : bb > 1 ? 1 : bb;
    aa = aa < 0 ? 0 : aa > 1 ? 1 : aa;
    return [UIColor colorWithHue:hh saturation:ss brightness:bb alpha:aa];
}

- (BOOL)getHue:(CGFloat *)hue
    saturation:(CGFloat *)saturation
     lightness:(CGFloat *)lightness
         alpha:(CGFloat *)alpha {
    CGFloat r, g, b, a;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) {
        return NO;
    }
    YY_RGB2HSL(r, g, b, hue, saturation, lightness);
    *alpha = a;
    return YES;
}

- (BOOL)getCyan:(CGFloat *)cyan
        magenta:(CGFloat *)magenta
         yellow:(CGFloat *)yellow
          black:(CGFloat *)black
          alpha:(CGFloat *)alpha {
    CGFloat r, g, b, a;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) {
        return NO;
    }
    YY_RGB2CMYK(r, g, b, cyan, magenta, yellow, black);
    *alpha = a;
    return YES;
}

- (CGFloat)red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)hue {
    CGFloat h = 0, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return h;
}

- (CGFloat)saturation {
    CGFloat h, s = 0, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return s;
}

- (CGFloat)brightness {
    CGFloat h, s, b = 0, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return b;
}

- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)colorSpaceString {
    CGColorSpaceModel model =  CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    switch (model) {
        case kCGColorSpaceModelUnknown:
            return @"kCGColorSpaceModelUnknown";
            
        case kCGColorSpaceModelMonochrome:
            return @"kCGColorSpaceModelMonochrome";
            
        case kCGColorSpaceModelRGB:
            return @"kCGColorSpaceModelRGB";
            
        case kCGColorSpaceModelCMYK:
            return @"kCGColorSpaceModelCMYK";
            
        case kCGColorSpaceModelLab:
            return @"kCGColorSpaceModelLab";
            
        case kCGColorSpaceModelDeviceN:
            return @"kCGColorSpaceModelDeviceN";
            
        case kCGColorSpaceModelIndexed:
            return @"kCGColorSpaceModelIndexed";
            
        case kCGColorSpaceModelPattern:
            return @"kCGColorSpaceModelPattern";
            
        default:
            return @"ColorSpaceInvalid";
    }
}

@end
