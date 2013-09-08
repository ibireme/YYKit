//
//  UIScreen+YYAdd.m
//  YYKit
//
//  Created by ibireme on 13-4-5.
//  Copyright 2013 ibireme.
//

#import "UIScreen+YYAdd.h"
#import "YYKitMacro.h"

DUMMY_CLASS(UIScreen_YYDebug)

@implementation UIScreen (YYAdd)


- (CGRect)currentBounds {
	return [self boundsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}


- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation {
	CGRect bounds = [self bounds];
    
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		CGFloat buffer = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = buffer;
	}
	return bounds;
}

// should not predicate
- (BOOL)isRetina {
    return self.scale == 2;
}


@end
