//
//  YYGestureRecognizer.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/10/26.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// State of the gesture
typedef NS_ENUM(NSUInteger, YYGestureRecognizerState) {
    YYGestureRecognizerStateBegan, ///< gesture start
    YYGestureRecognizerStateMoved, ///< gesture moved
    YYGestureRecognizerStateEnded, ///< gesture end
    YYGestureRecognizerStateCancelled, ///< gesture cancel
};

/**
 A simple UIGestureRecognizer subclass for receive touch events.
 */
@interface YYGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) CGPoint startPoint; ///< start point
@property (nonatomic, readonly) CGPoint lastPoint; ///< last move point.
@property (nonatomic, readonly) CGPoint currentPoint; ///< current move point.

/// The action block invoked by every gesture event.
@property (nullable, nonatomic, copy) void (^action)(YYGestureRecognizer *gesture, YYGestureRecognizerState state);

/// Cancel the gesture for current touch.
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
