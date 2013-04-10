//
//  NSObject+Add.h
//  YYCore
//
//  Created by ibireme on 13-4-3.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

/**
 * e.g. [self performSelector:@selector(test:::::) withObjects:@"a",@"b",@"c",@"d",@"e"];
 * @throw NSInvalidArgumentException
 *
 * if you want performSelector on Backround or MainThread,
 * put the method into dispatch block
 */
@interface NSObject (YYAdd)

- (id)performSelector:(SEL)aSelector withObjects:(id)firstObj, ...;

- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay withObjects:(id)firstObj, ...;

/// NSString Array
/// copy from DLIntrospection by Denis Lebedev 
+ (NSArray *)properties;
+ (NSArray *)instanceVariables;
+ (NSArray *)classMethods;
+ (NSArray *)instanceMethods;


/// dangerous! see http://cocoadev.com/wiki/MethodSwizzling
+ (BOOL)swizzleMethod:(SEL)originalSel withMethod:(SEL)newSel;

/// dangerous! see http://cocoadev.com/wiki/MethodSwizzling
+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)newSel;

@end
