//
//  WBStatusComposeTextParser.h
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@interface WBStatusComposeTextParser : NSObject <YYTextParser>
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;
@end
