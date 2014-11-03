//
//  YYFileHash.h
//  YYKit
//
//  Created by ibireme on 14/11/2.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

/// File hash algorithm type
typedef NS_OPTIONS (NSUInteger, YYFileHashType) {
    YYFileHashTypeMD2     = 1 << 0, ///< MD2 hash
    YYFileHashTypeMD4     = 1 << 1, ///< MD4 hash
    YYFileHashTypeMD5     = 1 << 2, ///< MD5 hash
    YYFileHashTypeSHA1    = 1 << 3, ///< SHA1 hash
    YYFileHashTypeSHA224  = 1 << 4, ///< SHA224 hash
    YYFileHashTypeSHA256  = 1 << 5, ///< SHA256 hash
    YYFileHashTypeSHA384  = 1 << 6, ///< SHA384 hash
    YYFileHashTypeSHA512  = 1 << 7, ///< SHA512 hash
    YYFileHashTypeCRC32   = 1 << 8, ///< crc32 checksum
    YYFileHashTypeAdler32 = 1 << 9, ///< adler32 checksum
};

/**
 A utility for calculate file's hash (checksum).
 
 Sample Code:
 
     YYFileHash *hash = [YYFileHash hashForFile:@"/tmp/test.iso" types:YYFileHashTypeMD5 | YYFileHashTypeSHA1];
     NSLog(@"md5:%@  sha1:%@",hash.md5String, hash.sha1String);
 
 */
@interface YYFileHash : NSObject


/**
 Start calculate file hash and return the result.
 
 @discussion The calling thread is blocked until the asynchronous hash progress 
 finished.
 
 @param filePath The path to the file to access.
 
 @param types    File hash algorithm types.
 
 @return File hash result, or nil when an error occurs.
 */
+ (YYFileHash *)hashForFile:(NSString *)filePath types:(YYFileHashType)types;


/**
 Start calculate file hash and return the result.
 
 @discussion The calling thread is blocked until the asynchronous hash progress
 finished or canceled.
 
 @param filePath The path to the file to access.
 
 @param types    File hash algorithm types.
 
 @param block    A block which is called in progress. The block takes two
 arguments: `progress` is a value from 0.0 to 1.0 indicated the hash progress; 
 `stop` is a reference to a Boolean value, which can be set to YES to stop 
 further processing. If the block stop the processing, it just returns nil.
 
 @return File hash result, or nil when an error occurs.
 */
+ (YYFileHash *)hashForFile:(NSString *)filePath types:(YYFileHashType)types usingBlock:(void(^)(float progress, BOOL *stop))block;



@property (nonatomic, readonly) YYFileHashType types;

@property (nonatomic, readonly) NSString *md2String;
@property (nonatomic, readonly) NSString *md4String;
@property (nonatomic, readonly) NSString *md5String;
@property (nonatomic, readonly) NSString *sha1String;
@property (nonatomic, readonly) NSString *sha224String;
@property (nonatomic, readonly) NSString *sha256String;
@property (nonatomic, readonly) NSString *sha384String;
@property (nonatomic, readonly) NSString *sha512String;
@property (nonatomic, readonly) NSString *crc32String;
@property (nonatomic, readonly) NSString *adler32String;

@property (nonatomic, readonly) NSData *md2Data;
@property (nonatomic, readonly) NSData *md4Data;
@property (nonatomic, readonly) NSData *md5Data;
@property (nonatomic, readonly) NSData *sha1Data;
@property (nonatomic, readonly) NSData *sha224Data;
@property (nonatomic, readonly) NSData *sha256Data;
@property (nonatomic, readonly) NSData *sha384Data;
@property (nonatomic, readonly) NSData *sha512Data;
@property (nonatomic, readonly) uint32_t crc32;
@property (nonatomic, readonly) uint32_t adler32;

@end
