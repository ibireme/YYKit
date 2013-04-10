//
//  NSString+Add.h
//  YYCore
//
//  Created by ibireme on 13-4-3.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface NSString (YYAdd)


- (NSString *)md5;

- (NSString *)sha1;

- (NSString *)sha224;

- (NSString *)sha256;

- (NSString *)sha384;

- (NSString *)sha512;

- (NSString *)hmacWithKey:(NSString *)key;

- (NSString *)hexString;

- (NSString *)stringByBase64Encoding;

+ (NSString *)stringWithBase64String:(NSString *)base64String;

- (NSString *)AES128EncryptWithKey:(NSString *)key;

- (NSString *)AES128DecryptWithKey:(NSString *)key;

- (NSString *)AES256EncryptWithKey:(NSString *)key;

- (NSString *)AES256DecryptWithKey:(NSString *)key;

/**
 * e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)stringWithUUID;


/**
 * nil    NO;
 * ""     NO;
 * " "    NO;
 * " \n"  NO;
 * "a"    YES;
 */
- (BOOL) isNotBlank;

- (BOOL) containsString:(NSString *)string;


/**
 * trim blank (space and newline)
 */
- (NSString*) stringByTrim;

/**
 * "cover.png" -> "cover@2x.png"
 * "cover@2x.png" -> "cover@2x.png"
 * "~/Library/tmp/2012 12 21.jpeg" -> "~/Library/tmp/2012 12 21@2x.jpeg"
 */
- (NSString *) stringByAdd2XPath;

#warning test
- (NSString *)stringByURLEncode;

- (NSString *)stringByURLDecode;

@end
