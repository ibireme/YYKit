//
//  NSNumber+YYAdd.m
//  YYKit
//
//  Created by ibireme on 13-8-24.
//  Copyright (c) 2013 ibireme. All rights reserved.
//

#import "NSNumber+YYAdd.h"
#import "NSString+YYAdd.h"
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(NSNumber_YYAdd)


@implementation NSNumber (YYAdd)

+ (NSNumber *)numberWithString:(NSString *)string {
    NSString *str = [[string stringByTrim] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}


- (NSNumber *)factorial {
    return @(tgamma([self doubleValue] + 1));
}

- (NSNumber *)multpercent:(NSNumber *)pValue
{
    return @([self doubleValue]*[pValue doubleValue]/100.0);
}

- (NSNumber *)addpercent:(NSNumber *)pValue
{
    return @([self doubleValue]+[[self multpercent:pValue] doubleValue]);
}

- (NSString *)toStringWithFormat:(NSString*)format
{
    return [NSString stringWithFormat:format,[self doubleValue]];
}

-(NSString *)toStringCurrentCurrency
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:self];
}

@end
