//
//  NSArray+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import <Foundation/Foundation.h>

/**
 Provide some some common method for `NSArray`.
 */
@interface NSArray (YYAdd)



/**
 Returns the object in the array with the lowest index value.
 
 @warning This method has been implemented in iOS7.
 
 @return The object in the array with the lowest index value. 
   If the array is empty, returns nil.
 */
- (id)firstObject;


/**
 Returns the object located at a random index.
 
 @return The object in the array with a random index value. 
    If the array is empty, returns nil.
 */
- (id)randomObject;

/**
 Returns the object located at index, or return nil when out of bounds.
 
 It's similar to `objectAtIndex:`, but it never throw exception.
 
 @param index The object located at index.
 */
- (id)objectOrNilAtIndex:(NSUInteger)index;

@end


/**
 Provide some some common method for `NSMutableArray`.
 */
@interface NSMutableArray (YYAdd)

/**
 Inserts a given object at the end of the array.
 If the object is nil, it just return and do not throw exception.
 
 @param anObject The object to add to the end of the array's content. 
    When the value is nil, nothing happened.
 */
- (void)addObjectOrNil:(id)anObject;

/**
 Removes the object with the lowest-valued index in the array.
 
 If the array is empty, nothing will happen.
 */
- (void)removeFirstObject;


/**
 Reverse the index of object in this array.
 
 Example: Before @[ @1, @2, @3 ] After @[ @3, @2, @1 ]
 */
- (void) reverse;

/**
 Sort the object in this array randomly.
 */
- (void) shuffle;

@end