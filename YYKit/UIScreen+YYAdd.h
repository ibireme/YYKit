//
//  UIScreen+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-4-5.
//  Copyright 2013 ibireme.
//

#import <UIKit/UIKit.h>


/**
 Provide some some common method for `UIScreen`.
 */
@interface UIScreen (YYAdd)

/**
 Returns the bounds of the screen for the current device orientation.
 
 @return A rect indicating the bounds of the screen.
 @see boundsForOrientation:
 */
- (CGRect)currentBounds;


/**
 Returns the bounds of the screen for a given device orientation. `UIScreen`'s `bounds` method always returns the bounds
 of the screen of it in the portrait orientation.
 
 @param orientation The orientation to get the screen's bounds.
 @return A rect indicating the bounds of the screen.
 @see currentBounds
 */
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;



/**
 Returns a Boolean indicating if the screen is a Retina display.
 
 @return A Boolean indicating if the screen is a Retina display.
 */
- (BOOL)isRetina;

@end
