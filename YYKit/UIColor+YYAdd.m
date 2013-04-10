//
//  UIColor+YYAdd.m
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import "UIColor+YYAdd.h"

#import "YYCoreMacro.h"
#import "NSString+YYAdd.h"
DUMMY_CLASS(UIColor_YYDebug)



void RGB2HSL(CGFloat r, CGFloat g, CGFloat b, CGFloat *h, CGFloat *s, CGFloat *l) {
    CGFloat v;
    CGFloat m;
    CGFloat vm;
    CGFloat r2, g2, b2;

    r /= 255;
    g /= 255;
    b /= 255;

    v = YYMAX3(r, g, b);
    m = YYMIN3(r, g, b);

    if ((*l = (m + v) / 2.0) <= 0.0) return;
    if ((*s = vm = v - m) > 0.0) {
        *s /= (*l <= 0.5) ? (v + m) :
            (2.0 - v - m);
    } else return;
    
    r2 = (v - r) / vm;
    g2 = (v - g) / vm;
    b2 = (v - b) / vm;

    if (r == v) *h = (g == m ? 5.0 + b2 : 1.0 - g2);
    else if (g == v) *h = (b == m ? 1.0 + r2 : 3.0 - b2);
    else *h = (r == m ? 3.0 + g2 : 5.0 - r2);

    *h /= 6;
}

void HSL2RGB(CGFloat h, CGFloat s, CGFloat l, CGFloat *r, CGFloat *g, CGFloat *b) {
    CGFloat v;
    v = (l <= 0.5) ? (l * (1.0 + s)) : (l + s - l * s);
    if (v <= 0) {
        *r = *g = *b = 0.0;
    } else {
        *r = *g = *b = 0.0;
        double m;
        double sv;
        int sextant;
        double fract, vsf, mid1, mid2;
        
        m = l + l - v;
        sv = (v - m) / v;
        h *= 6.0;
        sextant = h;
        fract = h - sextant;
        vsf = v * sv * fract;
        mid1 = m + vsf;
        mid2 = v - vsf;
        switch (sextant) {
            case 0: *r = v; *g = mid1; *b = m; break;
            case 1: *r = mid2; *g = v; *b = m; break;
            case 2: *r = m; *g = v; *b = mid1; break;
            case 3: *r = m; *g = mid2; *b = v; break;
            case 4: *r = mid1; *g = m; *b = v; break;
            case 5: *r = v; *g = m; *b = mid2; break;
        }
    }
    *r *= 255;
    *g *= 255;
    *b *= 255;
}

void RGB2HSB(CGFloat r, CGFloat g, CGFloat b, CGFloat *h, CGFloat *s, CGFloat *v) {
    float min, max, delta;
    min = YYMIN3(r, g, b);
    max = YYMAX3(r, g, b);
    *v = max;                                     // v
    delta = max - min;
    if (max != 0) *s = delta / max;               // s
    else {
        // r = g = b = 0		// s = 0, v is undefined
        *h = 0;//NAN; //-1;
        *s = 0;//NAN; //0;
        return;
    }
    if (r == max) *h = (g - b) / delta;           // between yellow & magenta
    else if (g == max) *h = 2 + (b - r) / delta;  // between cyan & yellow
    else *h = 4 + (r - g) / delta;                // between magenta & cyan
    *h /= 60;                                     // degrees
    if (*h < 0) *h += 1;
    if (isnan(*h)) h = 0; // should be NaN
}

void HSB2RGB(CGFloat h, CGFloat s, CGFloat v, CGFloat *r, CGFloat *g, CGFloat *b) {
    int i;
    float f, p, q, t;
    if (s == 0) {
        // achromatic (grey)
        *r = *g = *b = v;
        return;
    }
    h *= 60;               // sector 0 to 5
    i = floor(h);
    f = h - i;             // factorial part of h
    p = v * (1 - s);
    q = v * (1 - s * f);
    t = v * (1 - s * (1 - f) );
    switch (i) {
        case 0:
            *r = v;
            *g = t;
            *b = p;
            break;
        case 1:
            *r = q;
            *g = v;
            *b = p;
            break;
        case 2:
            *r = p;
            *g = v;
            *b = t;
            break;
        case 3:
            *r = p;
            *g = q;
            *b = v;
            break;
        case 4:
            *r = t;
            *g = p;
            *b = v;
            break;
        default:            // case 5:
            *r = v;
            *g = p;
            *b = q;
            if (isnan(s)) {
                *g = 0;
                *b = 0;
            }
            break;
    }
}

void HSB2HSL(CGFloat h, CGFloat s, CGFloat b, CGFloat *hh, CGFloat *ss, CGFloat *ll) {
    *hh = h;
    *ll = (2 - s) * b;
    *ss = s * b;
    *ss /= (*ll <= 1) ? (*ll) : 2 - (*ll);
    *ll /= 2;
}

void HSL2HSB(CGFloat h, CGFloat s, CGFloat l, CGFloat *hh, CGFloat *ss, CGFloat *bb) {
    *hh = h;
    l *= 2;
    s *= (l <= 1) ? l : 2 - l;
    *bb = (l + s) / 2;
    *ss = (2 * s) / (l + s);
}

void RGB2CMYK(CGFloat r, CGFloat g, CGFloat b, CGFloat *c, CGFloat *m, CGFloat *y, CGFloat *k) {
    if (r == 0 && g == 0 && b == 0) { // Pure black
        *c = 0; *m = 0; *y = 0; *k = 1;
        return;
    }

    *c = 1 - r;
    *m = 1 - g;
    *y = 1 - b;
    float min = YYMIN3(*c, *m, *y);
    *c = (*c - min) / (1 - min);
    *m = (*m - min) / (1 - min);
    *y = (*y - min) / (1 - min);
    *k = min;
}

void CMYK2RGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k, CGFloat *r, CGFloat *g, CGFloat *b) {
    float cyan = (c * (1 - k) + k);
    float magenta = (m * (1 - k) + k);
    float yellow = (y * (1 - k) + k);

    *r = 1 - cyan;
    *g = 1 - magenta;
    *b = 1 - yellow;
}

void RGB2YUV(CGFloat r, CGFloat g, CGFloat b, CGFloat *y, CGFloat *u, CGFloat *v) {
    if (y) *y = (0.299f * r + 0.587f * g + 0.114f * b);
    if (u && y) *u = ((b - *y) * 0.565f + 0.5);
    if (v && y) *v = ((r - *y) * 0.713f + 0.5);

    if (y) *y = YYMIN(1.0, YYMAX(0, *y));
    if (u) *u = YYMIN(1.0, YYMAX(0, *u));
    if (v) *v = YYMIN(1.0, YYMAX(0, *v));
}

void YUV2RGB(CGFloat y, CGFloat u, CGFloat v, CGFloat *r, CGFloat *g, CGFloat *b) {
    CGFloat Y = y;
    CGFloat U = u - 0.5;
    CGFloat V = v - 0.5;

    if (r) *r = (Y + 1.403f * V);
    if (g) *g = (Y - 0.344f * U - 0.714f * V);
    if (b) *b = (Y + 1.770f * U);

    if (r) *r = YYMIN(1.0, YYMAX(0, *r));
    if (g) *g = YYMIN(1.0, YYMAX(0, *g));
    if (b) *b = YYMIN(1.0, YYMAX(0, *b));
}


@implementation UIColor (YYAdd)

+ (UIColor *)colorWithHue:(CGFloat)hue
               saturation:(CGFloat)saturation
                lightness:(CGFloat)lightness
                    alpha:(CGFloat)alpha{
    CGFloat r,g,b;
    HSL2RGB(hue, saturation, lightness, &r, &g, &b);
    return UIColorRGBA(r, g, b, alpha);
}

+ (UIColor *)colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha{
    CGFloat r,g,b;
    CMYK2RGB(cyan, magenta, yellow, black, &r, &g, &b);
    return UIColorRGBA(r, g, b, alpha);
}

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return UIColorRGB(  ((rgbValue & 0xFF0000) >> 16) / 255.0f,
                        ((rgbValue & 0xFF00) >> 8) / 255.0f,
                        (rgbValue & 0xFF) / 255.0f);
}

+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue{
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


NSUInteger hexStrToInt(NSString *str){
    NSUInteger result = 0;
	sscanf([str UTF8String], "%X", &result);
	return result;
}

BOOL hexStrToRGBA(NSString *str,CGFloat *r,CGFloat *g,CGFloat *b,CGFloat *a){
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
	
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)
            *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else
            *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8)
            *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else
            *a = 1;
    }
    return YES;
}

+ (UIColor *)colorWithHexString:(NSString *)hexStr{
    CGFloat r,g,b,a;
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
        hex = [NSString stringWithFormat:stringFormat, (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f), (NSUInteger)(components[2] * 255.0f)];
    }

    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02x", (NSUInteger)(self.alpha * 255.0f)];
    }
    return hex;
}

- (BOOL)getHue:(CGFloat *)hue
    saturation:(CGFloat *)saturation
     lightness:(CGFloat *)lightness
         alpha:(CGFloat *)alpha {
    
    CGFloat r,g,b,a;
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
    
    CGFloat r,g,b,a;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) {
        return NO;
    }
    RGB2CMYK(r, g, b, cyan, magenta, yellow, black);
    *alpha = a;
    return YES;
}

- (CGFloat)red {
    return CGColorGetComponents(self.CGColor)[0];
}

- (CGFloat)green {
    return CGColorGetComponents(self.CGColor)[1];
}

- (CGFloat)blue {
    return CGColorGetComponents(self.CGColor)[2];
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
