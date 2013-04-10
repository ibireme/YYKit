//
//  NSDictionary+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (YYAdd)

- (NSMutableDictionary *)deepMutableCopy NS_RETURNS_RETAINED;

- (NSDictionary *)deepCopy NS_RETURNS_RETAINED;

- (NSArray *)allKeysSorted;

- (NSArray *)allValuesSortedByKey;

@end
