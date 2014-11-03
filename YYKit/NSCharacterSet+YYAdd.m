//
//  NSCharacterSet+YYAdd.m
//  YYKit
//
//  Created by ibireme on 14-10-28.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "NSCharacterSet+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(NSCharacterSet_YYAdd)


@implementation NSCharacterSet (YYAdd)

+ (NSCharacterSet *)emojiCharacterSet {
    static NSCharacterSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSCharacterSet characterSetWithCharactersInString:[NSString allEmoji]];
    });
    return set;
}

@end


@implementation NSMutableCharacterSet (YYAdd)

+ (NSMutableCharacterSet *)emojiCharacterSet {
    static NSMutableCharacterSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSCharacterSet emojiCharacterSet].mutableCopy;
    });
    return set;
}

@end
