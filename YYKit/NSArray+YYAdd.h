//
//  NSArray+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface NSArray (YYAdd)

- (NSMutableArray *)deepMutableCopy NS_RETURNS_RETAINED;

- (NSArray *)deepCopy NS_RETURNS_RETAINED;

///return nil if Array is empty
- (id)firstObject;

@end
