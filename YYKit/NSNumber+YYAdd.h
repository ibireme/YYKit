//
//  NSNumber+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-8-24.
//  Copyright (c) 2013 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provide a method to parse `NSString` for `NSNumber`.
 */
@interface NSNumber (YYAdd)

/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse success, or nil if an error occurs.
 */
+ (NSNumber *)numberWithString:(NSString *)string;

/**
    Convert [NSNumber doubleValue] to NSString
 @param format  format for uputput.
 @return NSString
 */
- (NSString*)toStringWithFormat:(NSString*)format;

/**
 Convert NSNumber to NSString with currency formatting
 @return NSString
 */
-(NSString *)toStringCurrentCurrency;

/**
 Calculate factorual
 
 @return NSNumber
 */
- (NSNumber *)factorial;

/**
 Multiplied by the percentage
 
 @return NSNumber
 */
- (NSNumber *)multpercent:(NSNumber *)pValue;

/**
 Add percentage to value
 
 @return NSNumber
 */
- (NSNumber *)addpercent:(NSNumber *)pValue;



@end
