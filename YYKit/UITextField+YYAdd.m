//
//  UITextField+YYAdd.m
//  YYKit
//
//  Created by ibireme on 14-5-12.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "UITextField+YYAdd.h"
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(UITextField_YYAdd)


@implementation UITextField (YYAdd)

- (void)selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
