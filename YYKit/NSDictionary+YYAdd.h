//
//  NSDictionary+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import <UIKit/UIKit.h>


/**
 Provide some some common method for `NSDictionary`.
 */
@interface NSDictionary (YYAdd)

/**
 Returns a new array containing the dictionary’s keys sorted.
 
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary’s keys, 
    or an empty array if the dictionary has no entries.
 */
- (NSArray *)allKeysSorted;


/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary’s values sorted by keys, 
 or an empty array if the dictionary has no entries. */
- (NSArray *)allValuesSortedByKeys;


/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 Returns the CGPoint associated with a given key.
 
 @see NSMutableDictionary(YYAdd)
 @param key The key for which to return the corresponding CGPoint.
 @return The point associated with aKey, 
    or nil if no value is associated with key.
 */
- (CGPoint)pointForKey:(NSString *)key;

/**
 Returns the CGSize associated with a given key.
 
 @see NSMutableDictionary(YYAdd)
 @param key The key for which to return the corresponding CGSize.
 @return The size associated with aKey,
 or nil if no value is associated with key.
 */
- (CGSize)sizeForKey:(NSString *)key;

/**
 Returns the CGRect associated with a given key.
 
 @see NSMutableDictionary(YYAdd)
 @param key The key for which to return the corresponding CGRect.
 @return The rect associated with aKey,
 or nil if no value is associated with key.
 */
- (CGRect)rectForKey:(NSString *)key;
@end





/**
 Provide some some common method for `NSMutableDictionary`.
 */
@interface NSMutableDictionary (YYAdd)

/**
 Adds a given key-value pair to the dictionary.
 
 The value must be a CGPoint.
 
 @param key The key for value.
 @param value An CGPoint. this CGPoint struct will be copied as an object.
 */
- (void)setPoint:(CGPoint)value forKey:(NSString *)key;

/**
 Adds a given key-value pair to the dictionary.
 
 The value must be a CGSize.
 
 @param key The key for value.
 @param value An CGSize. this CGSize struct will be copied as an object.
 */
- (void)setSize:(CGSize)value forKey:(NSString *)key;

/**
 Adds a given key-value pair to the dictionary.
 
 The value must be a CGRect.
 
 @param key The key for value.
 @param value An CGRect. this CGRect struct will be copied as an object.
 */
- (void)setRect:(CGRect)value forKey:(NSString *)key;

@end