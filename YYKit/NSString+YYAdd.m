//
//  NSString+Add.m
//  YYCore
//
//  Created by ibireme on 13-4-3.
//  2013 ibireme.
//

#import "NSString+YYAdd.h"
#import "YYCoreMacro.h"
#import "NSData+YYAdd.h"

DUMMY_CLASS(NSString_YYAdd)

@implementation NSString (YYAdd)

- (NSString *)md5 {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5];
}

- (NSString *)sha1{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1];
}

- (NSString *)sha224{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha224];
}

- (NSString *)sha256{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256];
}

- (NSString *)sha384{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha384];
}

- (NSString *)sha512{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512];
}

/// hmac with (message digest algorithm) sha1 
- (NSString *)hmacWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacWithKey:key];
}

- (NSString *)stringByBase64Encoding {
    if ([self length] == 0) {
        return nil;
	}
	return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}


- (NSString *)hexString {
    const char *chars = [self UTF8String];
    return [[NSData dataWithBytes:chars length:strlen(chars)] hexString];
}

- (NSString *)AES128EncryptWithKey:(NSString *)key {
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES128EncryptWithKey:key];
    return [encryptedData base64EncodedString];
}

- (NSString *)AES128DecryptWithKey:(NSString *)key {
    NSData *encryptedData = [NSData dataWithBase64String:self];
    NSData *plainData = [encryptedData AES128DecryptWithKey:key];
    return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
}

- (NSString *)AES256EncryptWithKey:(NSString *)key{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES256EncryptWithKey:key];
    return [encryptedData base64EncodedString];
}

- (NSString *)AES256DecryptWithKey:(NSString *)key{
    NSData *encryptedData = [NSData dataWithBase64String:self];
    NSData *plainData = [encryptedData AES256DecryptWithKey:key];
    return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
}

+ (NSString *)stringWithUUID {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	return (__bridge_transfer NSString *)string;
}

+ (NSString *)stringWithBase64String:(NSString *)base64String {
	return [[NSString alloc] initWithData:[NSData dataWithBase64String:base64String]
                                 encoding:NSUTF8StringEncoding];
}




- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsString:(NSString *)string {
    return !NSEqualRanges([self rangeOfString:string], NSMakeRange(NSNotFound, 0));
}


- (NSString *)stringByTrim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByAdd2XPath {
    NSString *fileName = [[self pathComponents] lastObject];
    if (![fileName isNotBlank]) {
        return self;
    }
    NSString *ext = [fileName pathExtension];
    if (![ext isNotBlank]) {
        return self;
    }
    NSString *fileNameWith2x = nil;
    NSString *fileNameWithoutExt = [fileName substringToIndex:fileName.length - ext.length - 1];
    if (fileNameWithoutExt) {
        if ([fileNameWithoutExt hasSuffix:@"@2x"]) {
            return self;
        } else {
            fileNameWith2x = [fileNameWithoutExt stringByAppendingFormat:@"@2x.%@", ext];
        }
    } else {
        return self;
    }
    return [[self substringToIndex:self.length - fileName.length] stringByAppendingString:fileNameWith2x];
}


- (NSString *)stringByURLEncode {
    NSString *encoded = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (__bridge CFStringRef)self,
            CFSTR("-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"),
            CFSTR("!#$&'()*+,/:;=?@[]"),
            kCFStringEncodingUTF8);
    return encoded;
}

- (NSString *)stringByURLDecode {
    NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    decoded = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)decoded, CFSTR(""), kCFStringEncodingUTF8);
    return decoded;
}

@end
