//
//  UIBarButtonItem+YYAdd.m
//  YYKit
//
//  Created by ibireme on 14-10-15.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "UIBarButtonItem+YYAdd.h"
#import "YYKitMacro.h"
#import <objc/runtime.h>

SYNTH_DUMMY_CLASS(UIBarButtonItem_YYAdd)


static const int block_key;

@interface _YYUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _YYUIBarButtonItemBlockTarget

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end


@implementation UIBarButtonItem (YYAdd)

- (void)setActionBlock:(void (^)(id sender))block {
    _YYUIBarButtonItemBlockTarget *target = [[_YYUIBarButtonItemBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id)) actionBlock {
    _YYUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}

@end
