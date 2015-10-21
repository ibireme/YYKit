//
//  NSString+Add.h
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright (c) 2013 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Provide hash, encrypt, encode and some common method for 'NSString'.
 */
@interface NSString (YYAdd)

#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)md2String;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)md4String;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)md5String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)sha1String;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)sha224String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)sha256String;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)sha384String;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)sha512String;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key The hmac key.
 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key The hmac key.
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key The hmac key.
 */
- (NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key The hmac key.
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key The hmac key.
 */
- (NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key The hmac key.
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (NSString *)crc32String;


#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 Returns an NSString for base64 encoded.
 */
- (NSString *)base64Encoding;

/**
 Returns an NSString from base64 encoded string.
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
 @param encoding  The encoding to use.
 @return URL encoded string
 */
- (NSString *)stringByURLEncode:(NSStringEncoding)encoding;

/**
 URL encode a string.
 @param encoding  The encoding to use.
 @return URL encoded string
 */
- (NSString *)stringByURLDecode:(NSStringEncoding)encoding;

/**
 Escape commmon HTML to Entity.
 Example: "a<b" will be escape to "a&lt;b".
 */
- (NSString *)stringByEscapingHTML;

#pragma mark - Drawing
///=============================================================================
/// @name Drawing
///=============================================================================

/**
 Returns the size of the string if it were rendered with the specified constraints.
 
 @param font          The font to use for computing the string size.
 
 @param size          The maximum acceptable size for the string. This value is
 used to calculate where line breaks and wrapping would occur.
 
 @param lineBreakMode The line break options for computing the size of the string.
 For a list of possible values, see NSLineBreakMode.
 
 @return              The width and height of the resulting string's bounding box.
 These values may be rounded up to the nearest whole number.
 */
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 Returns the width of the string if it were to be rendered with the specified
 font on a single line.
 
 @param font  The font to use for computing the string width.
 
 @return      The width of the resulting string's bounding box. These values may be
 rounded up to the nearest whole number.
 */
- (CGFloat)widthForFont:(UIFont *)font;

/**
 Returns the height of the string if it were rendered with the specified constraints.
 
 @param font   The font to use for computing the string size.
 
 @param width  The maximum acceptable width for the string. This value is used
 to calculate where line breaks and wrapping would occur.
 
 @return       The height of the resulting string's bounding box. These values
 may be rounded up to the nearest whole number.
 */
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;


#pragma mark - Regular Expression
///=============================================================================
/// @name Regular Expression
///=============================================================================

/**
 Whether it can match the regular expression
 
 @param regex  The regular expression
 
 @return YES if can match the regex; otherwize, NO.
 */
- (BOOL)matchesRegex:(NSString *)regex;

/**
 Match the regular expression, and executes a given block using each object in the matches.
 
 @param regex The regular expression
 
 @param block The block to apply to elements in the array of matches.
 The block takes four arguments:
 match: The match substring.
 index: The index of the element in matches.
 matchRange: The match range in this string.
 stop: A reference to a Boolean value. The block can set the value
 to YES to stop further processing of the array. The stop
 argument is an out-only argument. You should only ever set
 this Boolean to YES within the Block.
 */
- (void)enumerateRegexMatches:(NSString *)regex usingBlock:(void (^)(NSString *match, NSInteger index, NSRange matchRange, BOOL *stop))block;

/**
 Returns a new string containing matching regular expressions replaced with the template string.
 
 @param regex       The regular expression
 
 @param replacement The substitution template used when replacing matching instances.
 
 @return A string with matching regular expressions replaced by the template string.
 */
- (NSString *)stringByReplacingRegex:(NSString *)regex withString:(NSString *)replacement;


#pragma mark - Emoji
///=============================================================================
/// @name Emoji
///=============================================================================

/**
 Whether the receiver contains Apple Emoji (Unicode 6.0 standard 'unified').
 */
- (BOOL)containsEmoji;

/**
 Returns all Apple Emoji combines in a string.
 */
+ (NSString *)allEmoji;

/**
 Returns grouped Apple Emoji combines in a string.
 
 @param group Emoji group, support value: @"people" @"nature" @"object" @"places" @"symbols"
 */
+ (NSString *)allEmojiByGroup:(NSString *)group;

/**
 Returns all Apple Emoji combines in an array.
 */
+ (NSArray *)allEmojiArray;

/**
 Returns grouped Apple Emoji combines in an array.
 
 @param group Emoji group, support value: @"people" @"nature" @"object" @"places" @"symbols"
 */
+ (NSArray *)allEmojiArrayByGroup:(NSString *)group;


#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)stringWithUUID;

/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)stringByTrim;

/**
 Add scale modifier to the file name (without path extension),
 From @"name" to @"name@2x".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
- (NSString *)stringByAppendingNameScale:(CGFloat)scale;

/**
 Add scale modifier to the file path (with path extension),
 From @"name.png" to @"name@2x.png".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon."    </td><td>"icon.@2x"    </td></tr>
 <tr><td>"icon.png" </td><td>"icon@2x.png" </td></tr>
 <tr><td>"icon..png"</td><td>"icon.@2x.png"</td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
- (NSString *)stringByAppendingPathScale:(CGFloat)scale;

/**
 Return the path scale.
 
 e.g.
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
- (CGFloat)pathScale;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank;

/**
 Whether the receiver contains the given `string`.
 @param string A string to test the the receiver for
 */
- (BOOL)containsString:(NSString *)string;

/**
 Whether the receiver contains the character in set.
 @param set  A character set to test the the receiver for
 */
- (BOOL)containsCharacterSet:(NSCharacterSet *)set;

/**
 Try to parse this string and Returns an NSNumber.
 These format is valid: @"123" @".12f" @" 0x12FF "
 @return Returns NSNumber if parse success, Returns nil if an error occurs.
 */
- (NSNumber *)numberValue;

/**
 Returns an NSData using UTF-8 encoding.
 */
- (NSData *)dataValue;

/**
 Returns an NSDictionary/NSArray which is decoded from receiver.
 Returns nil if an error occurs.
 
 e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (id)jsonValueDecoded;

/**
 Create a string with the file in main bundle (similar to [UIImage imageNamed:]).
 
 @param name The file name (in main bundle).
 
 @return A new string create from the file in UTF-8.
 */
- (NSString *)stringNamed:(NSString *)name;

/**
 *  NSString to NSURL. http[s] autoadded
 *
 *  @return NSURL object
 */
-(NSURL*)toURL;

/**
 *  Create NSDate with format
 *
 *  @param formated string
 *
 *  @return NSDate object
 */
-(NSDate*)toDateWithFormat:(NSString*)format;

-(NSNumber*)calcExpression;
//    NSString *formula = @"FUNCTION(x , 'plusspercent:',a)+FUNCTION(x , 'plusspercent:',b)";
//    NSExpression *expr = [NSExpression expressionWithFormat:formula];
//    NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @(10), @"x",
//                            @(5), @"a",
//                            @(7), @"b",
//                            nil];
//
//        NSLog(@"%@", [expr operand]);
//    float result = [[expr expressionValueWithObject:object context:nil] floatValue];
//    NSLog(@"%f", result);



/**
 *  Calculate math Expressions with variables.
 * This set includes functions such as sqrt, log, ln, exp, ceiling, abs, trunc, floor, and several others.
 *
 *  @param params  (NSDictionary*)params
 * example
 * @code
 NSNumber*exaple = [@"x+a+b" calcExpressionWithParams:
 [NSDictionary dictionaryWithObjectsAndKeys:
 @(10), @"x",
 @(5.55), @"a",
 @(7), @"b",
 nil]];
 
 *
 *  @return NSNumber value
 */
-(NSNumber*)calcExpressionWithParams:(NSDictionary*)params;

/**
 *  Test Logical Expressions like
 *   @"1 + 2 > 2 || 4 - 2 = 0"
 *
 *
 *  @param string expression
 *
 *  @return BOOL value
 */
-(BOOL)testExpression;

/**
 *  NSString with int value
 *
 *  @param integer value
 *
 *  @return string value
 */
+(NSString*)withInteger:(NSInteger)integer;


#pragma mark - Validarots

/**
 *  Validate url string
 *
 *  @return BOOL
 */
-(BOOL)isValidURLString;

/**
 *  Validate email string
 *
 *  @return BOOL
 */
-(BOOL)isValidEmailString;

#pragma mark - ios URL Scheme
//https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007899-CH1-SW1
/**
 Try to call using ios Dieler
 string format : @"14085551234"
 */
-(void)nativeCallPhone;

/**
 Try to write email
 string must be valid email
 */
-(void)nativeEmail;

/**
 Try to call using Facetime
 string must be valid email or phone number
 */
-(void)nativeFacetime;

/**
 Try to SMS
 string must a phone number
 */
-(void)nativeSMS;

/**
 Try to open Maps
 string must be with valid params

 @code [@"q=San Francisco" sysMap];
 

 note: https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html#//apple_ref/doc/uid/TP40007899-CH5-SW1
 */
-(void)nativeMap;

///**
// Try to iTunes
// */
//-(void)sysiTunes;

/**
 Try to open YouTube
 string must be a VIDEO_IDENTIFIER
 */
-(void)nativeYouTube;

#pragma mark - ios path Files


/**
 *  Appending string to NSCachesDirectory path
 *
 *  @return new string cache path
 */
-(NSString*)pathAppCache;

/**
 *  Appending string to NSTemporaryDirectory path
 *
 *  @return new string tmp path
 */
-(NSString*)pathAppTemporary;

/**
 *  Appending string to NSDocumentDirectory path
 *
 *  @return new string Documents path
 */
-(NSString*)pathAppDocuments;

/**
 *  extracting filename from path
 *
 *  @return filename string
 */
-(NSString*)extractFilename;

@end
