//
//  NSCharacterSet+YYAdd.h
//  YYKit
//
//  Created by ibireme on 14-10-28.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides extensions for `NSCharacterSet`.
 */
@interface NSCharacterSet (YYAdd)

/**
 Returns a character set containing all Apple Emoji.
 */
+ (NSCharacterSet *)emojiCharacterSet;

@end



/**
 Provides extensions for `NSMutableCharacterSet`.
 */
@interface NSMutableCharacterSet (YYAdd)

/**
 Returns a character set containing all Apple Emoji.
 */
+ (NSMutableCharacterSet *)emojiCharacterSet;

@end
