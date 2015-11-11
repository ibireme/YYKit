//
//  YYTextEditExample.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTextEditExample.h"
#import "YYKit.h"
#import "YYTextExampleHelper.h"

@interface YYTextEditExample () <YYTextViewDelegate, YYTextKeyboardObserver>
@property (nonatomic, assign) YYTextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISwitch *verticalSwitch;
@property (nonatomic, strong) UISwitch *debugSwitch;
@property (nonatomic, strong) UISwitch *exclusionSwitch;
@end

@implementation YYTextEditExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initImageView];
    __weak typeof(self) _self = self;
    
    UIView *toolbar;
    if ([UIVisualEffectView class]) {
        toolbar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    } else {
        toolbar = [UIToolbar new];
    }
    toolbar.size = CGSizeMake(kScreenWidth, 40);
    toolbar.top = kiOS7Later ? 64 : 0;
    [self.view addSubview:toolbar];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us. We were all going direct to heaven, we were all going direct the other way.\n\n这是最好的时代，这是最坏的时代；这是智慧的时代，这是愚蠢的时代；这是信仰的时期，这是怀疑的时期；这是光明的季节，这是黑暗的季节；这是希望之春，这是失望之冬；人们面前有着各样事物，人们面前一无所有；人们正在直登天堂，人们正在直下地狱。"];
    text.font = [UIFont fontWithName:@"Times New Roman" size:20];
    text.lineSpacing = 4;
    text.firstLineHeadIndent = 20;
    
    YYTextView *textView = [YYTextView new];
    textView.attributedText = text;
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    if (kiOS7Later) {
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    } else {
        textView.height -= 64;
    }
    textView.contentInset = UIEdgeInsetsMake(toolbar.bottom, 0, 0, 0);
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    [self.view insertSubview:textView belowSubview:toolbar];
    self.textView = textView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView becomeFirstResponder];
    });
    
    
    
    /*------------------------------ Toolbar ---------------------------------*/
    UILabel *label;
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"Vertical:";
    label.size = CGSizeMake([label.text widthForFont:label.font] + 2, toolbar.height);
    label.left = 10;
    [toolbar addSubview:label];
    
    _verticalSwitch = [UISwitch new];
    [_verticalSwitch sizeToFit];
    _verticalSwitch.centerY = toolbar.height / 2;
    _verticalSwitch.left = label.right - 5;
    _verticalSwitch.layer.transformScale = 0.8;
    [_verticalSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch *switcher) {
        [_self.textView endEditing:YES];
        if (switcher.isOn) {
            [_self setExclusionPathEnabled:NO];
            _self.exclusionSwitch.on = NO;
        }
        _self.exclusionSwitch.enabled = !switcher.isOn;
        _self.textView.verticalForm = switcher.isOn; /// Set vertical form
    }];
    [toolbar addSubview:_verticalSwitch];
    
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"Debug:";
    label.size = CGSizeMake([label.text widthForFont:label.font] + 2, toolbar.height);
    label.left = _verticalSwitch.right + 5;
    [toolbar addSubview:label];
    
    _debugSwitch = [UISwitch new];
    [_debugSwitch sizeToFit];
    _debugSwitch.on = [YYTextExampleHelper isDebug];
    _debugSwitch.centerY = toolbar.height / 2;
    _debugSwitch.left = label.right - 5;
    _debugSwitch.layer.transformScale = 0.8;
    [_debugSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch *switcher) {
        [YYTextExampleHelper setDebug:switcher.isOn];
    }];
    [toolbar addSubview:_debugSwitch];
    
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"Exclusion:";
    label.size = CGSizeMake([label.text widthForFont:label.font] + 2, toolbar.height);
    label.left = _debugSwitch.right + 5;
    [toolbar addSubview:label];
    
    _exclusionSwitch = [UISwitch new];
    [_exclusionSwitch sizeToFit];
    _exclusionSwitch.centerY = toolbar.height / 2;
    _exclusionSwitch.left = label.right - 5;
    _exclusionSwitch.layer.transformScale = 0.8;
    [_exclusionSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch *switcher) {
        [_self setExclusionPathEnabled:switcher.isOn];
    }];
    [toolbar addSubview:_exclusionSwitch];
    
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)setExclusionPathEnabled:(BOOL)enabled {
    if (enabled) {
        [self.textView addSubview:self.imageView];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageView.frame
                                                        cornerRadius:self.imageView.layer.cornerRadius];
        self.textView.exclusionPaths = @[path]; /// Set exclusion paths
    } else {
        [self.imageView removeFromSuperview];
        self.textView.exclusionPaths = nil;
    }
}

- (void)initImageView {
    NSData *data = [NSData dataNamed:@"dribbble256_imageio.png"];
    UIImage *image = [[YYImage alloc] initWithData:data scale:2];
    UIImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.layer.cornerRadius = imageView.height / 2;
    imageView.center = CGPointMake(kScreenWidth / 2, kScreenWidth / 2);
    self.imageView = imageView;
    
    @weakify(self);
    UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(UIPanGestureRecognizer *g) {
        @strongify(self);
        if (!self) return;
        CGPoint p = [g locationInView:self.textView];
        self.imageView.center = p;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageView.frame
                                                        cornerRadius:self.imageView.layer.cornerRadius];
        self.textView.exclusionPaths = @[path];
    }];
    [imageView addGestureRecognizer:g];
}

- (void)edit:(UIBarButtonItem *)item {
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    } else {
        [_textView becomeFirstResponder];
    }
}

#pragma mark text view

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark - keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    if (_textView.isVerticalForm && transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            _textView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        _textView.frame = self.view.bounds;
    }
}

@end
