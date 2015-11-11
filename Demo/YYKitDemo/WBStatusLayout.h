//
//  WBFeedLayout.h
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYKit.h"
#import "WBModel.h"
#import "WBStatusHelper.h"

// 宽高
#define kWBCellTopMargin 8      // cell 顶部灰色留白
#define kWBCellTitleHeight 36   // cell 标题高度 (例如"仅自己可见")
#define kWBCellPadding 12       // cell 内边距
#define kWBCellPaddingText 10   // cell 文本与其他元素间留白
#define kWBCellPaddingPic 4     // cell 多张图片中间留白
#define kWBCellProfileHeight 56 // cell 名片高度
#define kWBCellCardHeight 70    // cell card 视图高度
#define kWBCellNamePaddingLeft 14 // cell 名字和 avatar 之间留白
#define kWBCellContentWidth (kScreenWidth - 2 * kWBCellPadding) // cell 内容宽度
#define kWBCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制

#define kWBCellTagPadding 8         // tag 上下留白
#define kWBCellTagNormalHeight 16   // 一般 tag 高度
#define kWBCellTagPlaceHeight 24    // 地理位置 tag 高度

#define kWBCellToolbarHeight 35     // cell 下方工具栏高度
#define kWBCellToolbarBottomMargin 2 // cell 下方灰色留白

// 字体 应该做成动态的，这里只是 Demo，临时写死了。
#define kWBCellNameFontSize 16      // 名字字体大小
#define kWBCellSourceFontSize 12    // 来源字体大小
#define kWBCellTextFontSize 17      // 文本字体大小
#define kWBCellTextFontRetweetSize 16 // 转发字体大小
#define kWBCellCardTitleFontSize 16 // 卡片标题文本字体大小
#define kWBCellCardDescFontSize 12 // 卡片描述文本字体大小
#define kWBCellTitlebarFontSize 14 // 标题栏字体大小
#define kWBCellToolbarFontSize 14 // 工具栏字体大小

// 颜色
#define kWBCellNameNormalColor UIColorHex(333333) // 名字颜色
#define kWBCellNameOrangeColor UIColorHex(f26220) // 橙名颜色 (VIP)
#define kWBCellTimeNormalColor UIColorHex(828282) // 时间颜色
#define kWBCellTimeOrangeColor UIColorHex(f28824) // 橙色时间 (最新刷出)

#define kWBCellTextNormalColor UIColorHex(333333) // 一般文本色
#define kWBCellTextSubTitleColor UIColorHex(5d5d5d) // 次要文本色
#define kWBCellTextHighlightColor UIColorHex(527ead) // Link 文本色
#define kWBCellTextHighlightBackgroundColor UIColorHex(bfdffe) // Link 点击背景色
#define kWBCellToolbarTitleColor UIColorHex(929292) // 工具栏文本色
#define kWBCellToolbarTitleHighlightColor UIColorHex(df422d) // 工具栏文本高亮色

#define kWBCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kWBCellHighlightColor UIColorHex(f0f0f0)     // Cell高亮时灰色
#define kWBCellInnerViewColor UIColorHex(f7f7f7)   // Cell内部卡片灰色
#define kWBCellInnerViewHighlightColor  UIColorHex(f0f0f0) // Cell内部卡片高亮时灰色
#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色

#define kWBLinkHrefName @"href" //NSString
#define kWBLinkURLName @"url" //WBURL
#define kWBLinkTagName @"tag" //WBTag
#define kWBLinkTopicName @"topic" //WBTopic
#define kWBLinkAtName @"at" //NSString

/// 风格
typedef NS_ENUM(NSUInteger, WBLayoutStyle) {
    WBLayoutStyleTimeline = 0, ///< 时间线 (目前只支持这一种)
    WBLayoutStyleDetail,       ///< 详情页
};

/// 卡片类型 (这里随便写的，只适配了微博中常见的类型)
typedef NS_ENUM(NSUInteger, WBStatusCardType) {
    WBStatusCardTypeNone = 0, ///< 没卡片
    WBStatusCardTypeNormal,   ///< 一般卡片布局
    WBStatusCardTypeVideo,    ///< 视频
};

/// 最下方Tag类型，也是随便写的，微博可能有更多类型同时存在等情况
typedef NS_ENUM(NSUInteger, WBStatusTagType) {
    WBStatusTagTypeNone = 0, ///< 没Tag
    WBStatusTagTypeNormal,   ///< 文本
    WBStatusTagTypePlace,    ///< 地点
};


/**
 一个 Cell 的布局。
 布局排版应该在后台线程完成。
 */
@interface WBStatusLayout : NSObject
- (instancetype)initWithStatus:(WBStatus *)status style:(WBLayoutStyle)style;
- (void)layout; ///< 计算布局
- (void)updateDate; ///< 更新时间字符串

// 以下是数据
@property (nonatomic, strong) WBStatus *status;
@property (nonatomic, assign) WBLayoutStyle style;

//以下是布局结果

// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白

// 标题栏
@property (nonatomic, assign) CGFloat titleHeight; //标题栏高度，0为没标题栏
@property (nonatomic, strong) YYTextLayout *titleTextLayout; // 标题栏

// 个人资料
@property (nonatomic, assign) CGFloat profileHeight; //个人资料高度(包括留白)
@property (nonatomic, strong) YYTextLayout *nameTextLayout; // 名字
@property (nonatomic, strong) YYTextLayout *sourceTextLayout; //时间/来源

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;

// 转发
@property (nonatomic, assign) CGFloat retweetHeight; //转发高度，0为没转发
@property (nonatomic, assign) CGFloat retweetTextHeight;
@property (nonatomic, strong) YYTextLayout *retweetTextLayout; //被转发文本
@property (nonatomic, assign) CGFloat retweetPicHeight;
@property (nonatomic, assign) CGSize retweetPicSize;
@property (nonatomic, assign) CGFloat retweetCardHeight;
@property (nonatomic, assign) WBStatusCardType retweetCardType;
@property (nonatomic, strong) YYTextLayout *retweetCardTextLayout; //被转发文本
@property (nonatomic, assign) CGRect retweetCardTextRect;

// 卡片
@property (nonatomic, assign) CGFloat cardHeight; //卡片高度，0为没卡片
@property (nonatomic, assign) WBStatusCardType cardType;
@property (nonatomic, strong) YYTextLayout *cardTextLayout; //卡片文本
@property (nonatomic, assign) CGRect cardTextRect;

// Tag
@property (nonatomic, assign) CGFloat tagHeight; //Tip高度，0为没tip
@property (nonatomic, assign) WBStatusTagType tagType;
@property (nonatomic, strong) YYTextLayout *tagTextLayout; //最下方tag

// 工具栏
@property (nonatomic, assign) CGFloat toolbarHeight; // 工具栏
@property (nonatomic, strong) YYTextLayout *toolbarRepostTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarCommentTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarLikeTextLayout;
@property (nonatomic, assign) CGFloat toolbarRepostTextWidth;
@property (nonatomic, assign) CGFloat toolbarCommentTextWidth;
@property (nonatomic, assign) CGFloat toolbarLikeTextWidth;

// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;



/*
 
 用户信息  status.user
 文本      status.text
 图片      status.pics
 转发      status.retweetedStatus
    文本       status.retweetedStatus.user + status.retweetedStatus.text
    图片       status.retweetedStatus.pics
    卡片       status.retweetedStatus.pageInfo
 卡片      status.pageInfo
 Tip       status.tagStruct
 
 1.根据 urlStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+友好描述
 2.根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
 2.匹配 @用户名
 4.匹配 [表情]
 
 一条里，图片|转发|卡片不能同时存在，优先级是 转发->图片->卡片
 如果不是转发，则显示Tip
 
 
 文本
 文本 图片/卡片
 文本 Tip
 文本 图片/卡片 Tip
 
 文本 转发[文本]  /Tip
 文本 转发[文本 图片] /Tip
 文本 转发[文本 卡片] /Tip
 
 话题                                 #爸爸去哪儿#
 电影 timeline_card_small_movie       #冰雪奇缘[电影]#
 图书 timeline_card_small_book        #纸牌屋[图书]#
 音乐 timeline_card_small_music       #Let It Go[音乐]#
 地点 timeline_card_small_location    #理想国际大厦[地点]#
 股票 timeline_icon_stock             #腾讯控股 kh00700[股票]#
 */

@end




/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface WBTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end
