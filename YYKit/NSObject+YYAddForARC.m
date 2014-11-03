//
//  NSObject+YYAddForARC.m
//  YYKit
//
//  Created by ibireme on 13-12-25.
//  Copyright (c) 2013 ibireme. All rights reserved.
//

#import "NSObject+YYAddForARC.h"
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(NSObject_YYAddForARC)

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif


@implementation NSObject (YYAddForARC)

- (instancetype)arcDebugRetain {
    return [self retain];
}

- (oneway void)arcDebugRelease {
    [self release];
}

- (instancetype)arcDebugAutorelease {
    return [self autorelease];
}

- (NSUInteger)arcDebugRetainCount {
    return [self retainCount];
}

@end
