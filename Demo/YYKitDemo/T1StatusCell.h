//
//  T1StatusCell.h
//  YYKitExample
//
//  Created by ibireme on 15/10/9.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "YYTableViewCell.h"
#import "YYKit.h"
#import "T1StatusLayout.h"
#import "YYControl.h"

@class T1StatusCell;

@interface T1StatusMediaView : YYControl
@property (nonatomic, strong) NSArray<UIImageView *> *imageViews;
@property (nonatomic, weak) T1StatusCell *cell;
@end


@interface T1StatusQuoteView : YYControl
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *textLabel;
@property (nonatomic, weak) T1StatusCell *cell;
@end


@interface T1StatusInlineActionsView : UIView
@property (nonatomic, strong) UIButton *replyButton;

@property (nonatomic, strong) UIButton *retweetButton;
@property (nonatomic, strong) UIImageView *retweetImageView;
@property (nonatomic, strong) YYLabel *retweetLabel;

@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) YYAnimatedImageView *favoriteImageView;
@property (nonatomic, strong) YYLabel *favoriteLabel;

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, weak) T1StatusCell *cell;

- (void)updateRetweetWithAnimation;
- (void)updateFavouriteWithAnimation;
- (void)updateFollowWithAnimation;
@end



@interface T1StatusView : YYControl
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIImageView *socialIconView;
@property (nonatomic, strong) YYLabel *socialLabel;

@property (nonatomic, strong) YYControl *avatarView;
@property (nonatomic, strong) UIView *conversationTopJoin;
@property (nonatomic, strong) UIView *conversationBottomJoin;

@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *dateLabel;
@property (nonatomic, strong) YYLabel *textLabel;

@property (nonatomic, strong) T1StatusMediaView *mediaView;
@property (nonatomic, strong) T1StatusQuoteView *quoteView;

@property (nonatomic, strong) T1StatusInlineActionsView *inlineActionsView;
@property (nonatomic, weak) T1StatusCell *cell;

@end




@protocol T1StatusCellDelegate <NSObject>
@optional
- (void)cell:(T1StatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
- (void)cell:(T1StatusCell *)cell didClickImageAtIndex:(NSUInteger)index withLongPress:(BOOL)longPress;
- (void)cell:(T1StatusCell *)cell didClickQuoteWithLongPress:(BOOL)longPress;
- (void)cell:(T1StatusCell *)cell didClickAvatarWithLongPress:(BOOL)longPress;
- (void)cell:(T1StatusCell *)cell didClickContentWithLongPress:(BOOL)longPress;
- (void)cellDidClickReply:(T1StatusCell *)cell;
- (void)cellDidClickRetweet:(T1StatusCell *)cell;
- (void)cellDidClickFavorite:(T1StatusCell *)cell;
- (void)cellDidClickFollow:(T1StatusCell *)cell;
@end


@interface T1StatusCell : YYTableViewCell
@property (nonatomic, strong) T1StatusView *statusView;
@property (nonatomic, strong) T1StatusLayout *layout;
@property (nonatomic, weak) id<T1StatusCellDelegate> delegate;
@end

