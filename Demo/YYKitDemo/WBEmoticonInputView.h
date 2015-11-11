//
//  WBStatusComposeEmoticonView.h
//  YYKitExample
//
//  Created by ibireme on 15/9/6.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBStatusComposeEmoticonViewDelegate <NSObject>
@optional
- (void)emoticonInputDidTapText:(NSString *)text;
- (void)emoticonInputDidTapBackspace;
@end

/// 表情输入键盘
@interface WBEmoticonInputView : UIView
@property (nonatomic, weak) id<WBStatusComposeEmoticonViewDelegate> delegate;
+ (instancetype)sharedView;
@end
