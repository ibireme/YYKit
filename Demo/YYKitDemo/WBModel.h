//
//  WBModel.h
//  YYKitExample
//
//  Created by ibireme on 15/9/4.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>



/// 认证方式
typedef NS_ENUM(NSUInteger, WBUserVerifyType){
    WBUserVerifyTypeNone = 0,     ///< 没有认证
    WBUserVerifyTypeStandard,     ///< 个人认证，黄V
    WBUserVerifyTypeOrganization, ///< 官方认证，蓝V
    WBUserVerifyTypeClub,         ///< 达人认证，红星
};


/// 图片标记
typedef NS_ENUM(NSUInteger, WBPictureBadgeType) {
    WBPictureBadgeTypeNone = 0, ///< 正常图片
    WBPictureBadgeTypeLong,     ///< 长图
    WBPictureBadgeTypeGIF,      ///< GIF
};



/**
 一个图片的元数据
 */
@interface WBPictureMetadata : NSObject
@property (nonatomic, strong) NSURL *url; ///< Full image url
@property (nonatomic, assign) int width; ///< pixel width
@property (nonatomic, assign) int height; ///< pixel height
@property (nonatomic, strong) NSString *type; ///< "WEBP" "JPEG" "GIF"
@property (nonatomic, assign) int cutType; ///< Default:1
@property (nonatomic, assign) WBPictureBadgeType badgeType;
@end


/**
 图片
 */
@interface WBPicture : NSObject
@property (nonatomic, strong) NSString *picID;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, assign) int photoTag;
@property (nonatomic, assign) BOOL keepSize; ///< YES:固定为方形 NO:原始宽高比
@property (nonatomic, strong) WBPictureMetadata *thumbnail;  ///< w:180
@property (nonatomic, strong) WBPictureMetadata *bmiddle;    ///< w:360 (列表中的缩略图)
@property (nonatomic, strong) WBPictureMetadata *middlePlus; ///< w:480
@property (nonatomic, strong) WBPictureMetadata *large;      ///< w:720 (放大查看)
@property (nonatomic, strong) WBPictureMetadata *largest;    ///<       (查看原图)
@property (nonatomic, strong) WBPictureMetadata *original;   ///<
@property (nonatomic, assign) WBPictureBadgeType badgeType;
@end


/**
 链接
 */
@interface WBURL : NSObject
@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) NSString *shortURL; ///< 短域名 (原文)
@property (nonatomic, strong) NSString *oriURL;   ///< 原始链接
@property (nonatomic, strong) NSString *urlTitle; ///< 显示文本，例如"网页链接"，可能需要裁剪(24)
@property (nonatomic, strong) NSString *urlTypePic; ///< 链接类型的图片URL
@property (nonatomic, assign) int32_t urlType; ///< 0:一般链接 36地点 39视频/图片
@property (nonatomic, strong) NSString *log;
@property (nonatomic, strong) NSDictionary *actionLog;
@property (nonatomic, strong) NSString *pageID; ///< 对应着 WBPageInfo
@property (nonatomic, strong) NSString *storageType;
//如果是图片，则会有下面这些，可以直接点开看
@property (nonatomic, strong) NSArray<NSString *> *picIds;
@property (nonatomic, strong) NSDictionary<NSString *, WBPicture *> *picInfos;
@property (nonatomic, strong) NSArray<WBPicture *> *pics;
@end


/**
 话题
 */
@interface WBTopic : NSObject
@property (nonatomic, strong) NSString *topicTitle; ///< 话题标题
@property (nonatomic, strong) NSString *topicURL; ///< 话题链接 sinaweibo://
@end


/**
 标签
 */
@interface WBTag : NSObject
@property (nonatomic, strong) NSString *tagName; ///< 标签名字，例如"上海·上海文庙"
@property (nonatomic, strong) NSString *tagScheme; ///< 链接 sinaweibo://...
@property (nonatomic, assign) int32_t tagType; ///< 1 地点 2其他
@property (nonatomic, assign) int32_t tagHidden;
@property (nonatomic, strong) NSURL *urlTypePic; ///< 需要加 _default
@end


/**
 按钮
 */
@interface WBButtonLink : NSObject
@property (nonatomic, strong) NSURL *pic;  ///< 按钮图片URL (需要加_default)
@property (nonatomic, strong) NSString *name; ///< 按钮文本，例如"点评"
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *params;
@end


/**
 卡片 (样式有多种，最常见的是下方这样)
 -----------------------------
          title
  pic     title        button
          tips
 -----------------------------
 */
@interface WBPageInfo : NSObject
@property (nonatomic, strong) NSString *pageTitle; ///< 页面标题，例如"上海·上海文庙"
@property (nonatomic, strong) NSString *pageID;
@property (nonatomic, strong) NSString *pageDesc; ///< 页面描述，例如"上海市黄浦区文庙路215号"
@property (nonatomic, strong) NSString *content1;
@property (nonatomic, strong) NSString *content2;
@property (nonatomic, strong) NSString *content3;
@property (nonatomic, strong) NSString *content4;
@property (nonatomic, strong) NSString *tips; ///< 提示，例如"4222条微博"
@property (nonatomic, strong) NSString *objectType; ///< 类型，例如"place" "video"
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *scheme; ///< 真实链接，例如 http://v.qq.com/xxx
@property (nonatomic, strong) NSArray<WBButtonLink *> *buttons;

@property (nonatomic, assign) int32_t isAsyn;
@property (nonatomic, assign) int32_t type;
@property (nonatomic, strong) NSString *pageURL; ///< 链接 sinaweibo://...
@property (nonatomic, strong) NSURL *pagePic; ///< 图片URL，不需要加(_default) 通常是左侧的方形图片
@property (nonatomic, strong) NSURL *typeIcon; ///< Badge 图片URL，不需要加(_default) 通常放在最左上角角落里
@property (nonatomic, assign) int32_t actStatus;
@property (nonatomic, strong) NSDictionary *actionlog;
@property (nonatomic, strong) NSDictionary *mediaInfo;
@end

/**
 微博标题
 */
@interface WBStatusTitle : NSObject
@property (nonatomic, assign) int32_t baseColor;
@property (nonatomic, strong) NSString *text; ///< 文本，例如"仅自己可见"
@property (nonatomic, strong) NSString *iconURL; ///< 图标URL，需要加Default
@end

/**
 用户
 */
@interface WBUser : NSObject
@property (nonatomic, assign) uint64_t userID; ///< id (int)
@property (nonatomic, strong) NSString *idString; ///< id (string)
@property (nonatomic, assign) int32_t gender; /// 0:none 1:男 2:女
@property (nonatomic, strong) NSString *genderString; /// "m":男 "f":女 "n"未知
@property (nonatomic, strong) NSString *desc; ///< 个人简介
@property (nonatomic, strong) NSString *domain; ///< 个性域名

@property (nonatomic, strong) NSString *name; ///< 昵称
@property (nonatomic, strong) NSString *screenName; ///< 友好昵称
@property (nonatomic, strong) NSString *remark; ///< 备注

@property (nonatomic, assign) int32_t followersCount; ///< 粉丝数
@property (nonatomic, assign) int32_t friendsCount; ///< 关注数
@property (nonatomic, assign) int32_t biFollowersCount; ///< 好友数 (双向关注)
@property (nonatomic, assign) int32_t favouritesCount; ///< 收藏数
@property (nonatomic, assign) int32_t statusesCount; ///< 微博数
@property (nonatomic, assign) int32_t topicsCount; ///< 话题数
@property (nonatomic, assign) int32_t blockedCount; ///< 屏蔽数
@property (nonatomic, assign) int32_t pagefriendsCount;
@property (nonatomic, assign) BOOL followMe;
@property (nonatomic, assign) BOOL following;

@property (nonatomic, strong) NSString *province; ///< 省
@property (nonatomic, strong) NSString *city;     ///< 市

@property (nonatomic, strong) NSString *url; ///< 博客地址
@property (nonatomic, strong) NSURL *profileImageURL; ///< 头像 50x50 (FeedList)
@property (nonatomic, strong) NSURL *avatarLarge;     ///< 头像 180*180
@property (nonatomic, strong) NSURL *avatarHD;        ///< 头像 原图
@property (nonatomic, strong) NSURL *coverImage;      ///< 封面图 920x300
@property (nonatomic, strong) NSURL *coverImagePhone;

@property (nonatomic, strong) NSString *profileURL;
@property (nonatomic, assign) int32_t type;
@property (nonatomic, assign) int32_t ptype;
@property (nonatomic, assign) int32_t mbtype;
@property (nonatomic, assign) int32_t urank; ///< 微博等级 (LV)
@property (nonatomic, assign) int32_t uclass;
@property (nonatomic, assign) int32_t ulevel;
@property (nonatomic, assign) int32_t mbrank; ///< 会员等级 (橙名 VIP)
@property (nonatomic, assign) int32_t star;
@property (nonatomic, assign) int32_t level;
@property (nonatomic, strong) NSDate *createdAt; ///< 注册时间
@property (nonatomic, assign) BOOL allowAllActMsg;
@property (nonatomic, assign) BOOL allowAllComment;
@property (nonatomic, assign) BOOL geoEnabled;
@property (nonatomic, assign) int32_t onlineStatus;
@property (nonatomic, strong) NSString *location; ///< 所在地
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *icons;
@property (nonatomic, strong) NSString *weihao;
@property (nonatomic, strong) NSString *badgeTop;
@property (nonatomic, assign) int32_t blockWord;
@property (nonatomic, assign) int32_t blockApp;
@property (nonatomic, assign) int32_t hasAbilityTag;
@property (nonatomic, assign) int32_t creditScore; ///< 信用积分
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *badge; ///< 勋章
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, assign) int32_t userAbility;
@property (nonatomic, strong) NSDictionary *extend;

@property (nonatomic, assign) BOOL verified; ///< 微博认证 (大V)
@property (nonatomic, assign) int32_t verifiedType;
@property (nonatomic, assign) int32_t verifiedLevel;
@property (nonatomic, assign) int32_t verifiedState;
@property (nonatomic, strong) NSString *verifiedContactEmail;
@property (nonatomic, strong) NSString *verifiedContactMobile;
@property (nonatomic, strong) NSString *verifiedTrade;
@property (nonatomic, strong) NSString *verifiedContactName;
@property (nonatomic, strong) NSString *verifiedSource;
@property (nonatomic, strong) NSString *verifiedSourceURL;
@property (nonatomic, strong) NSString *verifiedReason; ///< 微博认证描述
@property (nonatomic, strong) NSString *verifiedReasonURL;
@property (nonatomic, strong) NSString *verifiedReasonModified;

@property (nonatomic, assign) WBUserVerifyType userVerifyType;

@end


/**
 微博
 */
@interface WBStatus : NSObject
@property (nonatomic, assign) uint64_t statusID; ///< id (number)
@property (nonatomic, strong) NSString *idstr; ///< id (string)
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSDate *createdAt; ///< 发布时间

@property (nonatomic, strong) WBUser *user;
@property (nonatomic, assign) int32_t userType;

@property (nonatomic, strong) WBStatusTitle *title; ///< 标题栏 (通常为nil)
@property (nonatomic, strong) NSString *picBg; ///< 微博VIP背景图，需要替换 "os7"
@property (nonatomic, strong) NSString *text; ///< 正文
@property (nonatomic, strong) NSURL *thumbnailPic; ///< 缩略图
@property (nonatomic, strong) NSURL *bmiddlePic; ///< 中图
@property (nonatomic, strong) NSURL *originalPic; ///< 大图

@property (nonatomic, strong) WBStatus *retweetedStatus; ///转发微博

@property (nonatomic, strong) NSArray<NSString *> *picIds;
@property (nonatomic, strong) NSDictionary<NSString *, WBPicture *> *picInfos;

@property (nonatomic, strong) NSArray<WBPicture *> *pics;
@property (nonatomic, strong) NSArray<WBURL *> *urlStruct;
@property (nonatomic, strong) NSArray<WBTopic *> *topicStruct;
@property (nonatomic, strong) NSArray<WBTag *> *tagStruct;
@property (nonatomic, strong) WBPageInfo *pageInfo;

@property (nonatomic, assign) BOOL favorited; ///< 是否收藏
@property (nonatomic, assign) BOOL truncated;  ///< 是否截断
@property (nonatomic, assign) int32_t repostsCount; ///< 转发数
@property (nonatomic, assign) int32_t commentsCount; ///< 评论数
@property (nonatomic, assign) int32_t attitudesCount; ///< 赞数
@property (nonatomic, assign) int32_t attitudesStatus; ///< 是否已赞 0:没有
@property (nonatomic, assign) int32_t recomState;

@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, strong) NSString *inReplyToStatusId;
@property (nonatomic, strong) NSString *inReplyToUserId;

@property (nonatomic, strong) NSString *source; ///< 来自 XXX
@property (nonatomic, assign) int32_t sourceType;
@property (nonatomic, assign) int32_t sourceAllowClick; ///< 来源是否允许点击

@property (nonatomic, strong) NSDictionary *geo;
@property (nonatomic, strong) NSArray *annotations; ///< 地理位置
@property (nonatomic, assign) int32_t bizFeature;
@property (nonatomic, assign) int32_t mlevel;
@property (nonatomic, strong) NSString *mblogid;
@property (nonatomic, strong) NSString *mblogTypeName;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSDictionary *visible;
@property (nonatomic, strong) NSArray *darwinTags;
@end


/**
 一次API请求的数据
 */
@interface WBTimelineItem : NSObject
@property (nonatomic, strong) NSArray *ad;
@property (nonatomic, strong) NSArray *advertises;
@property (nonatomic, strong) NSString *gsid;
@property (nonatomic, assign) int32_t interval;
@property (nonatomic, assign) int32_t uveBlank;
@property (nonatomic, assign) int32_t hasUnread;
@property (nonatomic, assign) int32_t totalNumber;
@property (nonatomic, strong) NSString *sinceID;
@property (nonatomic, strong) NSString *maxID;
@property (nonatomic, strong) NSString *previousCursor;
@property (nonatomic, strong) NSString *nextCursor;
@property (nonatomic, strong) NSArray<WBStatus *> *statuses;
/*
 groupInfo
 trends
 */
@end







@class WBEmoticonGroup;

typedef NS_ENUM(NSUInteger, WBEmoticonType) {
    WBEmoticonTypeImage = 0, ///< 图片表情
    WBEmoticonTypeEmoji = 1, ///< Emoji表情
};

@interface WBEmoticon : NSObject
@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) WBEmoticonType type;
@property (nonatomic, weak) WBEmoticonGroup *group;
@end


@interface WBEmoticonGroup : NSObject
@property (nonatomic, strong) NSString *groupID; ///< 例如 com.sina.default
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSString *nameCN; ///< 例如 浪小花
@property (nonatomic, strong) NSString *nameEN;
@property (nonatomic, strong) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray<WBEmoticon *> *emoticons;
@end
