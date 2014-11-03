//
//  YYText.h
//  YYKit
//
//  Created by ibireme on 14/10/26.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#ifndef YYKit_YYText_h
#define YYKit_YYText_h

#import <UIKit/UIKit.h>

/// The type of ligatures.
typedef NS_ENUM (NSInteger, YYTextLigature) {
    kYYTextLigatureOnlyEssential = 0, ///< Only ligatures essential for proper rendering of text should be used.
    kYYTextLigatureStandard      = 1, ///< Standard ligatures should be used (Default)
    kYYTextLigatureAll           = 2, ///< All available ligatures should be used.
};

/// The style of underlining.
typedef NS_OPTIONS (NSInteger, YYTextUnderlineStyle) {
    kYYTextUnderlineStyleNone       = 0x00, ///< (     ) (Default)
    kYYTextUnderlineStyleSingle     = 0x01, ///< (────)
    kYYTextUnderlineStyleThick      = 0x02, ///< (━━━━━)
    kYYTextUnderlineStyleDouble     = 0x09, ///< (════)
    
    kYYTextUnderlineStyleSolid      = 0x000, ///< (────────) (Default)
    kYYTextUnderlineStyleDot        = 0x100, ///< (・・・・・・)
    kYYTextUnderlineStyleDash       = 0x200, ///< (— — — —)
    kYYTextUnderlineStyleDashDot    = 0x300, ///< (—・—・—・—・)
    kYYTextUnderlineStyleDashDotDot = 0x400, ///< (—・・—・・—・・—・・)
};

/// The vertical alignment
typedef NS_ENUM(NSInteger, YYTextVerticalAlignment) {
    kYYTextVerticalAlignmentTop = -1, ///< Top alignment.
    kYYTextVerticalAlignmentCenter = 0, ///< Center alignment. Default.
    kYYTextVerticalAlignmentBottom = 1, ///< Bottom alignment.
};

#endif
