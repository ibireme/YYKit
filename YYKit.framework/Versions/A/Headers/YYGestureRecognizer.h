//
//  YYGestureRecognizer.h
//  YYKit
//
//  Created by ibireme on 14/10/26.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/// State of the gesture
typedef NS_ENUM(NSUInteger, YYGestureRecognizerState) {
    YYGestureRecognizerStateBegan, ///< gesture start
    YYGestureRecognizerStateMoved, ///< gesture moved
    YYGestureRecognizerStateEnded, ///< gesture end
    YYGestureRecognizerStateCancelled, ///< gesture cancel
};

/**
 A simple UIGestureRecognizer subclass for recieve touch events.
 */
@interface YYGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGPoint startPoint; ///< start point
@property (nonatomic, readonly) CGPoint lastPoint; ///< last move point.
@property (nonatomic, readonly) CGPoint currentPoint; ///< current move point.

/// The action block invoked by every gesture event.
@property (nonatomic, copy) void (^action)(YYGestureRecognizer *gesture, YYGestureRecognizerState state);

/// Cancel the gesture for current touch.
- (void)cancel;

@end
