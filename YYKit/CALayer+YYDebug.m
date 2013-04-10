//
//  CALayer+YYDebug.m
//  YYCore
//
//  Created by ibireme on 13-4-2.
//  2013 ibireme.
//

#import "CALayer+YYDebug.h"
#import "YYCoreMacro.h"
DUMMY_CLASS(CALayer_YYDebug)

@implementation CALayer (YYDebug)

- (void)debugDoFlashFrame{
    if (!self.superlayer) {
        return;
    }
    [self flashRect:self.frame inLayer:self.superlayer];
}

- (void)debugDoFlashBounds{
    if (!self.superlayer) {
        return;
    }
    [self flashRect:self.bounds inLayer:self];
}

- (void)debugDoFlashPosition{
    if (!self.superlayer) {
        return;
    }
    CGRect rect = CGRectMake(self.position.x - 2, self.position.y - 2, 4, 4);
    [self flashRect:rect inLayer:self.superlayer];
}

- (void)debugDoFlashAnchorPoint{
    if (!self.superlayer) {
        return;
    }
    CGRect rect = CGRectMake(self.anchorPoint.x * self.bounds.size.width - 2,
                             self.anchorPoint.y * self.bounds.size.height - 2,
                             4, 4);
    [self flashRect:rect inLayer:self];
}

- (void)flashRect:(CGRect)rect inLayer:(CALayer *)layer {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL mask = layer.masksToBounds;
        CALayer *tmpLayer= [CALayer layer];
        tmpLayer.frame = rect;
        layer.masksToBounds = NO;
        tmpLayer.backgroundColor = [UIColor whiteColor].CGColor;
        tmpLayer.shadowRadius = 4;
        tmpLayer.shadowOffset = CGSizeMake(0, 0);
        tmpLayer.shadowOpacity = 1;
        [layer addSublayer:tmpLayer];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            tmpLayer.opacity = 0;
            dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
            dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
                [tmpLayer removeFromSuperlayer];
                layer.masksToBounds = mask;
            });
        });
    });
}

- (void)debugLogFrameInfo{
        NSLog(@"frame:%@, bounds:%@, position:%@ anchor:%@",
              NSStringFromCGRect(self.frame),
              NSStringFromCGRect(self.bounds),
              NSStringFromCGPoint(self.position),
              NSStringFromCGPoint(self.anchorPoint));
}

@end
