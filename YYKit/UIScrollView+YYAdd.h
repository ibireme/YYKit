//
//  UIScrollView+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-4-5.
//  Copyright 2013 ibireme.
//

#import <UIKit/UIKit.h>


/**
 Provide some some common method for `UIScrollView`.
 */
@interface UIScrollView (YYAdd)

/**
 Scroll content to top with animeation.
 */
- (void)scrollToTop;

/**
 Scroll content to bottom with animeation.
 */
- (void)scrollToBottom;

/**
 Scroll content to left with animeation.
 */
- (void)scrollToLeft;

/**
 Scroll content to right with animeation.
 */
- (void)scrollToRight;


/**
 Scroll content to top.
 @param animated Use animation.
 */
- (void)scrollToTopAnimated:(BOOL)animated;

/**
 Scroll content to bottom.
 @param animated Use animation.
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 Scroll content to left.
 @param animated Use animation.
 */
- (void)scrollToLeftAnimated:(BOOL)animated;

/**
 Scroll content to right.
 @param animated Use animation.
 */
- (void)scrollToRightAnimated:(BOOL)animated;

@end
