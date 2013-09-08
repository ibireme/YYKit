//
//  NSData+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import <Foundation/Foundation.h>


/**
 Provide hash and encode method for `NSData`.
 */
@interface NSData (YYAdd)


///=============================================================================
/// @name Hash
///=============================================================================


/**
 Return a lowercase NSString for md2 hash.
 */
- (NSString *)md2String;

/**
 Return an NSData for md2 hash.
 */
- (NSData *)md2Data;

/**
 Return a lowercase NSString for md4 hash.
 */
- (NSString *)md4String;

/**
 Return an NSData for md4 hash.
 */
- (NSData *)md4Data;

/**
 Return a lowercase NSString for md5 hash.
 */
- (NSString *)md5String;

/**
 Return an NSData for md5 hash.
 */
- (NSData *)md5Data;

/**
 Return a lowercase NSString for sha1 hash.
 */
- (NSString *)sha1String;

/**
 Return an NSData for sha1 hash.
 */
- (NSData *)sha1Data;

/**
 Return a lowercase NSString for sha224 hash.
 */
- (NSString *)sha224String;

/**
 Return an NSData for sha224 hash.
 */
- (NSData *)sha224Data;

/**
 Return a lowercase NSString for sha256 hash.
 */
- (NSString *)sha256String;

/**
 Return an NSData for sha256 hash.
 */
- (NSData *)sha256Data;

/**
 Return a lowercase NSString for sha384 hash.
 */
- (NSString *)sha384String;

/**
 Return an NSData for sha384 hash.
 */
- (NSData *)sha384Data;

/**
 Return a lowercase NSString for sha512 hash.
 */
- (NSString *)sha512String;

/**
 Return an NSData for sha512 hash.
 */
- (NSData *)sha512Data;

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

/**
 Return crc32 hash.
 */
- (uint32_t)crc32;

///=============================================================================
/// @name Encrypt and Decrypt
///=============================================================================


/**
 Return an encrypted NSData using AES.
 
 @param key A key length of 16, 24 or 32 (128, 192 or 256bits).
 @param iv An initialization vector length of 16(128bits).
    Pass nil when you don't want to use iv.
 @return An NSData encrypted, or nil when error occured.
 */
- (NSData *)aes256EncryptWithKey:(NSData *)key iv:(NSData *)iv;

/**
 Return an decrypted NSData using AES.
 
 @param key A key length of 16, 24 or 32 (128, 192 or 256bits).
 @param iv An initialization vector length of 16(128bits).
    Pass nil when you don't want to use iv.
 @return An NSData decrypted, or nil when error occured.
 */
- (NSData *)aes256DecryptWithkey:(NSData *)key iv:(NSData *)iv;


///=============================================================================
/// @name Encode and decode
///=============================================================================


/**
 Return a uppercase NSString for HEX.
 */
- (NSString *)hexString;

/**
 Return an NSData from hex string.
 @param hexString The hex string which is case insensitive.
 @return a new NSData, or nil when error occured.
 */
+ (NSData *)dataWithHexString:(NSString *)hexString;

/**
 Return an NSString for base64 encoded.
 
 @warning This method has been implemented in iOS7.
 */
- (NSString *)base64Encoding;

/**
 Return an NSData from base64 encoded string.
 
 @warning This method has been implemented in iOS7.
 
 @param base64Encoding The encoded string.
 */
+ (NSData *)dataWithBase64Encoding:(NSString *)base64Encoding;


///=============================================================================
/// @name Inflate and deflate
///=============================================================================


/**
 Decompress data from gzip data.
 
 @return Inflated data.
 */
- (NSData *)gzipInflate;

/**
 Comperss data to gzip in default compresssion level.
 
 @return Deflated data.
 */
- (NSData *)gzipDeflate;


/**
 Decompress data from zlib-compressed data.
 
 @return Inflated data.
 */
- (NSData *) zlibInflate;

/**
 Comperss data to zlib-compressed in default compresssion level.
 
 @return Deflated data.
 */
- (NSData *) zlibDeflate;

@end
