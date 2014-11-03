//
//  UITextField+YYAdd.h
//  YYKit
//
//  Created by ibireme on 14-5-12.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Provides extensions for `UITextField`.
 */
@interface UITextField (YYAdd)

/**
 Set all text selected.
 */
- (void)selectAllText;

/**
 Set text in range selected.
 
 @param range  The range of selected text in a document.
 */
- (void)setSelectedRange:(NSRange)range;

@end
