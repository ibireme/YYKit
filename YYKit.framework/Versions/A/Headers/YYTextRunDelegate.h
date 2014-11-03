//
//  YYTextRunDelegate.h
//  YYKit
//
//  Created by ibireme on 14-10-14.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

/**
 Wrapper of CTRunDelegateRef.
 */
@interface YYTextRunDelegate : NSObject

/**
 Creates and returns the CTRunDelegate.
 
 @discussion You need call CFRelease() after used.
 The CTRunDelegateRef has a strong reference to this YYTextRunDelegate object.
 In CoreText, use CTRunDelegateGetRefCon() to get this YYTextRunDelegate object.
 
 @return The CTRunDelegate object.
 */
- (CTRunDelegateRef)CTRunDelegate CF_RETURNS_RETAINED;

/**
 Additional information about the the run delegate.
 */
@property (nonatomic, readonly) NSMutableDictionary *userInfo;

/**
 The typographic ascent of glyphs in the run.
 */
@property (nonatomic, assign) CGFloat ascent;

/**
 The typographic descent of glyphs in the run.
 */
@property (nonatomic, assign) CGFloat descent;

/**
 The typographic width of glyphs in the run.
 */
@property (nonatomic, assign) CGFloat width;

@end
