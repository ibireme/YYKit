//
//  UIColor+YYAdd.m
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import "UIColor+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYKitMacro.h"

DUMMY_CLASS(UIColor_YYDebug)


#define CLAMP_COLOR_VALUE(v) (v) = (v) < 0 ? 0 : (v) > 1 ? 1 : (v)

void RGB2HSL(CGFloat r, CGFloat g, CGFloat b,
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
    if      (r == max) *h = (g - b) / delta / 6;        // color between y & m
    else if (g == max) *h = (2 + (b - r) / delta) / 6;  // color between c & y
    else               *h = (4 + (r - g) / delta) / 6;  // color between m & y
    if (*h < 0) *h += 1;
}


void HSL2RGB(CGFloat h, CGFloat s, CGFloat l,
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


void RGB2HSB(CGFloat r, CGFloat g, CGFloat b,
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


void HSB2RGB(CGFloat h, CGFloat s, CGFloat v,
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
        t = v * (1 - s * (1 - f) );
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


void RGB2CMYK(CGFloat r, CGFloat g, CGFloat b,
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


void CMYK2RGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k,
              CGFloat *r, CGFloat *g, CGFloat *b) {
    CLAMP_COLOR_VALUE(c);
    CLAMP_COLOR_VALUE(m);
    CLAMP_COLOR_VALUE(y);
    CLAMP_COLOR_VALUE(k);
    
    *r = (1 - c) * (1 - k);
    *g = (1 - m) * (1 - k);
    *b = (1 - y) * (1 - k);
}


void HSB2HSL(CGFloat h, CGFloat s, CGFloat b,
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


void HSL2HSB(CGFloat h, CGFloat s, CGFloat l,
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
    HSL2RGB(hue, saturation, lightness, &r, &g, &b);
    return UIColorRGBA(r, g, b, alpha);
}

+ (UIColor *)colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha {
    CGFloat r, g, b;
    CMYK2RGB(cyan, magenta, yellow, black, &r, &g, &b);
    return UIColorRGBA(r, g, b, alpha);
}

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return UIColorRGB(  ((rgbValue & 0xFF0000) >> 16) / 255.0f,
                        ((rgbValue & 0xFF00) >> 8) / 255.0f,
                        (rgbValue & 0xFF) / 255.0f);
}

+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue {
    return UIColorRGBA( ((rgbaValue & 0xFF000000) >> 24) / 255.0f,
                        ((rgbaValue & 0xFF0000) >> 16) / 255.0f,
                        ((rgbaValue & 0xFF00) >> 8) / 255.0f,
                        (rgbaValue & 0xFF) / 255.0f);
}

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha {
    return UIColorRGBA(  ((rgbValue & 0xFF0000) >> 16) / 255.0f,
                         ((rgbValue & 0xFF00) >> 8) / 255.0f,
                         (rgbValue & 0xFF) / 255.0f,
                         alpha);
}

- (uint32_t)rgbValue {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    uint8_t red = components[0] * 255;
    uint8_t green = components[1] * 255;
    uint8_t blue = components[2] * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)rgbaValue {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    uint8_t red = components[0] * 255;
    uint8_t green = components[1] * 255;
    uint8_t blue = components[2] * 255;
    uint8_t alpha = components[3] * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}


static inline NSUInteger hexStrToInt(NSString *str) {
    NSUInteger result = 0;
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
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)
          *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8)
          *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

+ (UIColor *)colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return UIColorRGBA(r, g, b, a);
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
        hex = [hex stringByAppendingFormat:@"%02x",
               (NSUInteger)(self.alpha * 255.0f)];
    }
    return hex;
}

- (BOOL)getHue:(CGFloat *)hue
    saturation:(CGFloat *)saturation
     lightness:(CGFloat *)lightness
         alpha:(CGFloat *)alpha {
    CGFloat r, g, b, a;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) {
        return NO;
    }
    RGB2HSL(r, g, b, hue, saturation, lightness);
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
    RGB2CMYK(r, g, b, cyan, magenta, yellow, black);
    *alpha = a;
    return YES;
}

- (CGFloat)red {
	CGColorRef color = self.CGColor;
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color))
        != kCGColorSpaceModelRGB) {
		return 0;
	}
	return CGColorGetComponents(color)[0];
}

- (CGFloat)green {
	CGColorRef color = self.CGColor;
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color))
        != kCGColorSpaceModelRGB) {
		return 0;
	}
	return CGColorGetComponents(color)[1];
}

- (CGFloat)blue {
	CGColorRef color = self.CGColor;
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color))
        != kCGColorSpaceModelRGB) {
		return 0;
	}
	return CGColorGetComponents(color)[2];
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)hue {
    CGFloat hue = 0, sat, lum, alpha;
    [self getHue:&hue saturation:&sat brightness:&lum alpha:&alpha];
    return hue;
}

- (CGFloat)saturation {
    CGFloat hue, sat = 0, bright, alpha;
    [self getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
    return sat;
}

- (CGFloat)brightness {
    CGFloat hue, sat, bright = 0, alpha;
    [self getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
    return bright;
}

@end
