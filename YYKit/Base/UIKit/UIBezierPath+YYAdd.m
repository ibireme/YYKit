//
//  UIBezierPath+YYAdd.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/10/30.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIBezierPath+YYAdd.h"
#import "UIFont+YYAdd.h"
#import <CoreText/CoreText.h>
#import "YYKitMacro.h"

YYSYNTH_DUMMY_CLASS(UIBezierPath_YYAdd)


@implementation UIBezierPath (YYAdd)

+ (UIBezierPath *)bezierPathWithText:(NSString *)text font:(UIFont *)font {
    CTFontRef ctFont = font.CTFontRef;
    if (!ctFont) return nil;
    NSDictionary *attrs = @{ (__bridge id)kCTFontAttributeName:(__bridge id)ctFont };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    CFRelease(ctFont);
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)attrString);
    if (!line) return nil;
    
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    for (CFIndex iRun = 0, iRunMax = CFArrayGetCount(runs); iRun < iRunMax; iRun++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runs, iRun);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex iGlyph = 0, iGlyphMax = CTRunGetGlyphCount(run); iGlyph < iGlyphMax; iGlyph++) {
            CFRange glyphRange = CFRangeMake(iGlyph, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            CTRunGetPositions(run, glyphRange, &position);
            
            CGPathRef glyphPath = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            if (glyphPath) {
                CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(cgPath, &transform, glyphPath);
                CGPathRelease(glyphPath);
            }
        }
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGRect boundingBox = CGPathGetPathBoundingBox(cgPath);
    CFRelease(cgPath);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}

@end
