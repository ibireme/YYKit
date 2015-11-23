//
//  UIScreen+YYAdd.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/4/5.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIScreen+YYAdd.h"
#import "YYKitMacro.h"
#import "UIDevice+YYAdd.h"

YYSYNTH_DUMMY_CLASS(UIScreen_YYAdd);


@implementation UIScreen (YYAdd)

+ (CGFloat)screenScale {
    static CGFloat screenScale = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([NSThread isMainThread]) {
            screenScale = [[UIScreen mainScreen] scale];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                screenScale = [[UIScreen mainScreen] scale];
            });
        }
    });
    return screenScale;
}

- (CGRect)currentBounds {
    return [self boundsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation {
    CGRect bounds = [self bounds];
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat buffer = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = buffer;
    }
    return bounds;
}

- (CGSize)sizeInPixel {
    CGSize size = CGSizeZero;
    
    if ([[UIScreen mainScreen] isEqual:self]) {
        NSString *model = [UIDevice currentDevice].machineModel;
        if ([model hasPrefix:@"iPhone"]) {
            if ([model hasPrefix:@"iPhone1"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPhone2"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPhone3"]) size = CGSizeMake(640, 960);
            else if ([model hasPrefix:@"iPhone4"]) size = CGSizeMake(640, 960);
            else if ([model hasPrefix:@"iPhone5"]) size = CGSizeMake(640, 1136);
            else if ([model hasPrefix:@"iPhone6"]) size = CGSizeMake(640, 1136);
            else if ([model hasPrefix:@"iPhone7,1"]) size = CGSizeMake(1080, 1920);
            else if ([model hasPrefix:@"iPhone7,2"]) size = CGSizeMake(750, 1334);
        } else if ([model hasPrefix:@"iPod"]) {
            if ([model hasPrefix:@"iPod1"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPod2"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPod3"]) size = CGSizeMake(320, 480);
            else if ([model hasPrefix:@"iPod4"]) size = CGSizeMake(640, 960);
            else if ([model hasPrefix:@"iPod5"]) size = CGSizeMake(640, 1136);
        } else if ([model hasPrefix:@"iPad"]) {
            if ([model hasPrefix:@"iPad1"]) size = CGSizeMake(768, 1024);
            else if ([model hasPrefix:@"iPad2"]) size = CGSizeMake(768, 1024);
            else if ([model hasPrefix:@"iPad3"]) size = CGSizeMake(1536, 2048);
            else if ([model hasPrefix:@"iPad4"]) size = CGSizeMake(1536, 2048);
            else if ([model hasPrefix:@"iPad5"]) size = CGSizeMake(1536, 2048);
        }
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        if ([self respondsToSelector:@selector(nativeBounds)]) {
            size = self.nativeBounds.size;
        } else {
            size = self.bounds.size;
            size.width *= self.scale;
            size.height *= self.scale;
        }
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    }
    return size;
}

- (CGFloat)pixelsPerInch {
    CGFloat ppi = 0;
    
    if ([[UIScreen mainScreen] isEqual:self]) {
        NSString *model = [UIDevice currentDevice].machineModel;
        if ([model hasPrefix:@"iPhone"]) {
            if ([model hasPrefix:@"iPhone1"]) ppi = 163;
            else if ([model hasPrefix:@"iPhone2"]) ppi = 163;
            else if ([model hasPrefix:@"iPhone3"]) ppi = 326;
            else if ([model hasPrefix:@"iPhone4"]) ppi = 326;
            else if ([model hasPrefix:@"iPhone5"]) ppi = 326;
            else if ([model hasPrefix:@"iPhone6"]) ppi = 326;
            else if ([model hasPrefix:@"iPhone7,1"]) ppi = 401;
            else if ([model hasPrefix:@"iPhone7,2"]) ppi = 326;
        } else if ([model hasPrefix:@"iPod"]) {
            if ([model hasPrefix:@"iPod1"]) ppi = 163;
            else if ([model hasPrefix:@"iPod2"]) ppi = 163;
            else if ([model hasPrefix:@"iPod3"]) ppi = 163;
            else if ([model hasPrefix:@"iPod4"]) ppi = 326;
            else if ([model hasPrefix:@"iPod5"]) ppi = 326;
        } else if ([model hasPrefix:@"iPad"]) {
            if ([model hasPrefix:@"iPad1"]) ppi = 132;
            else if ([model hasPrefix:@"iPad2,1"]) ppi = 132;
            else if ([model hasPrefix:@"iPad2,2"]) ppi = 132;
            else if ([model hasPrefix:@"iPad2,3"]) ppi = 132;
            else if ([model hasPrefix:@"iPad2,4"]) ppi = 132;
            else if ([model hasPrefix:@"iPad2,5"]) ppi = 163;
            else if ([model hasPrefix:@"iPad2,6"]) ppi = 163;
            else if ([model hasPrefix:@"iPad2,7"]) ppi = 163;
            else if ([model hasPrefix:@"iPad3"]) ppi = 264;
            else if ([model hasPrefix:@"iPad4,1"]) ppi = 264;
            else if ([model hasPrefix:@"iPad4,2"]) ppi = 264;
            else if ([model hasPrefix:@"iPad4,3"]) ppi = 264;
            else if ([model hasPrefix:@"iPad4,4"]) ppi = 324;
            else if ([model hasPrefix:@"iPad4,5"]) ppi = 324;
            else if ([model hasPrefix:@"iPad4,6"]) ppi = 324;
            else if ([model hasPrefix:@"iPad4,7"]) ppi = 324;
            else if ([model hasPrefix:@"iPad4,8"]) ppi = 324;
            else if ([model hasPrefix:@"iPad4,9"]) ppi = 324;
            else if ([model hasPrefix:@"iPad5,3"]) ppi = 264;
            else if ([model hasPrefix:@"iPad5,4"]) ppi = 324;
        }
    }
    
    if (ppi == 0) ppi = 326;
    return ppi;
}

@end
