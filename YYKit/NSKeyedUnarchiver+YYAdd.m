//
//  NSKeyedUnarchiver+YYAdd.m
//  YYKit
//
//  Created by ibireme on 14-8-4.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "NSKeyedUnarchiver+YYAdd.h"
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(NSKeyedUnarchiver_YYAdd)


@implementation NSKeyedUnarchiver (YYAdd)

+ (id)unarchiveObjectWithData:(NSData *)data exception:(__autoreleasing NSException **)exception {
    id object = nil;
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e)
    {
        if (exception) *exception = e;
    }
    @finally
    {
    }
    return object;
}

+ (id)unarchiveObjectWithFile:(NSString *)path exception:(__autoreleasing NSException **)exception {
    id object = nil;
    
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    @catch (NSException *e)
    {
        if (exception) *exception = e;
    }
    @finally
    {
    }
    return object;
}

@end
