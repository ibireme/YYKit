//
//  NSKeyedUnarchiver+YYAdd.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/8/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

/**
 Provides extensions for `NSKeyedUnarchiver`.
 */
@interface NSKeyedUnarchiver (YYAdd)

/**
 Same as unarchiveObjectWithData:, except it returns the exception by reference.
 
 @param data       The data need unarchived.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said pointer is not NULL, point to said NSException.
 */
+ (id)unarchiveObjectWithData:(NSData *)data exception:(__autoreleasing NSException **)exception;

/**
 Same as unarchiveObjectWithFile:, except it returns the exception by reference.
 
 @param path       The path of archived object file.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said  pointer is not NULL, point to said NSException.
 */
+ (id)unarchiveObjectWithFile:(NSString *)path exception:(__autoreleasing NSException **)exception;

@end
