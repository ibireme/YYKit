//
//  UIView+YYDebug.m
//
//  Created by ibireme on 13-3-29.
//  2013 ibireme.
//
#import "UIView+YYDebug.h"
#import "YYCoreMacro.h"
#import <QuartzCore/QuartzCore.h>

DUMMY_CLASS(UIView_YYDebug)

@implementation UIView (YYDebug)

- (void)debugDoFlashFrame {
    if (!self.superview) {
        return;
    }
    [self flashRect:self.frame inView:self.superview withText:@"Frame"];
}

- (void)debugDoFlashBounds {
    if (!self.superview) {
        return;
    }
    [self flashRect:self.bounds inView:self withText:@"Bounds"];
}

- (void)debugDoFlashCenter {
    if (!self.superview) {
        return;
    }
    CGRect rect = CGRectMake(self.center.x - 2, self.center.y - 2, 4, 4);
    [self flashRect:rect inView:self.superview withText:@"Center"];
}

- (void)flashRect:(CGRect)rect inView:(UIView *)view withText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL clips = view.clipsToBounds;
        UIView *tmpView = [[UIView alloc]initWithFrame:rect];
        tmpView.backgroundColor = [UIColor whiteColor];
        tmpView.layer.shadowRadius = 4;
        tmpView.layer.shadowOffset = CGSizeMake(0, 0);
        tmpView.layer.shadowOpacity = 1;
        if (rect.size.width > 20 && rect.size.height > 10) {
            UILabel *tmpLabel = [[UILabel alloc]initWithFrame:tmpView.bounds];
            tmpLabel.text = text;
            tmpLabel.backgroundColor = [UIColor clearColor];
            tmpLabel.textAlignment = UITextAlignmentCenter;
            tmpLabel.font = [UIFont systemFontOfSize:rect.size.width / 4];
            [tmpView addSubview:tmpLabel];
        }
        view.clipsToBounds = NO;
        [view addSubview:tmpView];
        [UIView animateWithDuration:0.3 delay:0.5 options:0 animations:^{
            tmpView.alpha = 0;
        }completion:^(BOOL finished){
            [tmpView removeFromSuperview];
            view.clipsToBounds = clips;
        }];
    });
}

- (void)debugLogFrameInfo {
    NSLog(@"frame:%@, bounds:%@, center:%@",
          NSStringFromCGRect(self.frame),
          NSStringFromCGRect(self.bounds),
          NSStringFromCGPoint(self.center));
}

@end
