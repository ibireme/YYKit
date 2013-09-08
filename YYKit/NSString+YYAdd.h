//
//  NSString+Add.h
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright 2013 ibireme.
//

#import <Foundation/Foundation.h>

/**
 Provide hash, encode and some some common method for 'NSString'.
 */
@interface NSString (YYAdd)


///=============================================================================
/// @name Hash
///=============================================================================


/**
 Return a lowercase NSString for md2 hash.
 */
- (NSString *)md2String;

/**
 Return a lowercase NSString for md4 hash.
 */
- (NSString *)md4String;

/**
 Return a lowercase NSString for md5 hash.
 */
- (NSString *)md5String;

/**
 Return a lowercase NSString for sha1 hash.
 */
- (NSString *)sha1String;

/**
 Return a lowercase NSString for sha224 hash.
 */
- (NSString *)sha224String;

/**
 Return a lowercase NSString for sha256 hash.
 */
- (NSString *)sha256String;

/**
 Return a lowercase NSString for sha384 hash.
 */
- (NSString *)sha384String;

/**
 Return a lowercase NSString for sha512 hash.
 */
- (NSString *)sha512String;

/**
 Return a lowercase NSString for hmac using algorithm md5 with key.
 
 @param key The hmac key.
 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 Return a lowercase NSString for hmac using algorithm sha1 with key.
 
 @param key The hmac key.
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 Return a lowercase NSString for hmac using algorithm sha224 with key.
 
 @param key The hmac key.
 */
- (NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 Return a lowercase NSString for hmac using algorithm sha256 with key.
 
 @param key The hmac key.
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 Return a lowercase NSString for hmac using algorithm sha384 with key.
 
 @param key The hmac key.
 */
- (NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 Return a lowercase NSString for hmac using algorithm sha512 with key.
 
 @param key The hmac key.
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 Return a lowercase NSString for crc32 hash.
 */
- (NSString *)crc32String;


///=============================================================================
/// @name Encode and decode
///=============================================================================


/**
 Return an NSString for base64 encoded.
 */
- (NSString *)base64Encoding;

/**
 Return an NSString from base64 encoded string.
 
 @param base64Encoding The encoded string.
 */
+ (NSString *)stringWithBase64Encoding:(NSString *)base64Encoding;



/**
 URL encode a string in utf-8.
 
 @return the encoded string.
 */
- (NSString *)stringByURLEncode;


/**
 URL decode a string in utf-8.
 
 @return the decoded string.
 */
- (NSString *)stringByURLDecode;


/**
 URL encode a string.
 
 @param encoding The encoding to use.
 
 @return URL encoded string
 */
- (NSString *)stringByURLEncode:(NSStringEncoding)encoding;


/**
 URL encode a string.
 
 @param encoding The encoding to use.
 
 @return URL encoded string
 */
- (NSString *)stringByURLDecode:(NSStringEncoding)encoding;



/**
 Escape commmon HTML to Entity.
 
 Example: "a<b" will be escape to "a&lt;b".
 */
- (NSString *)stringByEscapingHTML;



///=============================================================================
/// @name Utilities
///=============================================================================


/**
 Return a new UUID NSString
 
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)stringWithUUID;

/**
 Trim blank (space and newline).
 
 @return the trimmed string.
 */
- (NSString *) stringByTrim;


/**
 nil, @"", @"  ", @"\n" will return NO, others will return YES.
 */
- (BOOL) isNotBlank;

/**
 Returns a BOOL if the receiver contains the given `string`.
 
 @param string A string to test the the receiver for
 */
- (BOOL) containsString:(NSString *)string;


/**
 Try to parse this string and return an NSNumber.
 
 These format is valid: @"123" @".12f" @" 0x12FF "
 
 @return return NSNumber if parse success, return nil if error occur.
 */
- (NSNumber*)numberValue;

/**
 Return an NSData using utf8 encoding.
 */
- (NSData *)dataValue;

@end
