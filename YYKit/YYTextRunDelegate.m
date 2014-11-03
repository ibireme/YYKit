//
//  YYTextRunDelegate.m
//  YYKit
//
//  Created by ibireme on 14-10-14.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYTextRunDelegate.h"


@implementation YYTextRunDelegate

- (instancetype)init {
    self = super.init;
    _userInfo = @{}.mutableCopy;
    return self;
}

static void DeallocCallback(void *ref) {
    YYTextRunDelegate *self = (__bridge_transfer YYTextRunDelegate *)(ref);
    self = nil;
}

static CGFloat GetAscentCallback(void *ref) {
    YYTextRunDelegate *self = (__bridge YYTextRunDelegate *)(ref);
    return self.ascent;
}

static CGFloat GetDecentCallback(void *ref) {
    YYTextRunDelegate *self = (__bridge YYTextRunDelegate *)(ref);
    return self.descent;
}

static CGFloat GetWidthCallback(void *ref) {
    YYTextRunDelegate *self = (__bridge YYTextRunDelegate *)(ref);
    return self.width;
}

- (CTRunDelegateRef)CTRunDelegate CF_RETURNS_RETAINED {
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = DeallocCallback;
    callbacks.getAscent = GetAscentCallback;
    callbacks.getDescent = GetDecentCallback;
    callbacks.getWidth = GetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge_retained void *)(self));
}

@end
