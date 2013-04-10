//
//  NSData+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface NSData (YYAdd)

- (NSString *)md5;

- (NSString *)sha1;

- (NSString *)sha224;

- (NSString *)sha256;

- (NSString *)sha384;

- (NSString *)sha512;

- (uint32_t)crc32;

- (NSString *)hmacWithKey:(NSString *)key;

- (NSString *)hexString;

- (NSString *)base64EncodedString;

+ (NSData *)dataWithBase64String:(NSString *)string;

- (id)initWithBase64String:(NSString *)string;

- (NSData *)AES128EncryptWithKey:(NSString *)key;

- (NSData *)AES128DecryptWithKey:(NSString *)key;

- (NSData *)AES256EncryptWithKey:(NSString *)key;

- (NSData *)AES256DecryptWithKey:(NSString *)key;

- (NSData *) zlibInflate;

- (NSData *) zlibDeflate;

- (NSData *) gzipInflate;

- (NSData *) gzipDeflate;

/// yy
- (NSString *)UTF8String;

@end
