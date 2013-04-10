//
//  NSArray+YYAdd.m
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import "NSArray+YYAdd.h"
#import "YYCoreMacro.h"

DUMMY_CLASS(NSArray_YYAdd)
@implementation NSArray (YYAdd)

- (NSMutableArray *)deepMutableCopy {
    return (__bridge_transfer NSMutableArray *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFArrayRef)self, kCFPropertyListMutableContainers);
}

- (NSArray *)deepCopy{
    return (__bridge_transfer NSMutableArray *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFArrayRef)self, kCFPropertyListMutableContainers);
}

- (id)firstObject{
    if (self.count) {
        return self[0];
    }
    return nil;
}

@end
