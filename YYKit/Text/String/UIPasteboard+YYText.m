//
//  UIPasteboard+YYText.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/4/2.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIPasteboard+YYText.h"
#import "YYKitMacro.h"
#import "YYImage.h"
#import "NSAttributedString+YYText.h"
#import <MobileCoreServices/MobileCoreServices.h>

YYSYNTH_DUMMY_CLASS(UIPasteboard_YYText)

NSString *const YYPasteboardTypeAttributedString = @"com.ibireme.NSAttributedString";
NSString *const YYUTTypeWEBP = @"com.google.webp";

@implementation UIPasteboard (YYText)


- (void)setPNGData:(NSData *)PNGData {
    [self setData:PNGData forPasteboardType:(id)kUTTypePNG];
}

- (NSData *)PNGData {
    return [self dataForPasteboardType:(id)kUTTypePNG];
}

- (void)setJPEGData:(NSData *)JPEGData {
    [self setData:JPEGData forPasteboardType:(id)kUTTypeJPEG];
}

- (NSData *)JPEGData {
    return [self dataForPasteboardType:(id)kUTTypeJPEG];
}

- (void)setGIFData:(NSData *)GIFData {
    [self setData:GIFData forPasteboardType:(id)kUTTypeGIF];
}

- (NSData *)GIFData {
    return [self dataForPasteboardType:(id)kUTTypeGIF];
}

- (void)setWEBPData:(NSData *)WEBPData {
    [self setData:WEBPData forPasteboardType:YYUTTypeWEBP];
}

- (NSData *)WEBPData {
    return [self dataForPasteboardType:YYUTTypeWEBP];
}

- (void)setImageData:(NSData *)imageData {
    [self setData:imageData forPasteboardType:(id)kUTTypeImage];
}

- (NSData *)imageData {
    return [self dataForPasteboardType:(id)kUTTypeImage];
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    self.string = [attributedString plainTextForRange:NSMakeRange(0, attributedString.length)];
    NSData *data = [attributedString archiveToData];
    if (data) {
        NSDictionary *item = @{YYPasteboardTypeAttributedString : data};
        [self addItems:@[item]];
    }
    [attributedString enumerateAttribute:YYTextAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(YYTextAttachment *attachment, NSRange range, BOOL *stop) {
        UIImage *img = attachment.content;
        if ([img isKindOfClass:[UIImage class]]) {
            NSDictionary *item = @{@"com.apple.uikit.image" : img};
            [self addItems:@[item]];
            
            
            if ([img isKindOfClass:[YYImage class]] && ((YYImage *)img).animatedImageData) {
                if (((YYImage *)img).animatedImageType == YYImageTypeGIF) {
                    NSDictionary *item = @{(id)kUTTypeGIF : ((YYImage *)img).animatedImageData};
                    [self addItems:@[item]];
                } else if (((YYImage *)img).animatedImageType == YYImageTypePNG) {
                    NSDictionary *item = @{(id)kUTTypePNG : ((YYImage *)img).animatedImageData};
                    [self addItems:@[item]];
                } else if (((YYImage *)img).animatedImageType == YYImageTypeWebP) {
                    NSDictionary *item = @{(id)YYUTTypeWEBP : ((YYImage *)img).animatedImageData};
                    [self addItems:@[item]];
                }
            }
            
            
            // save image
            UIImage *simpleImage = nil;
            if ([attachment.content isKindOfClass:[UIImage class]]) {
                simpleImage = attachment.content;
            } else if ([attachment.content isKindOfClass:[UIImageView class]]) {
                simpleImage = ((UIImageView *)attachment.content).image;
            }
            if (simpleImage) {
                NSDictionary *item = @{@"com.apple.uikit.image" : simpleImage};
                [self addItems:@[item]];
            }
            
            // save animated image
            if ([attachment.content isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = attachment.content;
                YYImage *image = (id)imageView.image;
                if ([image isKindOfClass:[YYImage class]]) {
                    NSData *data = image.animatedImageData;
                    YYImageType type = image.animatedImageType;
                    if (data) {
                        switch (type) {
                            case YYImageTypeGIF: {
                                NSDictionary *item = @{(id)kUTTypeGIF : data};
                                [self addItems:@[item]];
                            } break;
                            case YYImageTypePNG: { // APNG
                                NSDictionary *item = @{(id)kUTTypePNG : data};
                                [self addItems:@[item]];
                            } break;
                            case YYImageTypeWebP: {
                                NSDictionary *item = @{(id)YYUTTypeWEBP : data};
                                [self addItems:@[item]];
                            } break;
                            default: break;
                        }
                    }
                }
            }
            
        }
    }];
}

- (NSAttributedString *)attributedString {
    for (NSDictionary *items in self.items) {
        NSData *data = items[YYPasteboardTypeAttributedString];
        if (data) {
            return [NSAttributedString unarchiveFromData:data];
        }
    }
    return nil;
}

@end
