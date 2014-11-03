//
//  YYFileHash.m
//  YYKit
//
//  Created by ibireme on 14/11/2.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYFileHash.h"
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h>

#define BUF_SIZE (1024 * 64) //64 KB
#define BLOCK_LOOP_FACTOR 8 // 512 (64*8) KB per block callback


@implementation YYFileHash

+ (YYFileHash *)hashForFile:(NSString *)filePath types:(YYFileHashType)types {
    return [self hashForFile:filePath types:types usingBlock:nil];
}

+ (YYFileHash *)hashForFile:(NSString *)filePath types:(YYFileHashType)types usingBlock:(void(^)(float progress, BOOL *stop))block {
    YYFileHash *hash = nil;
    
    BOOL stop = NO, done = NO;
    long file_size = 0, readed = 0, loop = 0;
    const char *path = 0;
    FILE *fd = 0;
    char *buf = NULL;
    
    int hash_type_total = 10;
    void *ctx[hash_type_total];
    int(*ctx_init[hash_type_total])(void *);
    int(*ctx_update[hash_type_total])(void *, const void *, CC_LONG);
    int(*ctx_final[hash_type_total])(unsigned char *, void *);
    long digist_length[hash_type_total];
    unsigned char *digest[hash_type_total];
    
    for (int i = 0; i < hash_type_total; i++) {
        ctx[i] = NULL;
        ctx_init[i] = NULL;
        ctx_update[i] = NULL;
        ctx_final[i] = NULL;
        digist_length[i] = 0;
        digest[i] = 0;
    }
    
    int ctx_index = 0;
    if (types & YYFileHashTypeMD2) {
        ctx[ctx_index] = malloc(sizeof(CC_MD2_CTX));
        ctx_init[ctx_index] = (int (*)(void *))CC_MD2_Init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))CC_MD2_Update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))CC_MD2_Final;
        digist_length[ctx_index] = CC_MD2_DIGEST_LENGTH;
    }
    ctx_index++;
    if (types & YYFileHashTypeMD4) {
        ctx[ctx_index] = malloc(sizeof(CC_MD4_CTX));
        ctx_init[ctx_index] = (int (*)(void *))CC_MD4_Init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))CC_MD4_Update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))CC_MD4_Final;
        digist_length[ctx_index] = CC_MD4_DIGEST_LENGTH;
    }
    ctx_index++;
    if (types & YYFileHashTypeMD5) {
        ctx[ctx_index] = malloc(sizeof(CC_MD5_CTX));
        ctx_init[ctx_index] = (int (*)(void *))CC_MD5_Init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))CC_MD5_Update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))CC_MD5_Final;
        digist_length[ctx_index] = CC_MD5_DIGEST_LENGTH;
    }
    ctx_index++;
    if (types & YYFileHashTypeSHA1) {
        ctx[ctx_index] = malloc(sizeof(CC_SHA1_CTX));
        ctx_init[ctx_index] = (int (*)(void *))CC_SHA1_Init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))CC_SHA1_Update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))CC_SHA1_Final;
        digist_length[ctx_index] = CC_SHA1_DIGEST_LENGTH;
    }
    ctx_index++;
    if (types & YYFileHashTypeSHA224) {
        ctx[ctx_index] = malloc(sizeof(CC_SHA256_CTX));
        ctx_init[ctx_index] = (int (*)(void *))CC_SHA224_Init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))CC_SHA224_Update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))CC_SHA224_Final;
        digist_length[ctx_index] = CC_SHA224_DIGEST_LENGTH;
    }
    ctx_index++;
    if (types & YYFileHashTypeSHA256) {
        ctx[ctx_index] = malloc(sizeof(CC_SHA256_CTX));
        ctx_init[ctx_index] = (int (*)(void *))CC_SHA256_Init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))CC_SHA256_Update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))CC_SHA256_Final;
        digist_length[ctx_index] = CC_SHA256_DIGEST_LENGTH;
    }
    ctx_index++;
    if (types & YYFileHashTypeSHA384) {
        ctx[ctx_index] = malloc(sizeof(CC_SHA512_CTX));
        ctx_init[ctx_index] = (int (*)(void *))CC_SHA384_Init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))CC_SHA384_Update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))CC_SHA384_Final;
        digist_length[ctx_index] = CC_SHA384_DIGEST_LENGTH;
    }
    ctx_index++;
    if (types & YYFileHashTypeSHA512) {
        ctx[ctx_index] = malloc(sizeof(CC_SHA512_CTX));
        ctx_init[ctx_index] = (int (*)(void *))CC_SHA512_Init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))CC_SHA512_Update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))CC_SHA512_Final;
        digist_length[ctx_index] = CC_SHA512_DIGEST_LENGTH;
    }
    ctx_index++;
    if (types & YYFileHashTypeCRC32) {
        ctx[ctx_index] = malloc(sizeof(uLong));
        ctx_init[ctx_index] = (int (*)(void *))crc32_init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))crc32_update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))crc32_final;
        digist_length[ctx_index] = sizeof(uint32_t);
    }
    ctx_index++;
    if (types & YYFileHashTypeAdler32) {
        ctx[ctx_index] = malloc(sizeof(uLong));
        ctx_init[ctx_index] = (int (*)(void *))adler32_init;
        ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))adler32_update;
        ctx_final[ctx_index] = (int (*)(unsigned char *, void *))adler32_final;
        digist_length[ctx_index] = sizeof(uint32_t);
    }
    
    int hash_type_this = 0;
    for (int i = 0; i < hash_type_total; i++) {
        if (digist_length[i]) {
            hash_type_this++;
            digest[i] = malloc(digist_length[i]);
            if (digest[i] == NULL || ctx[i] == NULL) goto cleanup;
        }
    }
    if (hash_type_this == 0) goto cleanup;
    
    buf = malloc(BUF_SIZE);
    if (!buf) goto cleanup;
    
    if (filePath.length == 0) goto cleanup;
    path = [filePath cStringUsingEncoding:NSUTF8StringEncoding];
    fd = fopen(path, "rb");
    if (!fd) goto cleanup;
    
    if (fseek(fd, 0, SEEK_END) != 0) goto cleanup;
    file_size = ftell(fd);
    if (fseek(fd, 0, SEEK_SET) != 0) goto cleanup;
    if (file_size < 0) goto cleanup;
    
    // init hash context
    for (int i = 0; i < hash_type_total; i++) {
        if (ctx[i]) ctx_init[i](ctx[i]);
    }
    
    // read stream and calculate checksum
    while (!done && !stop) {
        size_t size = fread(buf, 1, BUF_SIZE, fd);
        if (size < BUF_SIZE) {
            if (feof(fd)) done = YES;       // finish
            else { stop = YES; continue; }  // error
        }
        for (int i = 0; i < hash_type_total; i++) {
            if (ctx[i]) ctx_update[i](ctx[i], buf, (CC_LONG)size);
        }
        readed += size;
        if (!done && block) {
            loop++;
            if ((loop % BLOCK_LOOP_FACTOR) == 0) {
                float progress = (float)readed / (float)file_size;
                block(progress, &stop);
            }
        }
    }
    
    if (done && !stop) {
        hash = [YYFileHash new];
        hash->_types = types;
        for (int i = 0; i < hash_type_total; i++) {
            if (ctx[i]) {
                ctx_final[i](digest[i], ctx[i]);
                NSUInteger type = 1 << i;
                NSData *data = [NSData dataWithBytes:digest[i] length:digist_length[i]];
                NSMutableString *str = [NSMutableString string];
                unsigned char *bytes = (unsigned char *)data.bytes;
                for (NSUInteger d = 0; d < data.length; d++) {
                    [str appendFormat:@"%02x", bytes[d]];
                }
                switch (type) {
                    case YYFileHashTypeMD2: {
                        hash->_md2Data = data;
                        hash->_md2String = str;
                    } break;
                    case YYFileHashTypeMD4: {
                        hash->_md4Data = data;
                        hash->_md4String = str;
                    } break;
                    case YYFileHashTypeMD5: {
                        hash->_md5Data = data;
                        hash->_md5String = str;
                    } break;
                    case YYFileHashTypeSHA1: {
                        hash->_sha1Data = data;
                        hash->_sha1String = str;
                    } break;
                    case YYFileHashTypeSHA224: {
                        hash->_sha224Data = data;
                        hash->_sha224String = str;
                    } break;
                    case YYFileHashTypeSHA256: {
                        hash->_sha256Data = data;
                        hash->_sha256String = str;
                    } break;
                    case YYFileHashTypeSHA384: {
                        hash->_sha384Data = data;
                        hash->_sha384String = str;
                    } break;
                    case YYFileHashTypeSHA512: {
                        hash->_sha512Data = data;
                        hash->_sha512String = str;
                    } break;
                    case YYFileHashTypeCRC32: {
                        uint32_t hash32 = *((uint32_t *)bytes);
                        hash->_crc32 = hash32;
                        hash->_crc32String = [NSString stringWithFormat:@"%08x", hash32];
                    } break;
                    case YYFileHashTypeAdler32: {
                        uint32_t hash32 = *((uint32_t *)bytes);
                        hash->_adler32 = hash32;
                        hash->_adler32String = [NSString stringWithFormat:@"%08x", hash32];
                    } break;
                    default:
                        break;
                }
            }
        }
    }
    
cleanup:
    if (buf) free(buf);
    if (fd) fclose(fd);
    for (int i = 0; i < hash_type_total; i++) {
        if (ctx[i]) free(ctx[i]);
        if (digest[i]) free(digest[i]);
    }
    
    return hash;
}

static int crc32_init(uLong *c) {
    *c = crc32(0L, Z_NULL, 0);
    return 0;
}

static int crc32_update(uLong *c, const void *data, CC_LONG len) {
    *c = crc32(*c, data, len);
    return 0;
}

static int crc32_final(unsigned char *buf, uLong *c) {
    *((uint32_t *)buf) = (uint32_t)*c;
    return 0;
}

static int adler32_init(uLong *c) {
    *c = adler32(0L, Z_NULL, 0);
    return 0;
}

static int adler32_update(uLong *c, const void *data, CC_LONG len) {
    *c = adler32(*c, data, len);
    return 0;
}

static int adler32_final(unsigned char *buf, uLong *c) {
    *((uint32_t *)buf) = (uint32_t)*c;
    return 0;
}

@end
