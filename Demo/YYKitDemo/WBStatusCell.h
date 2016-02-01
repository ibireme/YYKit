//
//  WBFeedCell.h
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "WBStatusLayout.h"
#import "YYTableViewCell.h"
@class WBStatusCell;
@protocol WBStatusCellDelegate;


@interface WBStatusTitleView : UIView
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, weak) WBStatusCell *cell;
@end

@interface WBStatusProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, assign) WBUserVerifyType verifyType;
@property (nonatomic, weak) WBStatusCell *cell;
@end


@interface WBStatusCardView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) WBStatusCell *cell;
@end


@interface WBStatusToolbarView : UIView
@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIImageView *repostImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

@property (nonatomic, strong) YYLabel *repostLabel;
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) YYLabel *likeLabel;

@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, weak) WBStatusCell *cell;

- (void)setWithLayout:(WBStatusLayout *)layout;
// set both "liked" and "likeCount"
- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation;
@end


@interface WBStatusTagView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) WBStatusCell *cell;
@end




@interface WBStatusView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) WBStatusTitleView *titleView;     // 标题栏
@property (nonatomic, strong) WBStatusProfileView *profileView; // 用户资料
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片
@property (nonatomic, strong) UIView *retweetBackgroundView;    //转发容器
@property (nonatomic, strong) YYLabel *retweetTextLabel;        // 转发文本
@property (nonatomic, strong) WBStatusCardView *cardView;       // 卡片
@property (nonatomic, strong) WBStatusTagView *tagView;         // 下方Tag
@property (nonatomic, strong) WBStatusToolbarView *toolbarView; // 工具栏
@property (nonatomic, strong) UIImageView *vipBackgroundView;   // VIP 自定义背景
@property (nonatomic, strong) UIButton *menuButton;             // 菜单按钮
@property (nonatomic, strong) UIButton *followButton;           // 关注按钮

@property (nonatomic, strong) WBStatusLayout *layout;
@property (nonatomic, weak) WBStatusCell *cell;
@end



@protocol WBStatusCellDelegate;
@interface WBStatusCell : YYTableViewCell
@property (nonatomic, weak) id<WBStatusCellDelegate> delegate;
@property (nonatomic, strong) WBStatusView *statusView;
- (void)setLayout:(WBStatusLayout *)layout;
@end



@protocol WBStatusCellDelegate <NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(WBStatusCell *)cell;
/// 点击了 Card
- (void)cellDidClickCard:(WBStatusCell *)cell;
/// 点击了转发内容
- (void)cellDidClickRetweet:(WBStatusCell *)cell;
/// 点击了Cell菜单
- (void)cellDidClickMenu:(WBStatusCell *)cell;
/// 点击了关注
- (void)cellDidClickFollow:(WBStatusCell *)cell;
/// 点击了转发
- (void)cellDidClickRepost:(WBStatusCell *)cell;
/// 点击了下方 Tag
- (void)cellDidClickTag:(WBStatusCell *)cell;
/// 点击了评论
- (void)cellDidClickComment:(WBStatusCell *)cell;
/// 点击了赞
- (void)cellDidClickLike:(WBStatusCell *)cell;
/// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBUser *)user;
/// 点击了图片
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index;
/// 点击了 Label 的链接
- (void)cell:(WBStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end
