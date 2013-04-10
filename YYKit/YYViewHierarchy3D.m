//
//  YYViewHierarchy3D.m
//
//  Created by ibireme on 13-3-8.
//  2013 ibireme.
//

#import "YYViewHierarchy3D.h"
#import "YYCoreMacro.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>


@interface YYViewHierarchy3D () {
    float rotateX;
    float rotateY;
    float dist;
    BOOL isAnimatimg;
}
+ (YYViewHierarchy3D *)sharedInstance;
- (void)toggleShow;
@property (nonatomic, retain) NSMutableArray *holders;
@end


#pragma mark - Top Shortcut
@interface  YYViewHierarchy3DTop : UIWindow
+ (YYViewHierarchy3DTop *)sharedInstance;
@end

@implementation YYViewHierarchy3DTop

+ (YYViewHierarchy3DTop *)sharedInstance {
    static dispatch_once_t once;
    static YYViewHierarchy3DTop *singleton;
    dispatch_once(&once, ^{
        singleton = [[YYViewHierarchy3DTop alloc] init];
    });
    return singleton;
}

- (id)init {
    CGRect frame = CGRectMake(40, 40, 40, 40);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100.0f;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake(5, 5, 30, 30);
        btn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        btn.layer.cornerRadius = 15;
        btn.layer.shadowOpacity = YES;
        btn.layer.shadowRadius = 4;
        btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 0);
        UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [btn addGestureRecognizer:g];
        [btn addTarget:[YYViewHierarchy3D sharedInstance] action:@selector(toggleShow) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    static CGRect oldFrame;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        oldFrame = self.frame;
    }
    CGPoint change = [gestureRecognizer translationInView:self];
    CGRect newFrame = oldFrame;
    newFrame.origin.x += change.x;
    newFrame.origin.y += change.y;
    self.frame = newFrame;
}

@end









@interface UIView (holderFrame)
@property (nonatomic, readonly) CGRect holderFrame;
- (CGRect)holderFrameWithDelta:(CGPoint)delta;
@end
@implementation UIView (holderFrame)

- (CGRect)holderFrame {
    CGRect r = CGRectMake(self.center.x - self.bounds.size.width / 2,
                          self.center.y - self.bounds.size.height / 2,
                          self.bounds.size.width,
                          self.bounds.size.height);
    return r;
}

- (CGRect)holderFrameWithDelta:(CGPoint)delta {
    CGRect r = CGRectMake(self.center.x - self.bounds.size.width / 2 + delta.x,
                          self.center.y - self.bounds.size.height / 2 + delta.y,
                          self.bounds.size.width,
                          self.bounds.size.height);
    return r;
}

@end

@interface ViewImageHolder : NSObject
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) float deep;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, retain) UIView *view;

@end

@implementation ViewImageHolder
@synthesize image = _image;
@synthesize deep = _deep;
@synthesize rect = _rect;
@synthesize view = _view;


@end




@implementation YYViewHierarchy3D
@synthesize holders = _holders;
+ (YYViewHierarchy3D *)sharedInstance {
    static dispatch_once_t once;
    static YYViewHierarchy3D *singleton;
    dispatch_once(&once, ^{
        singleton = [[YYViewHierarchy3D alloc] init];
    });
    return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.windowLevel = UIWindowLevelStatusBar + 99.0f;
        UIPanGestureRecognizer *gPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        UIPinchGestureRecognizer *gPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [self addGestureRecognizer:gPan];
        [self addGestureRecognizer:gPinch];
    }
    return self;
}

- (void)toggleShow {
    if (isAnimatimg) {
        return;
    }
    if (self.hidden) {
        self.hidden = NO;
        self.frame = [UIScreen mainScreen].bounds;
        [self startShow];
    } else {
        [self startHide];
    }
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    static CGPoint oldPan;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        oldPan = CGPointMake(rotateY, -rotateX);
    }
    CGPoint change = [gestureRecognizer translationInView:self];
    rotateY =  oldPan.x + change.x;
    rotateX = -oldPan.y - change.y;
    [self anime:0.1];
}

- (void)pinch:(UIPinchGestureRecognizer *)gestureRecognizer {
    static float oldScale;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        oldScale = gestureRecognizer.scale;
    }
    dist = (gestureRecognizer.scale - oldScale) * 10;
    [self anime:0.1];
}


- (void)anime:(float)time {
    CATransform3D trans = CATransform3DIdentity;
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -0.001;

    trans = CATransform3DMakeTranslation(0, 0, dist * 100);
    trans = CATransform3DConcat(CATransform3DMakeRotation(DegreesToRadians(rotateX), 1, 0, 0), trans);
    trans = CATransform3DConcat(CATransform3DMakeRotation(DegreesToRadians(rotateY), 0, 1, 0), trans);
    trans = CATransform3DConcat(CATransform3DMakeRotation(DegreesToRadians(0), 0, 0, 1), trans);
    trans = CATransform3DConcat(trans, t);

    isAnimatimg = YES;
    [UIView animateWithDuration:time animations:^() {
        for (ViewImageHolder * holder in self.holders) {
            holder.view.layer.transform = trans;
        }
    } completion:^(BOOL finished) {
        isAnimatimg = NO;
    }];
}

+ (void)show {
    [YYViewHierarchy3DTop sharedInstance].hidden = NO;
    [YYViewHierarchy3D sharedInstance].hidden = YES;
}

+ (void)hide {
    [YYViewHierarchy3DTop sharedInstance].hidden = YES;
    [YYViewHierarchy3D sharedInstance].hidden = YES;
}


- (UIImage *)renderImageFromView:(UIView *)view {
    return [self renderImageFromView:view withRect:view.bounds];
}

- (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
    [view.layer renderInContext:context];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (UIImage *)renderImageForAntialiasing:(UIImage *)image {
    return [self renderImageForAntialiasing:image withInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

- (UIImage *)renderImageForAntialiasing:(UIImage *)image withInsets:(UIEdgeInsets)insets {
    CGSize imageSizeWithBorder = CGSizeMake([image size].width + insets.left + insets.right,
                                            [image size].height + insets.top + insets.bottom);
    
    UIGraphicsBeginImageContextWithOptions(imageSizeWithBorder,
                                           UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);
    
    [image drawInRect:(CGRect) {{ insets.left, insets.top }, [image size] }];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (void) dumpView:(UIView *)aView
           atDeep:(float)deep
    atOriginDelta:(CGPoint)originDelta
          toArray:(NSMutableArray *)holders {
    
    NSMutableArray *notHiddens = [NSMutableArray arrayWithCapacity:0];
    for (UIView *v in aView.subviews) {
        if (!v.hidden) {
            [notHiddens addObject:v];
            v.hidden = YES;
        }
    }
    UIImage *img = [self renderImageFromView:aView];
    for (UIView *v in notHiddens) {
        v.hidden = NO;
    }
    if (img) {
        ViewImageHolder *holder = [[ViewImageHolder alloc] init];
        holder.image = [self renderImageForAntialiasing:img];
        holder.deep = deep;
        CGRect rect = [aView holderFrameWithDelta:originDelta];
        rect.origin.x -= 1;
        rect.origin.y -= 1;
        rect.size.width += 2;
        rect.size.height += 2;
        holder.rect = rect;
        [holders addObject:holder];
    }

    CGPoint subDelta = [aView holderFrameWithDelta:originDelta].origin;
    for (int i = 0; i < aView.subviews.count; i++) {
        UIView *v = aView.subviews[i];
        [self dumpView:v atDeep:deep + 1 + i / 10.0 atOriginDelta:subDelta toArray:holders];
    }
}




- (void)startShow {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    self.holders = nil;
    rotateX = 0;
    rotateY = 0;
    self.holders = [NSMutableArray arrayWithCapacity:100];
    
    for (int i=0; i< [UIApplication sharedApplication].windows.count; i++) {
        [self dumpView:[UIApplication sharedApplication].windows[i]
                atDeep:i * 50
         atOriginDelta:CGPointMake(0, 0)
               toArray:_holders];
    }
    
    

    for (ViewImageHolder *h in _holders) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:h.image];
        imgV.frame = h.rect;
        [self addSubview:imgV];
        h.view = imgV;
        CGRect r = imgV.frame;
        CGRect scr = [UIScreen mainScreen].bounds;
        imgV.layer.anchorPoint = CGPointMake((scr.size.width / 2 - imgV.frame.origin.x) / imgV.frame.size.width,
                                             (scr.size.height / 2 - imgV.frame.origin.y) / imgV.frame.size.height);
        imgV.layer.anchorPointZ = (-h.deep + 3) * 50;

        imgV.frame = r;
        imgV.layer.opacity = 0.9;
        imgV.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    }
    [self anime:0.3];
}

- (void)startHide {
    isAnimatimg = YES;
    [UIView animateWithDuration:0.3 animations:^() {
        for (ViewImageHolder * holder in self.holders) {
            holder.view.layer.transform = CATransform3DIdentity;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^() {
                self.hidden = YES;
            } completion:^(BOOL finished) {
                for (ViewImageHolder * holder in self.holders) {
                    [holder.view removeFromSuperview];
                }
                self.holders = nil;
                isAnimatimg = NO;
            }];
    }];
}

@end
