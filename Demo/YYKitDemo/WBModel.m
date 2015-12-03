//
//  WBModel.m
//  YYKitExample
//
//  Created by ibireme on 15/9/4.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "WBModel.h"

@implementation WBPictureMetadata
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cutType" : @"cut_type"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([_type isEqualToString:@"GIF"]) {
        _badgeType = WBPictureBadgeTypeGIF;
    } else {
        if (_width > 0 && (float)_height / _width > 3) {
            _badgeType = WBPictureBadgeTypeLong;
        }
    }
    return YES;
}
@end

@implementation WBPicture
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"picID" : @"pic_id",
             @"keepSize" : @"keep_size",
             @"photoTag" : @"photo_tag",
             @"objectID" : @"object_id",
             @"middlePlus" : @"middleplus"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    WBPictureMetadata *meta = _large ? _large : _largest ? _largest : _original;
    _badgeType = meta.badgeType;
    return YES;
}
@end

@implementation WBURL
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"oriURL" : @"ori_url",
             @"urlTitle" : @"url_title",
             @"urlTypePic" : @"url_type_pic",
             @"urlType" : @"url_type",
             @"shortURL" : @"short_url",
             @"actionLog" : @"actionlog",
             @"pageID" : @"page_id",
             @"storageType" : @"storage_type",
             @"picIds" : @"pic_ids",
             @"picInfos" : @"pic_infos"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picIds" : [NSString class],
             @"picInfos" : [WBPicture class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 自动 model-mapper 不能完成的，这里可以进行额外处理
    _pics = nil;
    if (_picIds.count != 0) {
        NSMutableArray *pics = [NSMutableArray new];
        for (NSString *picId in _picIds) {
            WBPicture *pic = _picInfos[picId];
            if (pic) {
                [pics addObject:pic];
            }
        }
        _pics = pics;
    }
    return YES;
}
@end

@implementation WBTopic
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"topicTitle" : @"topic_title",
             @"topicURL" : @"topic_url"};
}
@end

@implementation WBTag
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tagHidden" : @"tag_hidden",
             @"tagName" : @"tag_name",
             @"tagScheme" : @"tag_scheme",
             @"tagType" : @"tag_type",
             @"urlTypePic" : @"url_type_pic"};
}
@end

@implementation WBButtonLink
@end

@implementation WBPageInfo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pageTitle" : @"page_title",
             @"pageID" : @"page_id",
             @"pageDesc" : @"page_desc",
             @"objectType" : @"object_type",
             @"objectID" : @"object_id",
             @"isAsyn" : @"is_asyn",
             @"pageURL" : @"page_url",
             @"pagePic" : @"page_pic",
             @"actStatus" : @"act_status",
             @"mediaInfo" : @"media_info",
             @"typeIcon" : @"type_icon"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"buttons" : [WBButtonLink class]};
}
@end

@implementation WBStatusTitle
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"baseColor" : @"base_color",
             @"iconURL" : @"icon_url"};
}
@end

@implementation WBUser
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID" : @"id",
             @"idString" : @"idstr",
             @"genderString" : @"gender",
             @"biFollowersCount" : @"bi_followers_count",
             @"profileImageURL" : @"profile_image_url",
             @"uclass" : @"class",
             @"verifiedContactEmail" : @"verified_contact_email",
             @"statusesCount" : @"statuses_count",
             @"geoEnabled" : @"geo_enabled",
             @"topicsCount" : @"topics_count",
             @"blockedCount" : @"blocked_count",
             @"followMe" : @"follow_me",
             @"coverImagePhone" : @"cover_image_phone",
             @"desc" : @"description",
             @"followersCount" : @"followers_count",
             @"verifiedContactMobile" : @"verified_contact_mobile",
             @"avatarLarge" : @"avatar_large",
             @"verifiedTrade" : @"verified_trade",
             @"profileURL" : @"profile_url",
             @"coverImage" : @"cover_image",
             @"onlineStatus"  : @"online_status",
             @"badgeTop" : @"badge_top",
             @"verifiedContactName" : @"verified_contact_name",
             @"screenName" : @"screen_name",
             @"verifiedSourceURL" : @"verified_source_url",
             @"pagefriendsCount" : @"pagefriends_count",
             @"verifiedReason" : @"verified_reason",
             @"friendsCount" : @"friends_count",
             @"blockApp" : @"block_app",
             @"hasAbilityTag" : @"has_ability_tag",
             @"avatarHD" : @"avatar_hd",
             @"creditScore" : @"credit_score",
             @"createdAt" : @"created_at",
             @"blockWord" : @"block_word",
             @"allowAllActMsg" : @"allow_all_act_msg",
             @"verifiedState" : @"verified_state",
             @"verifiedReasonModified" : @"verified_reason_modified",
             @"allowAllComment" : @"allow_all_comment",
             @"verifiedLevel" : @"verified_level",
             @"verifiedReasonURL" : @"verified_reason_url",
             @"favouritesCount" : @"favourites_count",
             @"verifiedType" : @"verified_type",
             @"verifiedSource" : @"verified_source",
             @"userAbility" : @"user_ability"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 自动 model-mapper 不能完成的，这里可以进行额外处理
    _gender = 0;
    if ([_genderString isEqualToString:@"m"]) {
        _gender = 1;
    } else if ([_genderString isEqualToString:@"f"]) {
        _gender = 2;
    }
    
    // 这个不一定准。。
    if (_verified) {
        _userVerifyType = WBUserVerifyTypeStandard;
    } else if (_verifiedType == 220) {
        _userVerifyType = WBUserVerifyTypeClub;
    } else if (_verifiedType == -1 && _verifiedLevel == 3) {
        _userVerifyType = WBUserVerifyTypeOrganization;
    } else {
        _userVerifyType = WBUserVerifyTypeNone;
    }
    return YES;
}
@end

@implementation WBStatus
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"statusID" : @"id",
             @"createdAt" : @"created_at",
             @"attitudesStatus" : @"attitudes_status",
             @"inReplyToScreenName" : @"in_reply_to_screen_name",
             @"sourceType" : @"source_type",
             @"picBg" : @"pic_bg",
             @"commentsCount" : @"comments_count",
             @"thumbnailPic" : @"thumbnail_pic",
             @"recomState" : @"recom_state",
             @"sourceAllowClick" : @"source_allowclick",
             @"bizFeature" : @"biz_feature",
             @"retweetedStatus" : @"retweeted_status",
             @"mblogTypeName" : @"mblogtypename",
             @"urlStruct" : @"url_struct",
             @"topicStruct" : @"topic_struct",
             @"tagStruct" : @"tag_struct",
             @"pageInfo" : @"page_info",
             @"bmiddlePic" : @"bmiddle_pic",
             @"inReplyToStatusId" : @"in_reply_to_status_id",
             @"picIds" : @"pic_ids",
             @"repostsCount" : @"reposts_count",
             @"attitudesCount" : @"attitudes_count",
             @"darwinTags" : @"darwin_tags",
             @"userType" : @"userType",
             @"picInfos" : @"pic_infos",
             @"inReplyToUserId" : @"in_reply_to_user_id",
             @"originalPic" : @"original_pic"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picIds" : [NSString class],
             @"picInfos" : [WBPicture class],
             @"urlStruct" : [WBURL class],
             @"topicStruct" : [WBTopic class],
             @"tagStruct" : [WBTag class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 自动 model-mapper 不能完成的，这里可以进行额外处理
    _pics = nil;
    if (_picIds.count != 0) {
        NSMutableArray *pics = [NSMutableArray new];
        for (NSString *picId in _picIds) {
            WBPicture *pic = _picInfos[picId];
            if (pic) {
                [pics addObject:pic];
            }
        }
        _pics = pics;
    }
    if (_retweetedStatus) {
        if (_retweetedStatus.urlStruct.count == 0) {
            _retweetedStatus.urlStruct = _urlStruct;
        }
        if (_retweetedStatus.pageInfo == nil) {
            _retweetedStatus.pageInfo = _pageInfo;
        }
    }
    return YES;
    
}
@end

@implementation WBTimelineItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"hasVisible" : @"hasvisible",
             @"previousCursor" : @"previous_cursor",
             @"uveBlank" : @"uve_blank",
             @"hasUnread" : @"has_unread",
             @"totalNumber" : @"total_number",
             @"maxID" : @"max_id",
             @"sinceID" : @"since_id",
             @"nextCursor" : @"next_cursor"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"statuses" : [WBStatus class]};
}
@end


@implementation WBEmoticon
+ (NSArray *)modelPropertyBlacklist {
    return @[@"group"];
}
@end

@implementation WBEmoticonGroup
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupID" : @"id",
             @"nameCN" : @"group_name_cn",
             @"nameEN" : @"group_name_en",
             @"nameTW" : @"group_name_tw",
             @"displayOnly" : @"display_only",
             @"groupType" : @"group_type"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emoticons" : [WBEmoticon class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [_emoticons enumerateObjectsUsingBlock:^(WBEmoticon *emoticon, NSUInteger idx, BOOL *stop) {
        emoticon.group = self;
    }];
    return YES;
}
@end
