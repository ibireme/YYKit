//
//  YYGestureRecognizer.m
//  YYKit
//
//  Created by ibireme on 14/10/26.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation YYGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateBegan;
    _startPoint = [(UITouch *)[touches anyObject] locationInView : self.view];
    _lastPoint = _currentPoint;
    _currentPoint = _startPoint;
    if (_action) _action(self, YYGestureRecognizerStateBegan);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    self.state = UIGestureRecognizerStateChanged;
    _currentPoint = currentPoint;
    if (_action) _action(self, YYGestureRecognizerStateMoved);
    _lastPoint = _currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateEnded;
    if (_action) _action(self, YYGestureRecognizerStateEnded);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
    if (_action) _action(self, YYGestureRecognizerStateCancelled);
}

- (void)reset {
    self.state = UIGestureRecognizerStatePossible;
}

- (void)cancel {
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateCancelled;
        if (_action) _action(self, YYGestureRecognizerStateCancelled);
    }
}

@end
