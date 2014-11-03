//
//  YENSStringController.m
//  YYKitExample
//
//  Created by ibireme on 14-10-14.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YENSStringController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

@interface YENSStringController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation YENSStringController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textField = [UITextField new];
    _textField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    _textField.top = 80;
    _textField.size = CGSizeMake(self.view.width, 32);
    _textField.frame = CGRectInset(_textField.frame, 10, 0);
    _textField.layer.cornerRadius = 3;
    _textField.clipsToBounds = YES;
    _textField.textAlignment = NSTextAlignmentCenter;
    __weak typeof(self) _self = self;
    [_textField addBlockForControlEvents:UIControlEventEditingChanged block:^(id sender) {
        [_self textChanged];
    }];
    [_textField addBlockForControlEvents:UIControlEventEditingDidEndOnExit block:^(id sender) {
        [_self.textField resignFirstResponder];
    }];
    [self.view addSubview:_textField];
    
    _textView = [UITextView new];
    _textView.size = CGSizeMake(self.view.width, self.view.height - _textField.bottom);
    _textView.top = _textField.bottom;
    _textView.editable = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.font = [UIFont fontWithName:@"Courier New" size:12];
    [self.view addSubview:_textView];
    
    _textField.text = @"123456";
    [self textChanged];
}


- (void)textChanged {
    NSString *str = self.textField.text;
    
    NSMutableString *text = NSMutableString.new;
    [text appendFormat:@"md2:%@\n\n", str.md2String];
    [text appendFormat:@"md4:%@\n\n", str.md4String];
    [text appendFormat:@"md5:%@\n\n", str.md5String];
    [text appendFormat:@"sha1:%@\n\n", str.sha1String];
    [text appendFormat:@"sha224:%@\n\n", str.sha224String];
    [text appendFormat:@"sha256:%@\n\n", str.sha256String];
    [text appendFormat:@"sha384:%@\n\n", str.sha384String];
    [text appendFormat:@"sha512:%@\n\n", str.sha512String];
    [text appendFormat:@"name2x:%@\n\n", [str stringByAppendingNameScale:2]];
    [text appendFormat:@"path2x:%@\n\n", [str stringByAppendingPathScale:2]];
    [text appendFormat:@"scale:%@\n\n", @(str.pathScale)];
    _textView.text = text;
}


@end
