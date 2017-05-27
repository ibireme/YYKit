//
//  T1StatusCell.m
//  YYKitExample
//
//  Created by ibireme on 15/10/9.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "T1StatusCell.h"
#import "T1Helper.h"

#define kCornerRaadius 4

@implementation T1StatusMediaView

- (instancetype)init {
    self = [super init];
    self.width = kT1ContentWidth;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = kCornerRaadius;
    self.layer.borderColor = [UIColor colorWithWhite:0.865 alpha:1.000].CGColor;
    self.layer.borderWidth = CGFloatFromPixel(1);
    
    NSMutableArray *imageViews = [NSMutableArray new];
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor colorWithWhite:0.958 alpha:1.000];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.borderColor = self.layer.borderColor;
        imageView.layer.borderWidth = self.layer.borderWidth;
        [self addSubview:imageView];
        [imageViews addObject:imageView];
    }
    _imageViews = imageViews;
    
    @weakify(self);
    self.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (!self) return;
        if (state != YYGestureRecognizerStateEnded) return;
        
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView:self];
        NSUInteger index = [self imageIndexForPoint:point];
        if (index != NSNotFound) {
            if ([self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:withLongPress:)]) {
                [self.cell.delegate cell:self.cell didClickImageAtIndex:index withLongPress:NO];
            }
        }
    };
    self.longPressBlock = ^(YYControl *view, CGPoint point) {
        @strongify(self);
        if (!self) return;
        
        NSUInteger index = [self imageIndexForPoint:point];
        if (index != NSNotFound) {
            if ([self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:withLongPress:)]) {
                [self.cell.delegate cell:self.cell didClickImageAtIndex:index withLongPress:YES];
            }
        }
    };
    
    return self;
}

- (NSUInteger)imageIndexForPoint:(CGPoint)point {
    for (int i = 0; i < 4; i++) {
        UIImageView *view = self.imageViews[i];
        if (!view.hidden && CGRectContainsPoint(view.frame, point)) {
            return i;
        }
    }
    return NSNotFound;
}

- (void)setWithMedias:(NSArray<T1Media *> *)medias {
    for (int i = 0; i < 4; i++) {
        UIImageView *view = _imageViews[i];
        if (i >= medias.count) {
            view.hidden = YES;
            [view cancelCurrentImageRequest];
        } else {
            view.hidden = NO;
            T1Media *media = medias[i];
            [view setImageWithURL:media.mediaSmall.url
                      placeholder:nil
                          options:YYWebImageOptionSetImageWithFadeAnimation
                       completion:nil];
        }
    }
    
    switch (medias.count) {
        case 1: {
            UIImageView *view = _imageViews.firstObject;
            view.frame = self.bounds;
        } break;
        case 2: {
            UIImageView *view0 = _imageViews[0];
            view0.origin = CGPointZero;
            view0.height = self.height;
            view0.width = (self.width - kT1ImagePadding) / 2;

            UIImageView *view1 = _imageViews[1];
            view1.top = 0;
            view1.size = view0.size;
            view1.right = self.width;
        } break;
        case 3: {
            UIImageView *view0 = _imageViews[0];
            view0.origin = CGPointZero;
            view0.height = self.height;
            view0.width = (self.width - kT1ImagePadding) / 2;
            
            UIImageView *view1 = _imageViews[1];
            view1.top = 0;
            view1.width = view0.width;
            view1.right = self.width;
            view1.height = (self.height - kT1ImagePadding) / 2;
            
            UIImageView *view2 = _imageViews[2];
            view2.size = view1.size;
            view2.right = self.width;
            view2.bottom = self.height;
        } break;
        case 4: {
            UIImageView *view0 = _imageViews[0];
            view0.origin = CGPointZero;
            view0.width = (self.width - kT1ImagePadding) / 2;
            view0.height = (self.height - kT1ImagePadding) / 2;
            
            UIImageView *view1 = _imageViews[1];
            view1.size = view0.size;
            view1.top = 0;
            view1.right = self.width;
            
            UIImageView *view2 = _imageViews[2];
            view2.size = view0.size;
            view2.left = 0;
            view2.bottom = self.height;
            
            UIImageView *view3 = _imageViews[3];
            view3.size = view0.size;
            view3.right = self.width;
            view3.bottom = self.height;
        } break;
            
        default: break;
    }
}

@end

@implementation T1StatusQuoteView
- (instancetype)init {
    self = [super init];
    self.width = kT1ContentWidth;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = kCornerRaadius;
    self.layer.borderWidth = CGFloatFromPixel(1);
    self.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.108].CGColor;
    self.exclusiveTouch = YES;
    
    _nameLabel = [YYLabel new];
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.width = kT1QuoteContentWidth;
    _nameLabel.left = kT1CellPadding;
    [self addSubview:_nameLabel];
    
    _textLabel = [YYLabel new];
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.width = kT1QuoteContentWidth;
    _textLabel.left = kT1CellPadding;
    [self addSubview:_textLabel];
    
    @weakify(self);
    self.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (!self) return;
        if (state == YYGestureRecognizerStateBegan) {
            self.backgroundColor = kT1CellBGHighlightColor;
        } else if (state != YYGestureRecognizerStateMoved) {
            self.backgroundColor = [UIColor clearColor];
        }
        
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *t = touches.anyObject;
            CGPoint p = [t locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                if ([self.cell.delegate respondsToSelector:@selector(cell:didClickQuoteWithLongPress:)]) {
                    [self.cell.delegate cell:self.cell didClickQuoteWithLongPress:NO];
                }
            }
        }
    };
    
    return self;
}
- (void)setWithLayout:(T1StatusLayout *)layout {
    _nameLabel.height = kT1UserNameFontSize * 2;
    _nameLabel.centerY = kT1CellPadding + kT1UserNameFontSize / 2;
    _nameLabel.textLayout = layout.quotedNameTextLayout;
    
    _textLabel.height = CGRectGetMaxY(layout.quotedTextLayout.textBoundingRect);
    _textLabel.top = kT1CellPadding + kT1UserNameFontSize + kT1CellInnerPadding;
    _textLabel.textLayout = layout.quotedTextLayout;
}
@end

@implementation T1StatusInlineActionsView

- (instancetype)init {
    self = [super init];
    self.width = kT1ContentWidth;
    self.height = 32;
    __weak typeof(self) _self = self;
    
    _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _replyButton.size = CGSizeMake(32, 32);
    _replyButton.centerY = self.height / 2;
    _replyButton.centerX = 6;
    _replyButton.adjustsImageWhenHighlighted = NO;
    _replyButton.exclusiveTouch = YES;
    [_replyButton setImage:[T1Helper imageNamed:@"icn_tweet_action_inline_reply_off"] forState:UIControlStateNormal];
    [_replyButton addBlockForControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter
                                     block:^(UIButton *sender) {
                                         sender.alpha = 0.6;
                                     }];
    [_replyButton addBlockForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside |
                                           UIControlEventTouchCancel | UIControlEventTouchDragExit
                                     block:^(UIButton *sender) {
                                         sender.alpha = 1;
                                     }];
    [_replyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        if ([_self.cell.delegate respondsToSelector:@selector(cellDidClickReply:)]) {
            [_self.cell.delegate cellDidClickReply:_self.cell];
        }
    }];
    [self addSubview:_replyButton];
    
    
    
    _retweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_retweetButton];
    _retweetImageView = [UIImageView new];
    [self addSubview:_retweetImageView];
    _retweetLabel = [YYLabel new];
    [self addSubview:_retweetLabel];
    
    _retweetButton.size = CGSizeMake(32, 32);
    _retweetButton.centerY = self.height / 2;
    _retweetButton.left = kT1ContentWidth * 0.28 + _replyButton.left;
    _retweetImageView.size = CGSizeMake(32, 32);
    _retweetImageView.contentMode = UIViewContentModeCenter;
    _retweetImageView.center = _retweetButton.center;
    _retweetImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_retweet_off"];
    _retweetLabel.height = _retweetButton.height;
    _retweetLabel.left = _retweetImageView.right - 3;
    _retweetLabel.userInteractionEnabled = NO;
    _replyButton.exclusiveTouch = YES;
    [_retweetButton addBlockForControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter
                                       block:^(UIButton *sender) {
                                           _self.retweetImageView.alpha = 0.6;
                                           _self.retweetLabel.alpha = 0.6;
                                       }];
    [_retweetButton addBlockForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside |
                                             UIControlEventTouchCancel | UIControlEventTouchDragExit
                                       block:^(UIButton *sender) {
                                           _self.retweetImageView.alpha = 1;
                                           _self.retweetLabel.alpha = 1;
                                       }];
    [_retweetButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        if ([_self.cell.delegate respondsToSelector:@selector(cellDidClickRetweet:)]) {
            [_self.cell.delegate cellDidClickRetweet:_self.cell];
        }
    }];
    
    _favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_favoriteButton];
    _favoriteImageView = [YYAnimatedImageView new];
    [self addSubview:_favoriteImageView];
    _favoriteLabel = [YYLabel new];
    [self addSubview:_favoriteLabel];
    
    _favoriteButton.size = CGSizeMake(32, 32);
    _favoriteButton.centerY = self.height / 2;
    _favoriteButton.left = kT1ContentWidth * 0.28 + _retweetButton.left;
    _favoriteImageView.size = CGSizeMake(32, 32);
    _favoriteImageView.contentMode = UIViewContentModeCenter;
    _favoriteImageView.center = _favoriteButton.center;
    _favoriteImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_favorite_off"];
    _favoriteLabel.height = _favoriteButton.height;
    _favoriteLabel.left = _favoriteImageView.right - 4;
    _favoriteLabel.userInteractionEnabled = NO;
    _favoriteLabel.exclusiveTouch = YES;
    [_favoriteButton addBlockForControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter
                                        block:^(UIButton *sender) {
                                            _self.favoriteImageView.alpha = 0.6;
                                            _self.favoriteLabel.alpha = 0.6;
                                        }];
    [_favoriteButton addBlockForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside |
                                              UIControlEventTouchCancel | UIControlEventTouchDragExit
                                        block:^(UIButton *sender) {
                                            _self.favoriteImageView.alpha = 1;
                                            _self.favoriteLabel.alpha = 1;
                                        }];
    [_favoriteButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        if ([_self.cell.delegate respondsToSelector:@selector(cellDidClickFavorite:)]) {
            [_self.cell.delegate cellDidClickFavorite:_self.cell];
        }
    }];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _followButton.size = CGSizeMake(32, 32);
    _followButton.centerY = self.height / 2;
    _followButton.right = self.width - 3;
    _followButton.adjustsImageWhenHighlighted = NO;
    _followButton.exclusiveTouch = YES;
    [_followButton setImage:[T1Helper imageNamed:@"icn_tweet_action_inline_follow_off_ipad_experiment"] forState:UIControlStateNormal];
    [_followButton addBlockForControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter
                                      block:^(UIButton *sender) {
                                          sender.alpha = 0.6;
                                      }];
    [_followButton addBlockForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside |
                                            UIControlEventTouchCancel | UIControlEventTouchDragExit
                                      block:^(UIButton *sender) {
                                          sender.alpha = 1;
                                      }];
    [_followButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        if ([_self.cell.delegate respondsToSelector:@selector(cellDidClickFollow:)]) {
            [_self.cell.delegate cellDidClickFollow:_self.cell];
        }
    }];
    
    [self addSubview:_followButton];
    
    return self;
}

- (void)setWithLayout:(T1StatusLayout *)layout {
    T1Tweet *tweet = layout.displayedTweet;
    if (tweet.retweeted) {
        _retweetImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_retweet_on_white"];
    } else {
        _retweetImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_retweet_off"];
    }
    
    if (tweet.favorited) {
        _favoriteImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_favorite_on_white"];
    } else {
        _favoriteImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_favorite_off"];
    }
    
    if (layout.retweetCountTextLayout) {
        _retweetLabel.hidden = NO;
        _retweetLabel.width = layout.retweetCountTextLayout.textBoundingSize.width + 5;
        _retweetLabel.textLayout = layout.retweetCountTextLayout;
        _retweetButton.width = _retweetLabel.right - _retweetButton.left;
    } else {
        _retweetLabel.hidden = YES;
        _retweetButton.width = _retweetButton.height;
    }
    
    if (layout.favoriteCountTextLayout) {
        _favoriteLabel.hidden = NO;
        _favoriteLabel.width = layout.favoriteCountTextLayout.textBoundingSize.width + 5;
        _favoriteLabel.textLayout = layout.favoriteCountTextLayout;
        _favoriteButton.width = _favoriteLabel.right - _favoriteButton.left;
    } else {
        _favoriteLabel.hidden = YES;
        _favoriteButton.width = _favoriteButton.height;
    }
    
    if (tweet.user.following) {
        _followButton.hidden = YES;
    } else {
        _followButton.hidden = NO;
        [_followButton setImage:[T1Helper imageNamed:@"icn_tweet_action_inline_follow_off_ipad_experiment"] forState:UIControlStateNormal];
    }
}

- (void)updateRetweetWithAnimation {
    T1StatusLayout *layout = self.cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    if (tweet.retweeted) {
        _retweetImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_retweet_on_white"];
    } else {
        _retweetImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_retweet_off"];
    }
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _retweetImageView.layer.transformScale = 1.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _retweetImageView.layer.transformScale = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    if (layout.retweetCountTextLayout) {
        _retweetLabel.hidden = NO;
        _retweetLabel.width = layout.retweetCountTextLayout.textBoundingSize.width + 5;
        _retweetLabel.textLayout = layout.retweetCountTextLayout;
        _retweetButton.width = _retweetLabel.right - _retweetButton.left;
    } else {
        _retweetLabel.hidden = YES;
        _retweetButton.width = _retweetButton.height;
    }
}

- (void)updateFavouriteWithAnimation {
    T1StatusLayout *layout = self.cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    if (tweet.favorited) {
        UIImage *img = [T1Helper imageNamed:@"fav02c-sheet"];
        NSMutableArray *contentRects = [NSMutableArray new];
        NSMutableArray *durations = [NSMutableArray new];
        for (int j = 0; j < 12; j++) {
            for (int i = 0; i < 8; i++) {
                CGRect rect;
                rect.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
                rect.origin.x = img.size.width / 8 * i;
                rect.origin.y = img.size.height / 12 * j;
                [contentRects addObject:[NSValue valueWithCGRect:rect]];
                [durations addObject:@(1 / 60.0)];
            }
        }
        YYSpriteSheetImage *sprite = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:img contentRects:contentRects frameDurations:durations loopCount:1];
        _favoriteImageView.image = sprite;
    } else {
        _favoriteImageView.image = [T1Helper imageNamed:@"icn_tweet_action_inline_favorite_off"];
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _favoriteImageView.layer.transformScale = 1.5;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _favoriteImageView.layer.transformScale = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    
    if (layout.favoriteCountTextLayout) {
        _favoriteLabel.hidden = NO;
        _favoriteLabel.width = layout.favoriteCountTextLayout.textBoundingSize.width + 5;
        _favoriteLabel.textLayout = layout.favoriteCountTextLayout;
        _favoriteButton.width = _favoriteLabel.right - _favoriteButton.left;
    } else {
        _favoriteLabel.hidden = YES;
        _favoriteButton.width = _favoriteButton.height;
    }
}

- (void)updateFollowWithAnimation {
    T1StatusLayout *layout = self.cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    if (tweet.user.following) {
        [_followButton setImage:[T1Helper imageNamed:@"icn_tweet_action_inline_follow_on_ipad_experiment"] forState:UIControlStateNormal];
    } else {
        [_followButton setImage:[T1Helper imageNamed:@"icn_tweet_action_inline_follow_off_ipad_experiment"] forState:UIControlStateNormal];
    }
}

@end



@implementation T1StatusView

- (instancetype)init {
    self = [super init];
    self.width = kScreenWidth;
    self.backgroundColor = [UIColor whiteColor];
    self.exclusiveTouch = YES;
    self.clipsToBounds = YES;
    
    _socialLabel = [YYLabel new];
    _socialLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _socialLabel.displaysAsynchronously = YES;
    _socialLabel.ignoreCommonProperties = YES;
    _socialLabel.fadeOnHighlight = NO;
    _socialLabel.fadeOnAsynchronouslyDisplay = NO;
    _socialLabel.size = CGSizeMake(kT1ContentWidth, kT1UserNameSubFontSize * 2);
    _socialLabel.left = kT1ContentLeft;
    _socialLabel.centerY = kT1CellPadding + kT1UserNameSubFontSize / 2;
    _socialLabel.userInteractionEnabled = NO;
    [self addSubview:_socialLabel];
    
    _socialIconView = [UIImageView new];
    _socialIconView.size = CGSizeMake(16, 16);
    _socialIconView.centerY = _socialLabel.centerY - 1;
    _socialIconView.right = kT1CellPadding + kT1AvatarSize;
    _socialIconView.contentMode = UIViewContentModeScaleAspectFit;
    _socialIconView.userInteractionEnabled = NO;
    [self addSubview:_socialIconView];
    
    _avatarView = [YYControl new];
    _avatarView.clipsToBounds = YES;
    _avatarView.layer.cornerRadius = 4;
    _avatarView.layer.borderWidth = CGFloatFromPixel(1);
    _avatarView.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.118].CGColor;
    _avatarView.backgroundColor = [UIColor colorWithWhite:0.908 alpha:1.000];
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarView.left = kT1CellPadding;
    _avatarView.size = CGSizeMake(kT1AvatarSize, kT1AvatarSize);
    _avatarView.exclusiveTouch = YES;
    
    [self addSubview:_avatarView];
    
    _conversationTopJoin = [UIView new];
    _conversationTopJoin.userInteractionEnabled = NO;
    _conversationTopJoin.hidden = YES;
    _conversationTopJoin.width = 3;
    _conversationTopJoin.backgroundColor = UIColorHex(e1e8ed);
    _conversationTopJoin.clipsToBounds = YES;
    _conversationTopJoin.layer.cornerRadius = _conversationTopJoin.width / 2;
    _conversationTopJoin.centerX = _avatarView.centerX;
    [self addSubview:_conversationTopJoin];
    
    _conversationBottomJoin = [UIView new];
    _conversationBottomJoin.userInteractionEnabled = NO;
    _conversationBottomJoin.hidden = YES;
    _conversationBottomJoin.width = 3;
    _conversationBottomJoin.backgroundColor = _conversationTopJoin.backgroundColor;
    _conversationBottomJoin.clipsToBounds = YES;
    _conversationBottomJoin.layer.cornerRadius = _conversationTopJoin.width / 2;
    _conversationBottomJoin.centerX = _avatarView.centerX;
    [self addSubview:_conversationBottomJoin];
    
    
    _nameLabel = [YYLabel new];
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.left = kT1ContentLeft;
    _nameLabel.width = kT1ContentWidth;
    _nameLabel.height = kT1UserNameFontSize * 2;
    _nameLabel.userInteractionEnabled = NO;
    _nameLabel.exclusiveTouch = YES;
    [self addSubview:_nameLabel];
    
    _dateLabel = [YYLabel new];
    _dateLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _dateLabel.displaysAsynchronously = YES;
    _dateLabel.ignoreCommonProperties = YES;
    _dateLabel.fadeOnHighlight = NO;
    _dateLabel.fadeOnAsynchronouslyDisplay = NO;
    _dateLabel.frame = _nameLabel.frame;
    _dateLabel.userInteractionEnabled = NO;
    [self addSubview:_dateLabel];
    
    _textLabel = [YYLabel new];
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.left = kT1ContentLeft;
    _textLabel.width = kT1ContentWidth;
    _textLabel.width += kT1TextContainerInset * 2;
    _textLabel.left -= kT1TextContainerInset;
    __weak typeof(self) _self = self;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [_self.cell.delegate cell:_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [self addSubview:_textLabel];
    
    
    _mediaView = [T1StatusMediaView new];
    _mediaView.left = kT1ContentLeft;
    [self addSubview:_mediaView];
    
    _quoteView = [T1StatusQuoteView new];
    _quoteView.left = kT1ContentLeft;
    [self addSubview:_quoteView];
    
    _inlineActionsView = [T1StatusInlineActionsView new];
    _inlineActionsView.left = kT1ContentLeft;
    [self addSubview:_inlineActionsView];
    
    
    _topLine = [UIView new];
    _topLine.width = kScreenWidth;
    _topLine.height = CGFloatFromPixel(1);
    _topLine.backgroundColor = [UIColor colorWithWhite:0.823 alpha:1.000];
    [self addSubview:_topLine];
    
    @weakify(self);
    self.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (!self) return;
        if (state == YYGestureRecognizerStateBegan) {
            self.backgroundColor = kT1CellBGHighlightColor;
        } else if (state != YYGestureRecognizerStateMoved) {
            self.backgroundColor = [UIColor clearColor];
        }
        
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *t = touches.anyObject;
            CGPoint p = [t locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                if ([self.cell.delegate respondsToSelector:@selector(cell:didClickContentWithLongPress:)]) {
                    [self.cell.delegate cell:self.cell didClickContentWithLongPress:NO];
                }
            }
        }
    };
    
    _avatarView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (!self) return;
        if (state == YYGestureRecognizerStateBegan) {
            self.avatarView.alpha = 0.7;
        } else if (state != YYGestureRecognizerStateMoved) {
            self.avatarView.alpha = 1;
        }
        
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *t = touches.anyObject;
            CGPoint p = [t locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                if ([self.cell.delegate respondsToSelector:@selector(cell:didClickAvatarWithLongPress:)]) {
                    [self.cell.delegate cell:self.cell didClickAvatarWithLongPress:NO];
                }
            }
        }
    };
    return self;
}

- (void)setWithLayout:(T1StatusLayout *)layout {
    self.height = layout.height;
    self.topLine.hidden = !layout.showTopLine;
    if (layout.isConversationSplit) {
        _conversationTopJoin.hidden = NO;
        _conversationTopJoin.top = 3;
        _conversationTopJoin.height = self.height - 6;
        
        _avatarView.hidden = YES;
        _nameLabel.hidden = YES;
        _dateLabel.hidden = YES;
        _socialLabel.hidden = YES;
        _socialIconView.hidden = YES;
        _inlineActionsView.hidden = YES;
        
        return;
    } else {
        if (_avatarView.hidden) {
            _avatarView.hidden = NO;
            _nameLabel.hidden = NO;
            _dateLabel.hidden = NO;
            _socialLabel.hidden = NO;
            _socialIconView.hidden = NO;
            _inlineActionsView.hidden = NO;
        }
    }
    
    T1Tweet *tweet = layout.displayedTweet;
    _avatarView.top = layout.paddingTop;
    [_avatarView.layer setImageWithURL:tweet.user.profileImageURLReasonablySmall options:YYWebImageOptionSetImageWithFadeAnimation];
    
    if (layout.socialTextLayout) {
        _socialLabel.hidden = NO;
        _socialIconView.hidden = NO;
        _socialLabel.textLayout = layout.socialTextLayout;
        if (layout.tweet.retweetedStatus) {
            _socialIconView.hidden = NO;
            _socialIconView.image = [T1Helper imageNamed:@"icn_social_proof_conversation_default"];
        } else if (layout.tweet.inReplyToScreenName) {
            _socialIconView.hidden = NO;
            _socialIconView.image = [T1Helper imageNamed:@"icn_activity_rt_tweet"];
        } else {
            _socialIconView.image = nil;
        }
    } else {
        _socialLabel.hidden = YES;
        _socialIconView.hidden = YES;
    }
    
    _nameLabel.centerY = layout.paddingTop + kT1TextFontSize / 2;
    _nameLabel.textLayout = layout.nameTextLayout;
    
    _dateLabel.centerY = _nameLabel.centerY;
    _dateLabel.textLayout = layout.dateTextLayout;
    
    if (layout.textLayout) {
        _textLabel.hidden = NO;
        _textLabel.top = layout.textTop;
        _textLabel.height = layout.textHeight;
        _textLabel.textLayout = layout.textLayout;
    } else {
        _textLabel.hidden = YES;
    }
    
    if (layout.images) {
        _mediaView.hidden = NO;
        _mediaView.top = layout.imagesTop;
        _mediaView.height = layout.imagesHeight;
        [_mediaView setWithMedias:layout.images];
    } else {
        _mediaView.hidden = YES;
        [_mediaView setWithMedias:nil];
    }
    
    if (layout.quoteHeight > 0) {
        _quoteView.hidden = NO;
        _quoteView.top = layout.quoteTop;
        _quoteView.height = layout.quoteHeight;
        [_quoteView setWithLayout:layout];
    } else {
        _quoteView.hidden = YES;
    }
    
    _inlineActionsView.centerY = self.height - 19;
    [_inlineActionsView setWithLayout:layout];
    
    
    self.conversationTopJoin.hidden = !layout.showConversationTopJoin;
    self.conversationBottomJoin.hidden = !layout.showConversationBottomJoin;
    if (layout.showConversationTopJoin) {
        _conversationTopJoin.top = - 5;
        _conversationTopJoin.height = _avatarView.top - _conversationTopJoin.top - 3;
    }
    
    if (layout.showConversationBottomJoin) {
        _conversationBottomJoin.top = _avatarView.bottom + 3;
        _conversationBottomJoin.height = self.height - _conversationBottomJoin.top + 5;
    }
}

- (void)setCell:(T1StatusCell *)cell {
    _cell = cell;
    _mediaView.cell = cell;
    _quoteView.cell = cell;
    _inlineActionsView.cell = cell;
}
@end



@implementation T1StatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    _statusView = [T1StatusView new];
    _statusView.cell = self;
    
    [self.contentView addSubview:_statusView];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)setLayout:(T1StatusLayout *)layout {
    _layout = layout;
    self.contentView.height = layout.height;
    _statusView.height = layout.height;
    [_statusView setWithLayout:layout];
}

@end
