//
//  NSObject+Add.h
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright 2013 ibireme.
//

#import <Foundation/Foundation.h>

/**
 @discussion Common tasks for NSObject.
 */
@interface NSObject (YYAdd)



///=============================================================================
/// @name Sending Messages with variable params.                                    
///=============================================================================


/**
 Invokes a method of the receiver on the current thread with variable params.
 
 example code:
 <pre>
 [self performSelector:@selector(test::::) withObjects:@"a",@"b",@"c",@"d"];
 </pre>
 
 @param aSelector A selector that identifies the method to invoke. 
 The method should not have a significant return value and
 should take at lest one argument of type id.
 
 @param firstObj The first argument to pass to the method when it is invoked.
 Pass nil if the method does not take an argument.
 
 @param ... The variable arguments.
 
 @throw NSInvalidArgumentException
 */
- (id)performSelector:(SEL)aSelector withObjects:(id)firstObj, ...;


/**
 Invokes a method of the receiver on the current thread 
 with variable params after a delay.
 
 example code:
 <pre>
 [self performSelector:@selector(test::::) afterDelay:1.0 withObjects:@"a",@"b",@"c",@"d"];
 </pre>
 
 @param aSelector A selector that identifies the method to invoke.
 The method should not have a significant return value and
 should take at lest one argument of type id.
 
 @param delay The minimum time before which the message is sent. 
 Specifying a delay of 0 does not necessarily
 cause the selector to be performed immediately.
 The selector is still queued on the thread's run loop
 and performed as soon as possible.
 
 @param firstObj The first argument to pass to the method when it is invoked.
 Pass nil if the method does not take an argument.
 
 @param ... The variable arguments.
 
 @throw NSInvalidArgumentException
 */
- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay withObjects:(id)firstObj, ...;

/**
 Invokes a method of the receiver on the current thread after a delay.
 
 @param aSelector A selector that identifies the method to invoke.
 The method should not have a significant return value and
 should take no argument.
 
 @param delay The minimum time before which the message is sent.
 Specifying a delay of 0 does not necessarily
 cause the selector to be performed immediately.
 The selector is still queued on the thread’s run loop
 and performed as soon as possible.
 
 @throw NSInvalidArgumentException
 */
- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay;



///=============================================================================
/// @name Swap method (Swizzling)
///=============================================================================


/**
 Swap two method's implementation in one class.
 It`s very dangerous,be careful.
 
 @param originalSel Selector 1.
 @param newSel Selector 2.
 @return if success
 */
+ (BOOL)swizzleMethod:(SEL)originalSel withMethod:(SEL)newSel;

/**
 Swap two class method's implementation in one class.
 It`s very dangerous,be careful.
 
 @param originalSel Selector 1.
 @param newSel Selector 2.
 @return if success.
 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel withClassMethod:(SEL)newSel;





///=============================================================================
/// @name Associate value
///=============================================================================

/**
 Associate one object to `self`,as if it was a strong property (strong,nonatomic).
 
 @warning Do not copy this object, or you cannot get the associated value.
 @param value The object to associate.
 @param key The pointer to get value from `self`.
 */
- (void)associateValue:(id)value withKey:(void *)key;

/**
 Associate one object to `self`,as if it was a weak property (week,nonatomic).
 
 @warning Do not copy this object, or you cannot get the associated value.
 @param value The object to associate.
 @param key The pointer to get value from `self`.
 */
- (void)associateWeakValue:(id)value withKey:(void *)key;

/**
 Get the associated value from `self`.
 
 @param key The pointer to get value from `self`.
 */
- (id)associatedValueForKey:(void *)key;

/**
 Remove associate between value and `self`.
 
 @param value The value which associated.
 */
- (void)associatedValueRemove:(id)value;


///=============================================================================
/// @name Others
///=============================================================================


/**
 Get the class name use NSString.
 */
+ (NSString *)className;

/**
 Get the class name use NSString.
 */
- (NSString *)className;

@end
