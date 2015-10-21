//
//  NSIndexPath+YYAdd.m
//  YYKit
//
//  Created by Andrii Tishchenko on 21.04.15.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "NSIndexPath+YYAdd.h"
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(NSIndexPath_YYAdd)

@implementation NSIndexPath (YYAdd)
-(NSUInteger)hash{
    char str[11];
    NSInteger row = (NSInteger)self.row;
    NSInteger section = (NSInteger)self.section;
    sprintf(str, "%ld%ld", (long)section,(long)row);
    
    NSUInteger val = 0;
    char *p;
    NSInteger i;
    p = str;
    for(i = 0; p[ i ]; i++){
        if (i ==0) {
            val = (unsigned char)p[i] << CHAR_BIT;
        }
        else
            val |= (unsigned char)p[i];
    }
    return val;
}
@end
