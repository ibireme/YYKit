//
//  T1Helper.m
//  YYKitExample
//
//  Created by ibireme on 15/10/10.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "T1Helper.h"

@implementation T1Helper

+ (NSBundle *)bundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ResourceTwitter" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"TwitterImageCache";
    });
    return cache;
}

+ (UIImage *)imageNamed:(NSString *)name {
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self bundle] pathForScaledResource:name ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:name];
    return image;
}

+ (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterFullDate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"M/d/yy"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // local time error
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60) {
        return [NSString stringWithFormat:@"%ds",(int)(delta)];
    } else if (delta < 60 * 60) {
        return [NSString stringWithFormat:@"%dm", (int)(delta / 60.0)];
    } else if (delta < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%dh", (int)(delta / 60.0 / 60.0)];
    } else if (delta < 60 * 60 * 24 * 7) {
        return [NSString stringWithFormat:@"%dd", (int)(delta / 60.0 / 60.0 / 24.0)];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

+ (NSString *)shortedNumberDesc:(NSUInteger)number {
    if (number <= 999) return [NSString stringWithFormat:@"%d",(int)number];
    if (number <= 9999) return [NSString stringWithFormat:@"%d,%3.3d",(int)(number / 1000), (int)(number % 1000)];
    if (number < 1000 * 1000) return [NSString stringWithFormat:@"%.1fK", number / 1000.0];
    if (number < 1000 * 1000 * 1000) return [NSString stringWithFormat:@"%.1fM", number / 1000.0 / 1000.0];
    return [NSString stringWithFormat:@"%.1fB", number / 1000.0 / 1000.0 / 1000.0];
}

@end
