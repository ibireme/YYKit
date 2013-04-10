//
//  UIControl+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-5.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface UIControl (YYAdd)

#warning  from SSToolkit
/** 
 Removes all targets and actions for all events from an internal dispatch table.
 */
- (void)removeAllTargets;

/**
 Sets exclusive target for specified event, all previous targets will be removed, usefull for table cells etc
 */
- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;


@end
