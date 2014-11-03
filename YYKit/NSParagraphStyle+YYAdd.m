//
//  NSParagraphStyle+YYAdd.m
//  YYKit
//
//  Created by ibireme on 14-10-7.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYTextDefine.h"
#import "NSParagraphStyle+YYAdd.h"
#import <CoreText/CoreText.h>
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(NSParagraphStyle_YYAdd)


static inline NSTextAlignment CTAlign2NSAlign(CTTextAlignment align) {
    switch (align) {
        case kCTTextAlignmentLeft: return NSTextAlignmentLeft;
        case kCTTextAlignmentRight: return NSTextAlignmentRight;
        case kCTTextAlignmentCenter: return NSTextAlignmentCenter;
        case kCTTextAlignmentJustified: return NSTextAlignmentJustified;
        case kCTTextAlignmentNatural: return NSTextAlignmentNatural;
        default: return (NSTextAlignment)align;
    }
}

static inline CTTextAlignment NSALign2CTAlign(NSTextAlignment align) {
    switch (align) {
        case NSTextAlignmentLeft: return kCTTextAlignmentLeft;
        case NSTextAlignmentRight: return kCTTextAlignmentRight;
        case NSTextAlignmentCenter: return kCTTextAlignmentCenter;
        case NSTextAlignmentJustified: return kCTTextAlignmentJustified;
        case NSTextAlignmentNatural: return kCTTextAlignmentNatural;
        default: return (CTTextAlignment)align;
    }
}

@implementation NSParagraphStyle (YYAdd)

+ (NSParagraphStyle *)styleWithCTStyle:(CTParagraphStyleRef)CTStyle {
    if (CTStyle == NULL) return nil;
    
    NSMutableParagraphStyle *style = [[self defaultParagraphStyle] mutableCopy];
    if (!self) return nil;
    
    CGFloat lineSpacing;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing)) {
        style.lineSpacing = lineSpacing;
    }
    
    CGFloat paragraphSpacing;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing)) {
        style.paragraphSpacing = paragraphSpacing;
    }
    
    CTTextAlignment alignment;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment)) {
        style.alignment = CTAlign2NSAlign(alignment);
    }
    
    CGFloat firstLineHeadIndent;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent)) {
        style.firstLineHeadIndent = firstLineHeadIndent;
    }
    
    CGFloat headIndent;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent)) {
        style.headIndent = headIndent;
    }
    
    CGFloat tailIndent;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent)) {
        style.tailIndent = tailIndent;
    }
    
    CTLineBreakMode lineBreakMode;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode)) {
        style.lineBreakMode = (NSLineBreakMode)lineBreakMode;
    }
    
    CGFloat minimumLineHeight;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight)) {
        style.minimumLineHeight = minimumLineHeight;
    }
    
    CGFloat maximumLineHeight;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maximumLineHeight)) {
        style.maximumLineHeight = maximumLineHeight;
    }
    
    CTWritingDirection baseWritingDirection;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &baseWritingDirection)) {
        style.baseWritingDirection = (NSWritingDirection)baseWritingDirection;
    }
    
    CGFloat lineHeightMultiple;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple)) {
        style.lineHeightMultiple = lineHeightMultiple;
    }
    
    CGFloat paragraphSpacingBefore;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore)) {
        style.paragraphSpacingBefore = paragraphSpacingBefore;
    }
    
    CFArrayRef tabStops;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops)) {
        if ([style respondsToSelector:@selector(setTabStops:)]) {
            NSMutableArray *tabs = @[].mutableCopy;
            [((__bridge NSArray *)(tabStops))enumerateObjectsUsingBlock : ^(id obj, NSUInteger idx, BOOL *stop) {
                CTTextTabRef ctTab = (__bridge CFTypeRef)obj;
                
                NSTextTab *tab = [[NSTextTab alloc] initWithTextAlignment:CTAlign2NSAlign(CTTextTabGetAlignment(ctTab)) location:CTTextTabGetLocation(ctTab) options:(__bridge id)CTTextTabGetOptions(ctTab)];
                [tabs addObject:tab];
            }];
            if (tabs.count) {
                style.tabStops = tabs;
            }
        }
    }
    
    CGFloat defaultTabInterval;
    if (CTParagraphStyleGetValueForSpecifier(CTStyle, kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &defaultTabInterval)) {
        if ([style respondsToSelector:@selector(setDefaultTabInterval:)]) {
            style.defaultTabInterval = defaultTabInterval;
        }
    }
    
    return style;
}

- (CTParagraphStyleRef)CTStyle CF_RETURNS_RETAINED {
    CTParagraphStyleSetting set[kCTParagraphStyleSpecifierCount] = { 0 };
    int count = 0;
    
    CGFloat lineSpacing = self.lineSpacing;
    set[count].spec = kCTParagraphStyleSpecifierLineSpacing;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &lineSpacing;
    count++;
    
    set[count].spec = kCTParagraphStyleSpecifierLineSpacing;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &lineSpacing;
    count++;
    
    CGFloat paragraphSpacing = self.paragraphSpacing;
    set[count].spec = kCTParagraphStyleSpecifierParagraphSpacing;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &paragraphSpacing;
    count++;
    
    CTTextAlignment alignment = NSALign2CTAlign(self.alignment);
    set[count].spec = kCTParagraphStyleSpecifierAlignment;
    set[count].valueSize = sizeof(CTTextAlignment);
    set[count].value = &alignment;
    count++;
    
    CGFloat firstLineHeadIndent = self.firstLineHeadIndent;
    set[count].spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &firstLineHeadIndent;
    count++;
    
    CGFloat headIndent = self.headIndent;
    set[count].spec = kCTParagraphStyleSpecifierHeadIndent;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &headIndent;
    count++;
    
    CGFloat tailIndent = self.tailIndent;
    set[count].spec = kCTParagraphStyleSpecifierTailIndent;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &tailIndent;
    count++;
    
    CTLineBreakMode paraLineBreak = (CTLineBreakMode)self.lineBreakMode;
    set[count].spec = kCTParagraphStyleSpecifierLineBreakMode;
    set[count].valueSize = sizeof(CTLineBreakMode);
    set[count].value = &paraLineBreak;
    count++;
    
    CGFloat minimumLineHeight = self.minimumLineHeight;
    set[count].spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &minimumLineHeight;
    count++;
    
    CGFloat maximumLineHeight = self.maximumLineHeight;
    set[count].spec = kCTParagraphStyleSpecifierMaximumLineHeight;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &maximumLineHeight;
    count++;
    
    CTWritingDirection paraWritingDirection = (CTWritingDirection)self.baseWritingDirection;
    set[count].spec = kCTParagraphStyleSpecifierBaseWritingDirection;
    set[count].valueSize = sizeof(CTWritingDirection);
    set[count].value = &paraWritingDirection;
    count++;
    
    CGFloat lineHeightMultiple = self.lineHeightMultiple;
    set[count].spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &lineHeightMultiple;
    count++;
    
    CGFloat paragraphSpacingBefore = self.paragraphSpacingBefore;
    set[count].spec = kCTParagraphStyleSpecifierParagraphSpacingBefore;
    set[count].valueSize = sizeof(CGFloat);
    set[count].value = &paragraphSpacingBefore;
    count++;
    
    NSMutableArray *tabs = [NSMutableArray array];
    if ([self respondsToSelector:@selector(tabStops)]) {
        NSInteger numTabs = self.tabStops.count;
        if (numTabs) {
            [self.tabStops enumerateObjectsUsingBlock: ^(NSTextTab *tab, NSUInteger idx, BOOL *stop) {
                CTTextTabRef ctTab = CTTextTabCreate(NSALign2CTAlign(tab.alignment), tab.location, (__bridge CFTypeRef)tab.options);
                [tabs addObject:(__bridge id)ctTab];
                CFRelease(ctTab);
            }];
            
            CFArrayRef tabStops = (__bridge CFArrayRef)(tabs);
            set[count].spec = kCTParagraphStyleSpecifierTabStops;
            set[count].valueSize = sizeof(CFArrayRef);
            set[count].value = &tabStops;
            count++;
        }
    }
    
    if ([self respondsToSelector:@selector(defaultTabInterval)]) {
        CGFloat defaultTabInterval = self.defaultTabInterval;
        set[count].spec = kCTParagraphStyleSpecifierDefaultTabInterval;
        set[count].valueSize = sizeof(CGFloat);
        set[count].value = &defaultTabInterval;
        count++;
    }
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(set, count);
    return style;
}

@end
