//
//  UIScreen+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-5.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface UIScreen (YYAdd)

- (CGRect)currentBounds;

- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;

- (BOOL)isRetina;

@end
