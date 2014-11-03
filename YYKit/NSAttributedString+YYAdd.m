//
//  NSAttributedString+RVAdd.m
//  TestCoreText
//
//  Created by ibireme on 14-5-21.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYTextDefine.h"
#import "NSAttributedString+YYAdd.h"
#import "UIFont+YYAdd.h"
#import "YYKitMacro.h"


SYNTH_DUMMY_CLASS(NSAttributedString_YYAdd)


@implementation NSMutableAttributedString (YYAdd)

#define _CTRange CFRangeMake(range.location, range.length)
#define _CTString ((CFMutableAttributedStringRef)self)
#define _CTSet(_name_, _value_) CFAttributedStringSetAttribute(_CTString, _CTRange, _name_, _value_)
#define _CTRemove(_name_) CFAttributedStringRemoveAttribute(_CTString, _CTRange, _name_)

- (void)setAttributeKey:(NSString *)key value:(id)value range:(NSRange)range {
    if (!key || [NSNull isEqual:key]) return;
    if (value && ![NSNull isEqual:value]) [self setAttributes:@{ key:value } range:range];
    else [self removeAttribute:key range:range];
}

- (void)removeAllAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

- (void)setFont:(UIFont *)font range:(NSRange)range {
    CTFontRef ctFont = [font CTFont];
    if (ctFont) {
        _CTSet(kCTFontAttributeName, ctFont);
        CFRelease(ctFont);
    } else _CTRemove(kCTFontAttributeName);
}

- (void)setColor:(UIColor *)color range:(NSRange)range {
    if (color) _CTSet(kCTForegroundColorAttributeName, color.CGColor);
    else _CTRemove(kCTForegroundColorAttributeName);
}

- (void)setColorFromContext:(BOOL)value range:(NSRange)range {
    if (value) _CTSet(kCTForegroundColorFromContextAttributeName, kCFBooleanTrue);
    else _CTRemove(kCTForegroundColorFromContextAttributeName);
}

- (void)setKern:(CGFloat)kern range:(NSRange)range {
    if (kern > 0) _CTSet(kCTKernAttributeName, (CFTypeRef) @(kern));
    else _CTRemove(kCTKernAttributeName);
}

- (void)setLigature:(YYTextLigature)ligature range:(NSRange)range {
    if (ligature) _CTSet(kCTLigatureAttributeName, (CFTypeRef) @(ligature));
    else _CTRemove(kCTLigatureAttributeName);
}

- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range {
    if (width > 0) _CTSet(kCTStrokeWidthAttributeName, (CFTypeRef) @(width));
    else _CTRemove(kCTStrokeWidthAttributeName);
}

- (void)setStrokeColor:(UIColor *)color range:(NSRange)range {
    if (color) _CTSet(kCTStrokeColorAttributeName, color.CGColor);
    else _CTRemove(kCTStrokeColorAttributeName);
}

- (void)setUnderlineColor:(UIColor *)color range:(NSRange)range {
    if (color) _CTSet(kCTUnderlineColorAttributeName, color.CGColor);
    else _CTRemove(kCTUnderlineColorAttributeName);
}

- (void)setUnderlineStyle:(YYTextUnderlineStyle)style range:(NSRange)range {
    if (style > 0) _CTSet(kCTUnderlineStyleAttributeName, (CFTypeRef) @(style));
    else _CTRemove(kCTUnderlineStyleAttributeName);
}

- (void)setSuperscript:(BOOL)value range:(NSRange)range {
    if (value) _CTSet(kCTSuperscriptAttributeName, (CFTypeRef) @(1));
    else _CTRemove(kCTSuperscriptAttributeName);
}

- (void)setSubscript:(BOOL)value range:(NSRange)range {
    if (value) _CTSet(kCTSuperscriptAttributeName, (CFTypeRef) @(-1));
    else _CTRemove(kCTSuperscriptAttributeName);
}

- (void)setVerticalForms:(BOOL)value range:(NSRange)range {
    if (value) _CTSet(kCTVerticalFormsAttributeName, kCFBooleanTrue);
    else _CTRemove(kCTVerticalFormsAttributeName);
}

- (void)setLanguage:(NSString *)language range:(NSRange)range {
    if (language) _CTSet(kCTLanguageAttributeName, (CFTypeRef)language);
    else _CTRemove(kCTLanguageAttributeName);
}

- (void)setParaStyle:(id)style range:(NSRange)range {
    if (!style) {
        _CTRemove((__bridge CFTypeRef)NSParagraphStyleAttributeName);
        _CTRemove(kCTParagraphStyleAttributeName);
    } else {
        if ([style isKindOfClass:[NSParagraphStyle class]]) {
            _CTSet((__bridge CFTypeRef)NSParagraphStyleAttributeName, (__bridge CFTypeRef)style);
        } else {
            _CTSet(kCTParagraphStyleAttributeName, (__bridge CFTypeRef)style);
        }
    }
}

- (void)setGlyphInfo:(CTGlyphInfoRef)glyphInfo range:(NSRange)range {
    if (glyphInfo) _CTSet(kCTGlyphInfoAttributeName, glyphInfo);
    else _CTRemove(kCTGlyphInfoAttributeName);
}

- (void)setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range {
    if (runDelegate) _CTSet(kCTRunDelegateAttributeName, runDelegate);
    else _CTRemove(kCTRunDelegateAttributeName);
}

@end
