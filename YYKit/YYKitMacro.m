//
//  YY.m
//  YYKit
//
//  Created by ibireme on 14-10-13.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYKitMacro.h"


CGSize YYDeviceScreenSize;
float YYDeviceSystemVersion;
BOOL YYDeviceIsSimulator;


/*
 Do some lightweight work... 
 */
@interface YYKitLoader : NSObject
@end

@implementation YYKitLoader

+ (void)load {
    YYDeviceScreenSize = [UIScreen mainScreen].bounds.size;
    if (YYDeviceScreenSize.width > YYDeviceScreenSize.height) {
        YY_SWAP(YYDeviceScreenSize.width, YYDeviceScreenSize.height);
    }
    UIDevice *device = [UIDevice currentDevice];
    YYDeviceSystemVersion = device.systemVersion.floatValue;
    YYDeviceIsSimulator = [[device model] rangeOfString:@"Simulator"].location != NSNotFound;
}

@end
