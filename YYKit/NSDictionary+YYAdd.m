//
//  NSDictionary+YYAdd.m
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import "NSDictionary+YYAdd.h"
#import "YYCoreMacro.h"

DUMMY_CLASS(NSDictionary_YYAdd)

@implementation NSDictionary (YYAdd)

- (NSMutableDictionary *)deepMutableCopy {
    return (__bridge_transfer NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFDictionaryRef)self, kCFPropertyListMutableContainers);
}

- (NSDictionary *)deepCopy {
    return (__bridge_transfer NSDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFDictionaryRef)self, kCFPropertyListMutableContainers);
}

- (NSArray *)allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)allValuesSortedByKey {
    NSArray *sortedKeys = [self allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return arr;
}

@end
