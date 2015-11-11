//
//  YYThreadSafeDictionary.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/10/21.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYThreadSafeDictionary.h"
#import "NSDictionary+YYAdd.h"
#import <libkern/OSAtomic.h>


#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_dic) return nil; \
_lock = OS_SPINLOCK_INIT; \
return self;


#define LOCK(...) OSSpinLockLock(&_lock); \
__VA_ARGS__; \
OSSpinLockUnlock(&_lock);


@implementation YYThreadSafeDictionary {
    NSMutableDictionary *_dic;  //Subclass a class cluster...
    OSSpinLock _lock;
}

#pragma mark - init

- (instancetype)init {
    INIT(_dic = [[NSMutableDictionary alloc] init]);
}

- (instancetype)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    INIT(_dic =  [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys]);
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    INIT(_dic = [[NSMutableDictionary alloc] initWithCapacity:capacity]);
}

- (instancetype)initWithObjects:(const id[])objects forKeys:(const id <NSCopying>[])keys count:(NSUInteger)cnt {
    INIT(_dic = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt]);
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
    INIT(_dic = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary]);
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag {
    INIT(_dic = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary copyItems:flag]);
}


#pragma mark - method

- (NSUInteger)count {
    LOCK(NSUInteger c = _dic.count); return c;
}

- (id)objectForKey:(id)aKey {
    LOCK(id o = [_dic objectForKey:aKey]); return o;
}

- (NSEnumerator *)keyEnumerator {
    LOCK(NSEnumerator * e = [_dic keyEnumerator]); return e;
}

- (NSArray *)allKeys {
    LOCK(NSArray * a = [_dic allKeys]); return a;
}

- (NSArray *)allKeysForObject:(id)anObject {
    LOCK(NSArray * a = [_dic allKeysForObject:anObject]); return a;
}

- (NSArray *)allValues {
    LOCK(NSArray * a = [_dic allValues]); return a;
}

- (NSString *)description {
    LOCK(NSString * d = [_dic description]); return d;
}

- (NSString *)descriptionInStringsFileFormat {
    LOCK(NSString * d = [_dic descriptionInStringsFileFormat]); return d;
}

- (NSString *)descriptionWithLocale:(id)locale {
    LOCK(NSString * d = [_dic descriptionWithLocale:locale]); return d;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    LOCK(NSString * d = [_dic descriptionWithLocale:locale indent:level]); return d;
}

- (BOOL)isEqualToDictionary:(NSDictionary *)otherDictionary {
    if (otherDictionary == self) return YES;
    
    if ([otherDictionary isKindOfClass:YYThreadSafeDictionary.class]) {
        YYThreadSafeDictionary *other = (id)otherDictionary;
        BOOL isEqual;
        OSSpinLockLock(&_lock);
        OSSpinLockLock(&other->_lock);
        isEqual = [_dic isEqual:other->_dic];
        OSSpinLockUnlock(&other->_lock);
        OSSpinLockUnlock(&_lock);
        return isEqual;
    }
    return NO;
}

- (NSEnumerator *)objectEnumerator {
    LOCK(NSEnumerator * e = [_dic objectEnumerator]); return e;
}

- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker {
    LOCK(NSArray * a = [_dic objectsForKeys:keys notFoundMarker:marker]); return a;
}

- (NSArray *)keysSortedByValueUsingSelector:(SEL)comparator {
    LOCK(NSArray * a = [_dic keysSortedByValueUsingSelector:comparator]); return a;
}

- (void)getObjects:(id __unsafe_unretained[])objects andKeys:(id __unsafe_unretained[])keys {
    LOCK([_dic getObjects:objects andKeys:keys]);
}

- (id)objectForKeyedSubscript:(id)key {
    LOCK(id o = [_dic objectForKeyedSubscript:key]); return o;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block {
    LOCK([_dic enumerateKeysAndObjectsUsingBlock:block]);
}

- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block {
    LOCK([_dic enumerateKeysAndObjectsWithOptions:opts usingBlock:block]);
}

- (NSArray *)keysSortedByValueUsingComparator:(NSComparator)cmptr {
    LOCK(NSArray * a = [_dic keysSortedByValueUsingComparator:cmptr]); return a;
}

- (NSArray *)keysSortedByValueWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    LOCK(NSArray * a = [_dic keysSortedByValueWithOptions:opts usingComparator:cmptr]); return a;
}

- (NSSet *)keysOfEntriesPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate {
    LOCK(NSSet * a = [_dic keysOfEntriesPassingTest:predicate]); return a;
}

- (NSSet *)keysOfEntriesWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate {
    LOCK(NSSet * a = [_dic keysOfEntriesWithOptions:opts passingTest:predicate]); return a;
}

#pragma mark - mutable

- (void)removeObjectForKey:(id)aKey {
    LOCK([_dic removeObjectForKey:aKey]);
}

- (void)setObject:(id)anObject forKey:(id <NSCopying> )aKey {
    LOCK([_dic setObject:anObject forKey:aKey]);
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    LOCK([_dic addEntriesFromDictionary:otherDictionary]);
}

- (void)removeAllObjects {
    LOCK([_dic removeAllObjects]);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
    LOCK([_dic removeObjectsForKeys:keyArray]);
}

- (void)setDictionary:(NSDictionary *)otherDictionary {
    LOCK([_dic setDictionary:otherDictionary]);
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying> )key {
    LOCK([_dic setObject:obj forKeyedSubscript:key]);
}

#pragma mark - protocol

- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    LOCK(id copiedDictionary = [[self.class allocWithZone:zone] initWithDictionary:_dic]);
    return copiedDictionary;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained[])stackbuf
                                    count:(NSUInteger)len {
    LOCK(NSUInteger count = [_dic countByEnumeratingWithState:state objects:stackbuf count:len]);
    return count;
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    
    if ([object isKindOfClass:YYThreadSafeDictionary.class]) {
        YYThreadSafeDictionary *other = object;
        BOOL isEqual;
        OSSpinLockLock(&_lock);
        OSSpinLockLock(&other->_lock);
        isEqual = [_dic isEqual:other->_dic];
        OSSpinLockUnlock(&other->_lock);
        OSSpinLockUnlock(&_lock);
        return isEqual;
    }
    return NO;
}

- (NSUInteger)hash {
    LOCK(NSUInteger hash = [_dic hash]);
    return hash;
}

#pragma mark - custom methods for NSDictionary(YYAdd)

- (NSDictionary *)entriesForKeys:(NSArray *)keys {
    LOCK(NSDictionary * dic = [_dic entriesForKeys:keys]) return dic;
}

- (NSString *)jsonStringEncoded {
    LOCK(NSString * s = [_dic jsonStringEncoded]) return s;
}

- (NSString *)jsonPrettyStringEncoded {
    LOCK(NSString * s = [_dic jsonPrettyStringEncoded]) return s;
}

- (id)popObjectForKey:(id)aKey {
    LOCK(id o = [_dic popObjectForKey:aKey]) return o;
}

- (NSDictionary *)popEntriesForKeys:(NSArray *)keys {
    LOCK(NSDictionary * d = [_dic popEntriesForKeys:keys]) return d;
}

@end
