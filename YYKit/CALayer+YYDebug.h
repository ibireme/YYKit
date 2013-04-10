//
//  CALayer+YYDebug.h
//  YYCore
//
//  Created by ibireme on 13-4-2.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (YYDebug)

- (void)debugDoFlashFrame;

- (void)debugDoFlashBounds;

- (void)debugDoFlashPosition;

- (void)debugDoFlashAnchorPoint;

- (void)debugLogFrameInfo;

@end
