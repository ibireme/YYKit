//
//  NSParagraphStyle+YYAdd.h
//  YYKit
//
//  Created by ibireme on 14-10-7.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Provides extensions for `NSParagraphStyle` to work with CoreText.
 */
@interface NSParagraphStyle (YYAdd)

/**
 Creates a new NSParagraphStyle object from the CoreText Style.
 
 @param CTStyle CoreText Paragraph Style.
 
 @return a new NSParagraphStyle
 */
+ (NSParagraphStyle *)styleWithCTStyle:(CTParagraphStyleRef)CTStyle;

/**
 Creates and returns a CoreText Paragraph Style. (need call CFRelease() after used)
 */
- (CTParagraphStyleRef)CTStyle CF_RETURNS_RETAINED;

@end
