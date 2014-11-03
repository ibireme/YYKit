//
//  NSBundle+YYAdd.m
//  YYKit
//
//  Created by ibireme on 14-10-20.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "NSBundle+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(NSBundle_YYAdd)

#define SUPPORT_SCALES @[@3, @2, @1]


@implementation NSBundle (YYAdd)

+ (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)bundlePath {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [self pathForResource:name ofType:ext inDirectory:bundlePath];
    
    NSString *path = nil;
    
    // first search screen's scale, then search from high to low.
    NSMutableArray *scales = SUPPORT_SCALES.mutableCopy;
    NSInteger screenScale = [UIScreen mainScreen].scale;
    [scales removeObject:@(screenScale)];
    [scales insertObject:@(screenScale) atIndex:0];
    
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name stringByAppendingNameScale:scale]
        : [name stringByAppendingPathScale:scale];
        path = [self pathForResource:scaledName ofType:ext inDirectory:bundlePath];
        if (path) break;
    }
    
    return path;
}

- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [self pathForResource:name ofType:ext];
    
    NSString *path = nil;
    
    // first search screen's scale, then search from high to low.
    NSMutableArray *scales = SUPPORT_SCALES.mutableCopy;
    NSInteger screenScale = [UIScreen mainScreen].scale;
    [scales removeObject:@(screenScale)];
    [scales insertObject:@(screenScale) atIndex:0];
    
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name stringByAppendingNameScale:scale]
        : [name stringByAppendingPathScale:scale];
        path = [self pathForResource:scaledName ofType:ext];
        if (path) break;
    }
    
    return path;
}

- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [self pathForResource:name ofType:ext];
    
    NSString *path = nil;
    
    // first search screen's scale, then search from high to low.
    NSMutableArray *scales = SUPPORT_SCALES.mutableCopy;
    NSInteger screenScale = [UIScreen mainScreen].scale;
    [scales removeObject:@(screenScale)];
    [scales insertObject:@(screenScale) atIndex:0];
    
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name stringByAppendingNameScale:scale]
        : [name stringByAppendingPathScale:scale];
        path = [self pathForResource:scaledName ofType:ext inDirectory:subpath];
        if (path) break;
    }
    
    return path;
}

@end
