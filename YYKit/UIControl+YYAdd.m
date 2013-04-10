//
//  UIControl+YYAdd.m
//  YYCore
//
//  Created by ibireme on 13-4-5.
//  2013 ibireme.
//

#import "UIControl+YYAdd.h"

#import "YYCoreMacro.h"
DUMMY_CLASS(UIControl_YYDebug)

@implementation UIControl (YYAdd)

- (void)removeAllTargets {
	[[self allTargets] enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
		[self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
	}];
}

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
	NSSet *targets = [self allTargets];
	for (id currentTarget in targets) {
		NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
		for (NSString *currentAction in actions) {
			[self removeTarget:currentTarget action:NSSelectorFromString(currentAction) forControlEvents:controlEvents];
		}
	}
	[self addTarget:target action:action forControlEvents:controlEvents];
}

@end
