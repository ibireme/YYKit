//
//  NSAttributedString+YYText.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/10/7.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSAttributedString+YYText.h"
#import "YYKitMacro.h"
#import "UIDevice+YYAdd.h"
#import "UIFont+YYAdd.h"
#import "NSParagraphStyle+YYText.h"
#import "YYTextArchiver.h"
#import "YYTextRunDelegate.h"
#import "YYAnimatedImageView.h"
#import "YYTextUtilities.h"
#import <CoreFoundation/CoreFoundation.h>

YYSYNTH_DUMMY_CLASS(NSAttributedString_YYText)


@implementation NSAttributedString (YYText)

- (NSData *)archiveToData {
    NSData *data = nil;
    @try {
        data = [YYTextArchiver archivedDataWithRootObject:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return data;
}

+ (instancetype)unarchiveFromData:(NSData *)data {
    NSAttributedString *one = nil;
    @try {
        one = [YYTextUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return one;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)index {
    if (self.length > 0 && index == self.length) index--;
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (NSDictionary *)attributes {
    return [self attributesAtIndex:0];
}

- (UIFont *)font {
    return [self fontAtIndex:0];
}

- (UIFont *)fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self attribute:NSFontAttributeName atIndex:index];
    if (kSystemVersion <= 6) {
        if (font) {
            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) {
                font = [UIFont fontWithCTFont:(CTFontRef)font];
            }
        }
    }
    return font;
}

- (NSNumber *)kern {
    return [self kernAtIndex:0];
}

- (NSNumber *)kernAtIndex:(NSUInteger)index {
    return [self attribute:NSKernAttributeName atIndex:index];
}

- (UIColor *)color {
    return [self colorAtIndex:0];
}

- (UIColor *)colorAtIndex:(NSUInteger)index {
    UIColor *color = [self attribute:NSForegroundColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self attribute:(NSString *)kCTForegroundColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (UIColor *)backgroundColor {
    return [self backgroundColorAtIndex:0];
}

- (UIColor *)backgroundColorAtIndex:(NSUInteger)index {
    return [self attribute:NSBackgroundColorAttributeName atIndex:index];
}

- (NSNumber *)strokeWidth {
    return [self strokeWidthAtIndex:0];
}

- (NSNumber *)strokeWidthAtIndex:(NSUInteger)index {
    return [self attribute:NSStrokeWidthAttributeName atIndex:index];
}

- (UIColor *)strokeColor {
    return [self strokeColorAtIndex:0];
}

- (UIColor *)strokeColorAtIndex:(NSUInteger)index {
    UIColor *color = [self attribute:NSStrokeColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self attribute:(NSString *)kCTStrokeColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSShadow *)shadow {
    return [self shadowAtIndex:0];
}

- (NSShadow *)shadowAtIndex:(NSUInteger)index {
    return [self attribute:NSShadowAttributeName atIndex:index];
}

- (NSUnderlineStyle)strikethroughStyle {
    return [self strikethroughStyleAtIndex:0];
}

- (NSUnderlineStyle)strikethroughStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self attribute:NSStrikethroughStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)strikethroughColor {
    return [self strikethroughColorAtIndex:0];
}

- (UIColor *)strikethroughColorAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSStrikethroughColorAttributeName atIndex:index];
    }
    return nil;
}

- (NSUnderlineStyle)underlineStyle {
    return [self underlineStyleAtIndex:0];
}

- (NSUnderlineStyle)underlineStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self attribute:NSUnderlineStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)underlineColor {
    return [self underlineColorAtIndex:0];
}

- (UIColor *)underlineColorAtIndex:(NSUInteger)index {
    UIColor *color = nil;
    if (kSystemVersion >= 7) {
        color = [self attribute:NSUnderlineColorAttributeName atIndex:index];
    }
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self attribute:(NSString *)kCTUnderlineColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSNumber *)ligature {
    return [self ligatureAtIndex:0];
}

- (NSNumber *)ligatureAtIndex:(NSUInteger)index {
    return [self attribute:NSLigatureAttributeName atIndex:index];
}

- (NSString *)textEffect {
    return [self textEffectAtIndex:0];
}

- (NSString *)textEffectAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSTextEffectAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)obliqueness {
    return [self obliquenessAtIndex:0];
}

- (NSNumber *)obliquenessAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSObliquenessAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)expansion {
    return [self expansionAtIndex:0];
}

- (NSNumber *)expansionAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSExpansionAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)baselineOffset {
    return [self baselineOffsetAtIndex:0];
}

- (NSNumber *)baselineOffsetAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSBaselineOffsetAttributeName atIndex:index];
    }
    return nil;
}

- (BOOL)verticalGlyphForm {
    return [self verticalGlyphFormAtIndex:0];
}

- (BOOL)verticalGlyphFormAtIndex:(NSUInteger)index {
    NSNumber *num = [self attribute:NSVerticalGlyphFormAttributeName atIndex:index];
    return num.boolValue;
}

- (NSString *)language {
    return [self languageAtIndex:0];
}

- (NSString *)languageAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:(id)kCTLanguageAttributeName atIndex:index];
    }
    return nil;
}

- (NSArray *)writingDirection {
    return [self writingDirectionAtIndex:0];
}

- (NSArray *)writingDirectionAtIndex:(NSUInteger)index {
    return [self attribute:(id)kCTWritingDirectionAttributeName atIndex:index];
}

- (NSParagraphStyle *)paragraphStyle {
    return [self paragraphStyleAtIndex:0];
}

- (NSParagraphStyle *)paragraphStyleAtIndex:(NSUInteger)index {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    NSParagraphStyle *style = [self attribute:NSParagraphStyleAttributeName atIndex:index];
    if (style) {
        if (CFGetTypeID((__bridge CFTypeRef)(style)) == CTParagraphStyleGetTypeID()) { \
            style = [NSParagraphStyle styleWithCTStyle:(__bridge CTParagraphStyleRef)(style)];
        }
    }
    return style;
}

#define ParagraphAttribute(_attr_) \
NSParagraphStyle *style = self.paragraphStyle; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

#define ParagraphAttributeAtIndex(_attr_) \
NSParagraphStyle *style = [self paragraphStyleAtIndex:index]; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

- (NSTextAlignment)alignment {
    ParagraphAttribute(alignment);
}

- (NSLineBreakMode)lineBreakMode {
    ParagraphAttribute(lineBreakMode);
}

- (CGFloat)lineSpacing {
    ParagraphAttribute(lineSpacing);
}

- (CGFloat)paragraphSpacing {
    ParagraphAttribute(paragraphSpacing);
}

- (CGFloat)paragraphSpacingBefore {
    ParagraphAttribute(paragraphSpacingBefore);
}

- (CGFloat)firstLineHeadIndent {
    ParagraphAttribute(firstLineHeadIndent);
}

- (CGFloat)headIndent {
    ParagraphAttribute(headIndent);
}

- (CGFloat)tailIndent {
    ParagraphAttribute(tailIndent);
}

- (CGFloat)minimumLineHeight {
    ParagraphAttribute(minimumLineHeight);
}

- (CGFloat)maximumLineHeight {
    ParagraphAttribute(maximumLineHeight);
}

- (CGFloat)lineHeightMultiple {
    ParagraphAttribute(lineHeightMultiple);
}

- (NSWritingDirection)baseWritingDirection {
    ParagraphAttribute(baseWritingDirection);
}

- (float)hyphenationFactor {
    ParagraphAttribute(hyphenationFactor);
}

- (CGFloat)defaultTabInterval {
    if (!kiOS7Later) return 0;
    ParagraphAttribute(defaultTabInterval);
}

- (NSArray *)tabStops {
    if (!kiOS7Later) return nil;
    ParagraphAttribute(tabStops);
}

- (NSTextAlignment)alignmentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(alignment);
}

- (NSLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineBreakMode);
}

- (CGFloat)lineSpacingAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineSpacing);
}

- (CGFloat)paragraphSpacingAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(paragraphSpacing);
}

- (CGFloat)paragraphSpacingBeforeAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(paragraphSpacingBefore);
}

- (CGFloat)firstLineHeadIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(firstLineHeadIndent);
}

- (CGFloat)headIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(headIndent);
}

- (CGFloat)tailIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(tailIndent);
}

- (CGFloat)minimumLineHeightAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(minimumLineHeight);
}

- (CGFloat)maximumLineHeightAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(maximumLineHeight);
}

- (CGFloat)lineHeightMultipleAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineHeightMultiple);
}

- (NSWritingDirection)baseWritingDirectionAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(baseWritingDirection);
}

- (float)hyphenationFactorAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(hyphenationFactor);
}

- (CGFloat)defaultTabIntervalAtIndex:(NSUInteger)index {
    if (!kiOS7Later) return 0;
    ParagraphAttributeAtIndex(defaultTabInterval);
}

- (NSArray *)tabStopsAtIndex:(NSUInteger)index {
    if (!kiOS7Later) return nil;
    ParagraphAttributeAtIndex(tabStops);
}

#undef ParagraphAttribute
#undef ParagraphAttributeAtIndex

- (YYTextShadow *)textShadow {
    return [self textShadowAtIndex:0];
}

- (YYTextShadow *)textShadowAtIndex:(NSUInteger)index {
    return [self attribute:YYTextShadowAttributeName atIndex:index];
}

- (YYTextShadow *)textInnerShadow {
    return [self textInnerShadowAtIndex:0];
}

- (YYTextShadow *)textInnerShadowAtIndex:(NSUInteger)index {
    return [self attribute:YYTextInnerShadowAttributeName atIndex:index];
}

- (YYTextDecoration *)textUnderline {
    return [self textUnderlineAtIndex:0];
}

- (YYTextDecoration *)textUnderlineAtIndex:(NSUInteger)index {
    return [self attribute:YYTextUnderlineAttributeName atIndex:index];
}

- (YYTextDecoration *)textStrikethrough {
    return [self textStrikethroughAtIndex:0];
}

- (YYTextDecoration *)textStrikethroughAtIndex:(NSUInteger)index {
    return [self attribute:YYTextStrikethroughAttributeName atIndex:index];
}

- (YYTextBorder *)textBorder {
    return [self textBorderAtIndex:0];
}

- (YYTextBorder *)textBorderAtIndex:(NSUInteger)index {
    return [self attribute:YYTextBorderAttributeName atIndex:index];
}

- (YYTextBorder *)textBackgroundBorder {
    return [self textBackgroundBorderAtIndex:0];
}

- (YYTextBorder *)textBackgroundBorderAtIndex:(NSUInteger)index {
    return [self attribute:YYTextBackedStringAttributeName atIndex:index];
}

- (CGAffineTransform)textGlyphTransform {
    return [self textGlyphTransformAtIndex:0];
}

- (CGAffineTransform)textGlyphTransformAtIndex:(NSUInteger)index {
    NSValue *value = [self attribute:YYTextGlyphTransformAttributeName atIndex:index];
    if (!value) return CGAffineTransformIdentity;
    return [value CGAffineTransformValue];
}

- (NSString *)plainTextForRange:(NSRange)range {
    if (range.location == NSNotFound ||range.length == NSNotFound) return nil;
    NSMutableString *result = [NSMutableString string];
    if (range.length == 0) return result;
    NSString *string = self.string;
    [self enumerateAttribute:YYTextBackedStringAttributeName inRange:range options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        YYTextBackedString *backed = value;
        if (backed && backed.string) {
            [result appendString:backed.string];
        } else {
            [result appendString:[string substringWithRange:range]];
        }
    }];
    return result;
}

+ (NSMutableAttributedString *)attachmentStringWithContent:(id)content
                                               contentMode:(UIViewContentMode)contentMode
                                                     width:(CGFloat)width
                                                    ascent:(CGFloat)ascent
                                                   descent:(CGFloat)descent {
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    
    YYTextAttachment *attach = [YYTextAttachment new];
    attach.content = content;
    attach.contentMode = contentMode;
    [atr setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = width;
    delegate.ascent = ascent;
    delegate.descent = descent;
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    return atr;
}

+ (NSMutableAttributedString *)attachmentStringWithContent:(id)content
                                               contentMode:(UIViewContentMode)contentMode
                                            attachmentSize:(CGSize)attachmentSize
                                               alignToFont:(UIFont *)font
                                                 alignment:(YYTextVerticalAlignment)alignment {
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    
    YYTextAttachment *attach = [YYTextAttachment new];
    attach.content = content;
    attach.contentMode = contentMode;
    [atr setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = attachmentSize.width;
    switch (alignment) {
        case YYTextVerticalAlignmentTop: {
            delegate.ascent = font.ascender;
            delegate.descent = attachmentSize.height - font.ascender;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = attachmentSize.height;
            }
        } break;
        case YYTextVerticalAlignmentCenter: {
            CGFloat fontHeight = font.ascender - font.descender;
            CGFloat yOffset = font.ascender - fontHeight * 0.5;
            delegate.ascent = attachmentSize.height * 0.5 + yOffset;
            delegate.descent = attachmentSize.height - delegate.ascent;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = attachmentSize.height;
            }
        } break;
        case YYTextVerticalAlignmentBottom: {
            delegate.ascent = attachmentSize.height + font.descender;
            delegate.descent = -font.descender;
            if (delegate.ascent < 0) {
                delegate.ascent = 0;
                delegate.descent = attachmentSize.height;
            }
        } break;
        default: {
            delegate.ascent = attachmentSize.height;
            delegate.descent = 0;
        } break;
    }
    
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    return atr;
}

+ (NSMutableAttributedString *)attachmentStringWithEmojiImage:(UIImage *)image
                                                     fontSize:(CGFloat)fontSize {
    if (!image || fontSize <= 0) return nil;
    
    BOOL hasAnim = NO;
    if (image.images.count > 1) {
        hasAnim = YES;
    } else if ([image conformsToProtocol:@protocol(YYAnimatedImage)]) {
        id <YYAnimatedImage> ani = (id)image;
        if (ani.animatedImageFrameCount > 1) hasAnim = YES;
    }
    
    CGFloat ascent = YYEmojiGetAscentWithFontSize(fontSize);
    CGFloat descent = YYEmojiGetDescentWithFontSize(fontSize);
    CGRect bounding = YYEmojiGetGlyphBoundingRectWithFontSize(fontSize);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width + 2 * bounding.origin.x;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), bounding.origin.x, descent + bounding.origin.y, bounding.origin.x);
    if (hasAnim) {
        YYAnimatedImageView *view = [YYAnimatedImageView new];
        view.frame = bounding;
        view.image = image;
        view.contentMode = UIViewContentModeScaleAspectFit;
        attachment.content = view;
    } else {
        attachment.content = image;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

- (NSRange)rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (BOOL)isSharedAttributesInAllRange {
    __block BOOL shared = YES;
    __block NSDictionary *firstAttrs = nil;
    [self enumerateAttributesInRange:self.rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (range.location == 0) {
            firstAttrs = attrs;
        } else {
            if (firstAttrs.count != attrs.count) {
                shared = NO;
                *stop = YES;
            } else if (firstAttrs) {
                if (![firstAttrs isEqualToDictionary:attrs]) {
                    shared = NO;
                    *stop = YES;
                }
            }
        }
    }];
    return shared;
}

- (BOOL)canDrawWithUIKit {
    static NSMutableSet *failSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        failSet = [NSMutableSet new];
        [failSet addObject:(id)kCTGlyphInfoAttributeName];
        [failSet addObject:(id)kCTCharacterShapeAttributeName];
        if (kiOS7Later) {
            [failSet addObject:(id)kCTLanguageAttributeName];
        }
        [failSet addObject:(id)kCTRunDelegateAttributeName];
        [failSet addObject:(id)kCTBaselineClassAttributeName];
        [failSet addObject:(id)kCTBaselineInfoAttributeName];
        [failSet addObject:(id)kCTBaselineReferenceInfoAttributeName];
        if (kiOS8Later) {
            [failSet addObject:(id)kCTRubyAnnotationAttributeName];
        }
        [failSet addObject:YYTextShadowAttributeName];
        [failSet addObject:YYTextInnerShadowAttributeName];
        [failSet addObject:YYTextUnderlineAttributeName];
        [failSet addObject:YYTextStrikethroughAttributeName];
        [failSet addObject:YYTextBorderAttributeName];
        [failSet addObject:YYTextBackgroundBorderAttributeName];
        [failSet addObject:YYTextBlockBorderAttributeName];
        [failSet addObject:YYTextAttachmentAttributeName];
        [failSet addObject:YYTextHighlightAttributeName];
        [failSet addObject:YYTextGlyphTransformAttributeName];
    });
    
#define Fail { result = NO; *stop = YES; return; }
    __block BOOL result = YES;
    [self enumerateAttributesInRange:self.rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (attrs.count == 0) return;
        for (NSString *str in attrs.allKeys) {
            if ([failSet containsObject:str]) Fail;
        }
        if (!kiOS7Later) {
            UIFont *font = attrs[NSFontAttributeName];
            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) Fail;
        }
        if (attrs[(id)kCTForegroundColorAttributeName] && !attrs[NSForegroundColorAttributeName]) Fail;
        if (attrs[(id)kCTStrokeColorAttributeName] && !attrs[NSStrokeColorAttributeName]) Fail;
        if (attrs[(id)kCTUnderlineColorAttributeName]) {
            if (!kiOS7Later) Fail;
            if (!attrs[NSUnderlineColorAttributeName]) Fail;
        }
        NSParagraphStyle *style = attrs[NSParagraphStyleAttributeName];
        if (style && CFGetTypeID((__bridge CFTypeRef)(style)) == CTParagraphStyleGetTypeID()) Fail;
    }];
    return result;
#undef Fail
}

@end

@implementation NSMutableAttributedString (YYText)

- (void)setAttributes:(NSDictionary *)attributes {
    if (attributes == (id)[NSNull null]) attributes = nil;
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setAttribute:key value:obj];
    }];
}

- (void)setAttribute:(NSString *)name value:(id)value {
    [self setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

#pragma mark - Property Setter

- (void)setFont:(UIFont *)font {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setKern:(NSNumber *)kern {
    [self setKern:kern range:NSMakeRange(0, self.length)];
}

- (void)setColor:(UIColor *)color {
    [self setColor:color range:NSMakeRange(0, self.length)];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self setBackgroundColor:backgroundColor range:NSMakeRange(0, self.length)];
}

- (void)setStrokeWidth:(NSNumber *)strokeWidth {
    [self setStrokeWidth:strokeWidth range:NSMakeRange(0, self.length)];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    [self setStrokeColor:strokeColor range:NSMakeRange(0, self.length)];
}

- (void)setShadow:(NSShadow *)shadow {
    [self setShadow:shadow range:NSMakeRange(0, self.length)];
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle {
    [self setStrikethroughStyle:strikethroughStyle range:NSMakeRange(0, self.length)];
}

- (void)setStrikethroughColor:(UIColor *)strikethroughColor {
    [self setStrokeColor:strikethroughColor range:NSMakeRange(0, self.length)];
}

- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle {
    [self setUnderlineStyle:underlineStyle range:NSMakeRange(0, self.length)];
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    [self setUnderlineColor:underlineColor range:NSMakeRange(0, self.length)];
}

- (void)setLigature:(NSNumber *)ligature {
    [self setLigature:ligature range:NSMakeRange(0, self.length)];
}

- (void)setTextEffect:(NSString *)textEffect {
    [self setTextEffect:textEffect range:NSMakeRange(0, self.length)];
}

- (void)setObliqueness:(NSNumber *)obliqueness {
    [self setObliqueness:obliqueness range:NSMakeRange(0, self.length)];
}

- (void)setExpansion:(NSNumber *)expansion {
    [self setExpansion:expansion range:NSMakeRange(0, self.length)];
}

- (void)setBaselineOffset:(NSNumber *)baselineOffset {
    [self setBaselineOffset:baselineOffset range:NSMakeRange(0, self.length)];
}

- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm {
    [self setVerticalGlyphForm:verticalGlyphForm range:NSMakeRange(0, self.length)];
}

- (void)setLanguage:(NSString *)language {
    [self setLanguage:language range:NSMakeRange(0, self.length)];
}

- (void)setWritingDirection:(NSArray *)writingDirection {
    [self setWritingDirection:writingDirection range:NSMakeRange(0, self.length)];
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self setParagraphStyle:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)setAlignment:(NSTextAlignment)alignment {
    [self setAlignment:alignment range:NSMakeRange(0, self.length)];
}

- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [self setBaseWritingDirection:baseWritingDirection range:NSMakeRange(0, self.length)];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    [self setLineSpacing:lineSpacing range:NSMakeRange(0, self.length)];
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    [self setParagraphSpacing:paragraphSpacing range:NSMakeRange(0, self.length)];
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self setParagraphSpacing:paragraphSpacingBefore range:NSMakeRange(0, self.length)];
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self setFirstLineHeadIndent:firstLineHeadIndent range:NSMakeRange(0, self.length)];
}

- (void)setHeadIndent:(CGFloat)headIndent {
    [self setHeadIndent:headIndent range:NSMakeRange(0, self.length)];
}

- (void)setTailIndent:(CGFloat)tailIndent {
    [self setTailIndent:tailIndent range:NSMakeRange(0, self.length)];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self setLineBreakMode:lineBreakMode range:NSMakeRange(0, self.length)];
}

- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight {
    [self setMinimumLineHeight:minimumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight {
    [self setMaximumLineHeight:maximumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self setLineHeightMultiple:lineHeightMultiple range:NSMakeRange(0, self.length)];
}

- (void)setHyphenationFactor:(float)hyphenationFactor {
    [self setHyphenationFactor:hyphenationFactor range:NSMakeRange(0, self.length)];
}

- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval {
    [self setDefaultTabInterval:defaultTabInterval range:NSMakeRange(0, self.length)];
}

- (void)setTabStops:(NSArray *)tabStops {
    [self setTabStops:tabStops range:NSMakeRange(0, self.length)];
}

- (void)setTextShadow:(YYTextShadow *)textShadow {
    [self setTextShadow:textShadow range:NSMakeRange(0, self.length)];
}

- (void)setTextInnerShadow:(YYTextShadow *)textInnerShadow {
    [self setTextInnerShadow:textInnerShadow range:NSMakeRange(0, self.length)];
}

- (void)setTextUnderline:(YYTextDecoration *)textUnderline {
    [self setTextUnderline:textUnderline range:NSMakeRange(0, self.length)];
}

- (void)setTextStrikethrough:(YYTextDecoration *)textStrikethrough {
    [self setTextStrikethrough:textStrikethrough range:NSMakeRange(0, self.length)];
}

- (void)setTextBorder:(YYTextBorder *)textBorder {
    [self setTextBorder:textBorder range:NSMakeRange(0, self.length)];
}

- (void)setTextBackgroundBorder:(YYTextBorder *)textBackgroundBorder {
    [self setTextBackgroundBorder:textBackgroundBorder range:NSMakeRange(0, self.length)];
}

- (void)setTextGlyphTransform:(CGAffineTransform)textGlyphTransform {
    [self setTextGlyphTransform:textGlyphTransform range:NSMakeRange(0, self.length)];
}

#pragma mark - Range Setter

- (void)setFont:(UIFont *)font range:(NSRange)range {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self setAttribute:NSFontAttributeName value:font range:range];
}

- (void)setKern:(NSNumber *)kern range:(NSRange)range {
    [self setAttribute:NSKernAttributeName value:kern range:range];
}

- (void)setColor:(UIColor *)color range:(NSRange)range {
    [self setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}

- (void)setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)setStrokeColor:(UIColor *)strokeColor range:(NSRange)range {
    [self setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor range:range];
    [self setAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
}

- (void)setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle range:(NSRange)range {
    NSNumber *style = strikethroughStyle == 0 ? nil : @(strikethroughStyle);
    [self setAttribute:NSStrikethroughStyleAttributeName value:style range:range];
}

- (void)setStrikethroughColor:(UIColor *)strikethroughColor range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSStrikethroughColorAttributeName value:strikethroughColor range:range];
    }
}

- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range {
    NSNumber *style = underlineStyle == 0 ? nil : @(underlineStyle);
    [self setAttribute:NSUnderlineStyleAttributeName value:style range:range];
}

- (void)setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range {
    [self setAttribute:(id)kCTUnderlineColorAttributeName value:(id)underlineColor.CGColor range:range];
    if (kSystemVersion >= 7) {
        [self setAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
    }
}

- (void)setLigature:(NSNumber *)ligature range:(NSRange)range {
    [self setAttribute:NSLigatureAttributeName value:ligature range:range];
}

- (void)setTextEffect:(NSString *)textEffect range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSTextEffectAttributeName value:textEffect range:range];
    }
}

- (void)setObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSObliquenessAttributeName value:obliqueness range:range];
    }
}

- (void)setExpansion:(NSNumber *)expansion range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSExpansionAttributeName value:expansion range:range];
    }
}

- (void)setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
    }
}

- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range {
    NSNumber *v = verticalGlyphForm ? @(YES) : nil;
    [self setAttribute:NSVerticalGlyphFormAttributeName value:v range:range];
}

- (void)setLanguage:(NSString *)language range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:(id)kCTLanguageAttributeName value:language range:range];
    }
}

- (void)setWritingDirection:(NSArray *)writingDirection range:(NSRange)range {
    [self setAttribute:(id)kCTWritingDirectionAttributeName value:writingDirection range:range];
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

#define ParagraphStyleSet(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
                 inRange:range \
                 options:kNilOptions \
              usingBlock: ^(NSParagraphStyle *value, NSRange subRange, BOOL *stop) { \
                  NSMutableParagraphStyle *style = nil; \
                  if (value) { \
                      if (CFGetTypeID((__bridge CFTypeRef)(value)) == CTParagraphStyleGetTypeID()) { \
                          value = [NSParagraphStyle styleWithCTStyle:(__bridge CTParagraphStyleRef)(value)]; \
                      } \
                      if (value. _attr_ == _attr_) return; \
                      if ([value isKindOfClass:[NSMutableParagraphStyle class]]) { \
                          style = (id)value; \
                      } else { \
                          style = value.mutableCopy; \
                      } \
                  } else { \
                      if ([NSParagraphStyle defaultParagraphStyle]. _attr_ == _attr_) return; \
                      style = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
                  } \
                  style. _attr_ = _attr_; \
                  [self setParagraphStyle:style range:subRange]; \
              }];

- (void)setAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    ParagraphStyleSet(alignment);
}

- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range {
    ParagraphStyleSet(baseWritingDirection);
}

- (void)setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    ParagraphStyleSet(lineSpacing);
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    ParagraphStyleSet(paragraphSpacing);
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range {
    ParagraphStyleSet(paragraphSpacingBefore);
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    ParagraphStyleSet(firstLineHeadIndent);
}

- (void)setHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    ParagraphStyleSet(headIndent);
}

- (void)setTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    ParagraphStyleSet(tailIndent);
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    ParagraphStyleSet(lineBreakMode);
}

- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range {
    ParagraphStyleSet(minimumLineHeight);
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range {
    ParagraphStyleSet(maximumLineHeight);
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range {
    ParagraphStyleSet(lineHeightMultiple);
}

- (void)setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range {
    ParagraphStyleSet(hyphenationFactor);
}

- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range {
    if (!kiOS7Later) return;
    ParagraphStyleSet(defaultTabInterval);
}

- (void)setTabStops:(NSArray *)tabStops range:(NSRange)range {
    if (!kiOS7Later) return;
    ParagraphStyleSet(tabStops);
}

#undef ParagraphStyleSet

- (void)setSuperscript:(NSNumber *)superscript range:(NSRange)range {
    if ([superscript isEqualToNumber:@(0)]) {
        superscript = nil;
    }
    [self setAttribute:(id)kCTSuperscriptAttributeName value:superscript range:range];
}

- (void)setGlyphInfo:(CTGlyphInfoRef)glyphInfo range:(NSRange)range {
    [self setAttribute:(id)kCTGlyphInfoAttributeName value:(__bridge id)glyphInfo range:range];
}

- (void)setCharacterShape:(NSNumber *)characterShape range:(NSRange)range {
    [self setAttribute:(id)kCTCharacterShapeAttributeName value:characterShape range:range];
}

- (void)setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range {
    [self setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
}

- (void)setBaselineClass:(CFStringRef)baselineClass range:(NSRange)range {
    [self setAttribute:(id)kCTBaselineClassAttributeName value:(__bridge id)baselineClass range:range];
}

- (void)setBaselineInfo:(CFDictionaryRef)baselineInfo range:(NSRange)range {
    [self setAttribute:(id)kCTBaselineInfoAttributeName value:(__bridge id)baselineInfo range:range];
}

- (void)setBaselineReferenceInfo:(CFDictionaryRef)referenceInfo range:(NSRange)range {
    [self setAttribute:(id)kCTBaselineReferenceInfoAttributeName value:(__bridge id)referenceInfo range:range];
}

- (void)setRubyAnnotation:(CTRubyAnnotationRef)ruby range:(NSRange)range {
    if (kSystemVersion >= 8) {
        [self setAttribute:(id)kCTRubyAnnotationAttributeName value:(__bridge id)ruby range:range];
    }
}

- (void)setAttachment:(NSTextAttachment *)attachment range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSAttachmentAttributeName value:attachment range:range];
    }
}

- (void)setLink:(id)link range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSLinkAttributeName value:link range:range];
    }
}

- (void)setTextBackedString:(YYTextBackedString *)textBackedString range:(NSRange)range {
    [self setAttribute:YYTextBackedStringAttributeName value:textBackedString range:range];
}

- (void)setTextBinding:(YYTextBinding *)textBinding range:(NSRange)range {
    [self setAttribute:YYTextBindingAttributeName value:textBinding range:range];
}

- (void)setTextShadow:(YYTextShadow *)textShadow range:(NSRange)range {
    [self setAttribute:YYTextShadowAttributeName value:textShadow range:range];
}

- (void)setTextInnerShadow:(YYTextShadow *)textInnerShadow range:(NSRange)range {
    [self setAttribute:YYTextInnerShadowAttributeName value:textInnerShadow range:range];
}

- (void)setTextUnderline:(YYTextDecoration *)textUnderline range:(NSRange)range {
    [self setAttribute:YYTextUnderlineAttributeName value:textUnderline range:range];
}

- (void)setTextStrikethrough:(YYTextDecoration *)textStrikethrough range:(NSRange)range {
    [self setAttribute:YYTextStrikethroughAttributeName value:textStrikethrough range:range];
}

- (void)setTextBorder:(YYTextBorder *)textBorder range:(NSRange)range {
    [self setAttribute:YYTextBorderAttributeName value:textBorder range:range];
}

- (void)setTextBackgroundBorder:(YYTextBorder *)textBackgroundBorder range:(NSRange)range {
    [self setAttribute:YYTextBackgroundBorderAttributeName value:textBackgroundBorder range:range];
}

- (void)setTextAttachment:(YYTextAttachment *)textAttachment range:(NSRange)range {
    [self setAttribute:YYTextAttachmentAttributeName value:textAttachment range:range];
}

- (void)setTextHighlight:(YYTextHighlight *)textHighlight range:(NSRange)range {
    [self setAttribute:YYTextHighlightAttributeName value:textHighlight range:range];
}

- (void)setTextBlockBorder:(YYTextBorder *)textBlockBorder range:(NSRange)range {
    [self setAttribute:YYTextBlockBorderAttributeName value:textBlockBorder range:range];
}

- (void)setTextRubyAnnotation:(YYTextRubyAnnotation *)ruby range:(NSRange)range {
    if (kiOS8Later) {
        CTRubyAnnotationRef rubyRef = [ruby CTRubyAnnotation];
        [self setRubyAnnotation:rubyRef range:range];
        if (rubyRef) CFRelease(rubyRef);
    }
}

- (void)setTextGlyphTransform:(CGAffineTransform)textGlyphTransform range:(NSRange)range {
    NSValue *value = CGAffineTransformIsIdentity(textGlyphTransform) ? nil : [NSValue valueWithCGAffineTransform:textGlyphTransform];
    [self setAttribute:YYTextGlyphTransformAttributeName value:value range:range];
}

- (void)setTextHighlightRange:(NSRange)range
                        color:(UIColor *)color
              backgroundColor:(UIColor *)backgroundColor
                     userInfo:(NSDictionary *)userInfo
                    tapAction:(YYTextAction)tapAction
              longPressAction:(YYTextAction)longPressAction {
    YYTextHighlight *highlight = [YYTextHighlight highlightWithBackgroundColor:backgroundColor];
    highlight.userInfo = userInfo;
    highlight.tapAction = tapAction;
    highlight.longPressAction = longPressAction;
    if (color) [self setColor:color range:range];
    [self setTextHighlight:highlight range:range];
}

- (void)setTextHighlightRange:(NSRange)range
                        color:(UIColor *)color
              backgroundColor:(UIColor *)backgroundColor
                    tapAction:(YYTextAction)tapAction {
    [self setTextHighlightRange:range
                          color:color
                backgroundColor:backgroundColor
                       userInfo:nil
                      tapAction:tapAction
                longPressAction:nil];
}

- (void)setTextHighlightRange:(NSRange)range
                        color:(UIColor *)color
              backgroundColor:(UIColor *)backgroundColor
                     userInfo:(NSDictionary *)userInfo {
    [self setTextHighlightRange:range
                          color:color
                backgroundColor:backgroundColor
                       userInfo:userInfo
                      tapAction:nil
                longPressAction:nil];
}

- (void)insertString:(NSString *)string atIndex:(NSUInteger)location {
    [self replaceCharactersInRange:NSMakeRange(location, 0) withString:string];
    [self removeDiscontinuousAttributesInRange:NSMakeRange(location, string.length)];
}

- (void)appendString:(NSString *)string {
    NSUInteger length = self.length;
    [self replaceCharactersInRange:NSMakeRange(length, 0) withString:string];
    [self removeDiscontinuousAttributesInRange:NSMakeRange(length, string.length)];
}

- (void)setClearColorToJoinedEmoji {
    NSString *str = self.string;
    if (str.length < 8) return;
    
    // Most string do not contains the joined-emoji, test the joiner first.
    BOOL containsJoiner = NO;
    {
        CFStringRef cfStr = (__bridge CFStringRef)str;
        BOOL needFree = NO;
        UniChar *chars = NULL;
        chars = (void *)CFStringGetCharactersPtr(cfStr);
        if (!chars) {
            chars = malloc(str.length * sizeof(UniChar));
            if (chars) {
                needFree = YES;
                CFStringGetCharacters(cfStr, CFRangeMake(0, str.length), chars);
            }
        }
        if (!chars) { // fail to get unichar..
            containsJoiner = YES;
        } else {
            for (int i = 0, max = (int)str.length; i < max; i++) {
                if (chars[i] == 0x200D) { // 'ZERO WIDTH JOINER' (U+200D)
                    containsJoiner = YES;
                    break;
                }
            }
            if (needFree) free(chars);
        }
    }
    if (!containsJoiner) return;
    
    // NSRegularExpression is designed to be immutable and thread safe.
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((👨‍👩‍👧‍👦|👨‍👩‍👦‍👦|👨‍👩‍👧‍👧|👩‍👩‍👧‍👦|👩‍👩‍👦‍👦|👩‍👩‍👧‍👧|👨‍👨‍👧‍👦|👨‍👨‍👦‍👦|👨‍👨‍👧‍👧)+|(👨‍👩‍👧|👩‍👩‍👦|👩‍👩‍👧|👨‍👨‍👦|👨‍👨‍👧))" options:kNilOptions error:nil];
    });
    
    UIColor *clear = [UIColor clearColor];
    [regex enumerateMatchesInString:str options:kNilOptions range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [self setColor:clear range:result.range];
    }];
}

- (void)removeDiscontinuousAttributesInRange:(NSRange)range {
    NSArray *keys = [NSMutableAttributedString allDiscontinuousAttributeKeys];
    for (NSString *key in keys) {
        [self removeAttribute:key range:range];
    }
}

+ (NSArray *)allDiscontinuousAttributeKeys {
    static NSMutableArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[(id)kCTSuperscriptAttributeName,
                 (id)kCTRunDelegateAttributeName,
                 YYTextBackedStringAttributeName,
                 YYTextBindingAttributeName,
                 YYTextAttachmentAttributeName].mutableCopy;
        if (kiOS8Later) {
            [keys addObject:(id)kCTRubyAnnotationAttributeName];
        }
        if (kiOS7Later) {
            [keys addObject:NSAttachmentAttributeName];
        }
    });
    return keys;
}

@end
