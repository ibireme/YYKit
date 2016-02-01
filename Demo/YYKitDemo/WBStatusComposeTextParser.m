//
//  WBStatusComposeTextParser.m
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "WBStatusComposeTextParser.h"
#import "WBStatusHelper.h"

@implementation WBStatusComposeTextParser

- (instancetype)init {
    self = [super init];
    _font = [UIFont systemFontOfSize:17];
    _textColor = [UIColor colorWithWhite:0.2 alpha:1];
    _highlightTextColor = UIColorHex(527ead);
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange {
    text.color = _textColor;
    
    // 此处没有进行优化，性能较低，只是为了功能演示
    
    {
        static NSArray *topicExts, *topicExtImages;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            topicExts = @[ @"[电影]#", @"[图书]#", @"[音乐]#", @"[地点]#", @"[股票]#" ];
            topicExtImages = @[
                [WBStatusHelper imageNamed:@"timeline_card_small_movie"],
                [WBStatusHelper imageNamed:@"timeline_card_small_book"],
                [WBStatusHelper imageNamed:@"timeline_card_small_music"],
                [WBStatusHelper imageNamed:@"timeline_card_small_location"],
                [WBStatusHelper imageNamed:@"timeline_card_small_stock"]
            ];
        });
        
        NSArray<NSTextCheckingResult *> *topicResults = [[WBStatusHelper regexTopic] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
        NSUInteger clipLength = 0;
        for (NSTextCheckingResult *topic in topicResults) {
            if (topic.range.location == NSNotFound && topic.range.length <= 1) continue;
            NSRange range = topic.range;
            range.location -= clipLength;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            BOOL hasExt = NO;
            NSString *subText = [text.string substringWithRange:range];
            for (NSUInteger i = 0; i < topicExts.count; i++) {
                NSString *ext = topicExts[i];
                if ([subText hasSuffix:ext] && subText.length > ext.length + 1) {
                    
                    NSMutableAttributedString *replace = [[NSMutableAttributedString alloc] initWithString:[subText substringWithRange:NSMakeRange(1, subText.length - 1 - ext.length)]];
                    NSAttributedString *pic = [self _attachmentWithFontSize:_font.pointSize image:topicExtImages[i] shrink:YES];
                    [replace insertAttributedString:pic atIndex:0];
                    replace.font = _font;
                    replace.color = _highlightTextColor;
                    
                    // original text, used for text copy
                    YYTextBackedString *backed = [YYTextBackedString stringWithString:subText];
                    [replace setTextBackedString:backed range:NSMakeRange(0, replace.length)];
                    
                    [text replaceCharactersInRange:range withAttributedString:replace];
                    [text setTextBinding:[YYTextBinding bindingWithDeleteConfirm:YES] range:NSMakeRange(range.location, replace.length)];
                    [text setColor:_highlightTextColor range:NSMakeRange(range.location, replace.length)];
                    if (selectedRange) {
                        *selectedRange = [self _replaceTextInRange:range withLength:replace.length selectedRange:*selectedRange];
                    }
                    
                    clipLength += range.length - replace.length;
                    hasExt = YES;
                    break;
                }
            }
            
            if (!hasExt) {
                [text setColor:_highlightTextColor range:range];
            }
        }
        
    }
    
    
    
    {
        NSArray<NSTextCheckingResult *> *atResults = [[WBStatusHelper regexAt] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
        for (NSTextCheckingResult *at in atResults) {
            if (at.range.location == NSNotFound && at.range.length <= 1) continue;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:at.range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            
            [text setColor:_highlightTextColor range:at.range];
        }
    }
    
    {
        NSArray<NSTextCheckingResult *> *emoticonResults = [[WBStatusHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
        NSUInteger clipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= clipLength;
            if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [text.string substringWithRange:range];
            NSString *imagePath = [WBStatusHelper emoticonDic][emoString];
            UIImage *image = [WBStatusHelper imageWithPath:imagePath];
            if (!image) continue;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            
            YYTextBackedString *backed = [YYTextBackedString stringWithString:emoString];
            NSMutableAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:_font.pointSize].mutableCopy;
            // original text, used for text copy
            [emoText setTextBackedString:backed range:NSMakeRange(0, emoText.length)];
            [emoText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:NSMakeRange(0, emoText.length)];
            
            [text replaceCharactersInRange:range withAttributedString:emoText];
            
            if (selectedRange) {
                *selectedRange = [self _replaceTextInRange:range withLength:emoText.length selectedRange:*selectedRange];
            }
            clipLength += range.length - emoText.length;
        }
    }
    
    [text enumerateAttribute:YYTextBindingAttributeName inRange:text.rangeOfAll options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && range.length > 1) {
            [text setColor:_highlightTextColor range:range];
        }
    }];
    
    text.font = _font;
    return YES;
}

// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}


- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize image:(UIImage *)image shrink:(BOOL)shrink {
    
    //    CGFloat ascent = YYEmojiGetAscentWithFontSize(fontSize);
    //    CGFloat descent = YYEmojiGetDescentWithFontSize(fontSize);
    //    CGRect bounding = YYEmojiGetGlyphBoundingRectWithFontSize(fontSize);
    
    // Heiti SC 字体。。
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.content = image;
    
    if (shrink) {
        // 缩小~
        CGFloat scale = 1 / 10.0;
        contentInsets.top += fontSize * scale;
        contentInsets.bottom += fontSize * scale;
        contentInsets.left += fontSize * scale;
        contentInsets.right += fontSize * scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        attachment.contentInsets = contentInsets;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

@end
