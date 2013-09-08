//
//  NSArray+YYAdd.m
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import "NSArray+YYAdd.h"
#import "YYKitMacro.h"

DUMMY_CLASS(NSArray_YYAdd)
@implementation NSArray (YYAdd)


- (id)firstObject {
    if (self.count)
        return self[0];
    return nil;
}

- (id)randomObject {
	if (self.count) {
	    return self[arc4random_uniform(self.count)];
	}
    return nil;
}

- (id)objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

@end


/**
 Provide some some common method for `NSMutableArray`.
 */
@implementation NSMutableArray (YYAdd)

- (void)addObjectOrNil:(id)anObject{
    if (anObject) {
        [self addObject:anObject];
    }
}


- (void)removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)reverse {
    int count = self.count;
    int mid = floor(count / 2.0);
    for (int i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform(i)];
    }
}




@end