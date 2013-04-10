//
//  UIScrollView+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-5.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YYAdd)

/// anime
- (void)scrollToTop;
- (void)scrollToBottom;
- (void)scrollToLeft;
- (void)scrollToRight;

- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)scrollToLeftAnimated:(BOOL)animated;
- (void)scrollToRightAnimated:(BOOL)animated;

@end
