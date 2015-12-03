//
//  T1Model.m
//  YYKitExample
//
//  Created by ibireme on 15/10/9.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "T1Model.h"

@implementation T1UserMention
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"screenName" : @"screen_name",
        @"uidStr" : @"id_str",
        @"uid" : @"id",
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"indices" : [NSNumber class] };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    int rangeCount = (int)_indices.count / 2;
    NSMutableArray *ranges = nil;
    for (int i = 0; i < rangeCount; i++) {
        int from = ((NSNumber *)_indices[i * 2]).intValue;
        int to = ((NSNumber *)_indices[i * 2 + 1]).intValue;
        NSRange range = NSMakeRange(from, to >= from ? (to - from) : 0);
        if (i == 0) {
            _range = range;
        }
        if (rangeCount > 1) {
            [ranges addObject:[NSValue valueWithRange:range]];
        }
    }
    _ranges = ranges;
    return YES;
}
@end

@implementation T1URL
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"screenName" : @"screen_name",
              @"idStr" : @"id_str",
              @"displayURL" : @"display_url",
              @"expandedURL" : @"expanded_url"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"indices" : [NSNumber class] };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    int rangeCount = (int)_indices.count / 2;
    NSMutableArray *ranges = nil;
    for (int i = 0; i < rangeCount; i++) {
        int from = ((NSNumber *)_indices[i * 2]).intValue;
        int to = ((NSNumber *)_indices[i * 2 + 1]).intValue;
        NSRange range = NSMakeRange(from, to >= from ? (to - from) : 0);
        if (i == 0) {
            _range = range;
        }
        if (rangeCount > 1) {
            [ranges addObject:[NSValue valueWithRange:range]];
        }
    }
    _ranges = ranges;
    return YES;
}
@end

@implementation T1HashTag
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"indices" : [NSNumber class] };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    int rangeCount = (int)_indices.count / 2;
    NSMutableArray *ranges = nil;
    for (int i = 0; i < rangeCount; i++) {
        int from = ((NSNumber *)_indices[i * 2]).intValue;
        int to = ((NSNumber *)_indices[i * 2 + 1]).intValue;
        NSRange range = NSMakeRange(from, to >= from ? (to - from) : 0);
        if (i == 0) {
            _range = range;
        }
        if (rangeCount > 1) {
            [ranges addObject:[NSValue valueWithRange:range]];
        }
    }
    _ranges = ranges;
    return YES;
}
@end

@implementation T1MediaMeta
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"faces" : [NSValue class] };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _size = CGSizeMake(_width, _height);
    _isCrop = [_resize isEqualToString:@"crop"];
    _faces = nil;

    NSArray *faceDics = dic[@"faces"];
    if ([faceDics isKindOfClass:[NSArray class]] && faceDics.count > 0) {
        NSMutableArray *faces = [NSMutableArray new];
        for (NSDictionary *faceDic in faceDics) {
            if ([faceDic isKindOfClass:[NSDictionary class]]) {
                int x = [faceDic intValueForKey:@"x" default:0];
                int y = [faceDic intValueForKey:@"y" default:0];
                int w = [faceDic intValueForKey:@"w" default:0];
                int h = [faceDic intValueForKey:@"h" default:0];
                [faces addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w, h)]];
            }
        }
        _faces = faces;
    }
    return YES;
}
@end

@implementation T1Media
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"idStr" : @"id_str",
        @"mediaURLHttps" : @"media_url_https",
        @"mediaURL" : @"media_url",
        @"expandedURL" : @"expanded_url",
        @"displayURL" : @"display_url",
        @"mid" : @"id",
        @"midStr" : @"id_str",
        
        @"mediaThumb" : @"sizes.thumb",
        @"mediaSmall" : @"sizes.small",
        @"mediaMedium" : @"sizes.medium",
        @"mediaLarge" : @"sizes.large",
        @"mediaOrig" : @"sizes.orig"
    };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    int rangeCount = (int)_indices.count / 2;
    NSMutableArray *ranges = nil;
    for (int i = 0; i < rangeCount; i++) {
        int from = ((NSNumber *)_indices[i * 2]).intValue;
        int to = ((NSNumber *)_indices[i * 2 + 1]).intValue;
        NSRange range = NSMakeRange(from, to >= from ? (to - from) : 0);
        if (i == 0) {
            _range = range;
        }
        if (rangeCount > 1) {
            [ranges addObject:[NSValue valueWithRange:range]];
        }
    }
    _ranges = ranges;

    NSDictionary *featureDics = dic[@"features"];
    if ([featureDics isKindOfClass:[NSDictionary class]]) {
        [_mediaThumb modelSetWithDictionary:featureDics[@"thumb"]];
        [_mediaSmall modelSetWithDictionary:featureDics[@"small"]];
        [_mediaMedium modelSetWithDictionary:featureDics[@"medium"]];
        [_mediaLarge modelSetWithDictionary:featureDics[@"large"]];
        [_mediaOrig modelSetWithDictionary:featureDics[@"orig"]];
        
        NSString *url;
        url = [_mediaURL stringByAppendingString:@":thumb"];
        _mediaThumb.url = url ? [NSURL URLWithString:url] : nil;
        url = [_mediaURL stringByAppendingString:@":small"];
        _mediaSmall.url = url ? [NSURL URLWithString:url] : nil;
        url = [_mediaURL stringByAppendingString:@":medium"];
        _mediaMedium.url = url ? [NSURL URLWithString:url] : nil;
        url = [_mediaURL stringByAppendingString:@":large"];
        _mediaLarge.url = url ? [NSURL URLWithString:url] : nil;
        url = [_mediaURL stringByAppendingString:@":orig"];
        _mediaOrig.url = url ? [NSURL URLWithString:url] : nil;
    }
    return YES;
}
@end

@implementation T1Place
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"fullName" : @"full_name",
        @"placeType" : @"place_type",
        @"countryCode" : @"country_code",
        @"pid" : @"id",
        @"boundingBox" : @"bounding_box",
        @"containedWithin" : @"contained_within"
    };
}
@end

@implementation T1Card
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"users" : [T1User class] };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"cardTypeURL" : @"card_type_url", @"bindingValues" : @"binding_values" };
}
@end

@implementation T1User
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"isProtected" : @"protected",
        @"isTranslator" : @"is_translator",
        @"profileImageURL" : @"profile_image_url",
        @"createdAt" : @"created_at",
        @"uid" : @"id",
        @"defaultProfileImage" : @"default_profile_image",
        @"listedCount" : @"listed_count",
        @"profileBackgroundColor" : @"profile_background_color",
        @"followRequestSent" : @"follow_request_sent",
        @"desc" : @"description",
        @"geoEnabled" : @"geo_enabled",
        @"profileTextColor" : @"profile_text_color",
        @"statusesCount" : @"statuses_count",
        @"profileBackgroundTile" : @"profile_background_tile",
        @"profileUseBackgroundImage" : @"profile_use_background_image",
        @"uidStr" : @"id_str",
        @"profileImageURLHttps" : @"profile_image_url_https",
        @"profileSidebarFillColor" : @"profile_sidebar_fill_color",
        @"profileSidebarBorderColor" : @"profile_sidebar_border_color",
        @"contributorsEnabled" : @"contributors_enabled",
        @"defaultProfile" : @"default_profile",
        @"screenName" : @"screen_name",
        @"timeZone" : @"time_zone",
        @"profileBackgroundImageURL" : @"profile_background_image_url",
        @"profileBackgroundImageURLHttps" : @"profile_background_image_url_https",
        @"profileLinkColor" : @"profile_link_color",
        @"favouritesCount" : @"favourites_count",
        @"isTranslationEnabled" : @"is_translation_enabled",
        @"utcOffset" : @"utc_offset",
        @"friendsCount" : @"friends_count",
        @"hasExtendedProfile" : @"has_extended_profile"
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (_profileImageURL) {
        NSMutableString *url = _profileImageURL.absoluteString.mutableCopy;
        NSString *ext = [url pathExtension];
        if (ext.length && url.length > ext.length + 2 + 7) {
            NSRange range = NSMakeRange(url.length - ext.length - 1 - 7, 7);
            if ([[url substringWithRange:range] isEqualToString:@"_normal"]) {
                [url replaceCharactersInRange:range withString:@"_reasonably_small"];
                _profileImageURLReasonablySmall = [NSURL URLWithString:url];
            }
        }
    }
    return YES;
}

@end

@implementation T1Tweet
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"medias" : [T1Media class],
        @"extendedMedias" : [T1Media class],
        @"userMentions" : [T1UserMention class],
        @"urls" : [T1URL class],
        @"hashTags" : [T1HashTag class]
    };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"isQuoteStatus" : @"is_quote_status",
        @"favoriteCount" : @"favorite_count",
        @"conversationID" : @"conversation_id",
        @"inReplyToScreenName" : @"in_reply_to_screen_name",
        @"retweetCount" : @"retweet_count",
        @"tid" : @"id",
        @"inReplyToUserId" : @"in_reply_to_user_id",
        @"supplementalLanguage" : @"supplemental_language",
        @"createdAt" : @"created_at",
        @"inReplyToStatusIDStr" : @"in_reply_to_status_id_str",
        @"inReplyToStatusID" : @"in_reply_to_status_id",
        @"inReplyToUserIDStr" : @"in_reply_to_user_id_str",
        @"tidStr" : @"id_str",
        @"retweetedStatus" : @"retweeted_status",
        @"quotedStatus" : @"quoted_status",
        
        @"medias" : @"emtities.media",
        @"extendedMedias" : @"extended_entities.media",
        @"userMentions" : @"entities.userMentions",
        @"urls" : @"entities.urls",
        @"hashTags" : @"entities.hashtags"
    };
}
@end


@implementation T1Conversation
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"participantIDs" : [NSString class],
        @"contextIDs" : [NSString class],
    };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"targetTweetID" : @"context.target_tweet_id",
        @"participantIDs" : @"context.participant_ids",
        @"participantsCount" : @"context.participants_count",
        @"targetCount" : @"context.target_count",
        @"rootUserID" : @"ccontext.root_user_id",
        @"contextIDs" : @"ids"
    };
}
@end


@implementation T1APIRespose
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"users" : [T1User class],
             @"tweets" : [T1Tweet class],
             @"timeline" : [NSDictionary class],
             @"hashTags" : [T1HashTag class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"users" : @"twitter_objects.users",
        @"tweets" : @"twitter_objects.tweets",
        @"timeline" : @"response.timeline",
        @"cursorTop" : @"response.cursor.top",
        @"cursorBottom" : @"response.cursor.bottom",
        @"cursorGaps" : @"response.cursor.gaps"
    };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSMutableArray *timelineItems = [NSMutableArray new];
    for (NSDictionary *dic in _timeline) {
        NSDictionary *tDic = dic[@"tweet"];
        if ([tDic isKindOfClass:[NSDictionary class]]) {
            NSString *tid = tDic[@"id"];
            if ([tid isKindOfClass:[NSString class]]) {
                T1Tweet *tweet = _tweets[tid];
                if (tweet) [timelineItems addObject:tweet];
            }
        } else {
            NSDictionary *cDic = dic[@"conversation"];
            if ([cDic isKindOfClass:[NSDictionary class]]) {
                T1Conversation *conversation = [T1Conversation modelWithDictionary:cDic];
                
                NSDictionary *entityID = dic[@"entity_id"];
                if ([entityID isKindOfClass:[NSDictionary class]]) {
                    NSArray *ids = entityID[@"ids"];
                    if ([ids isKindOfClass:[NSArray class]]) {
                        conversation.entityIDs = ids;
                    }
                }
                
                NSMutableArray *tweets = [NSMutableArray new];
                for (NSString *tid in conversation.contextIDs) {
                    T1Tweet *tweet = _tweets[tid];
                    if (tweet) [tweets addObject:tweet];
                }
                if (tweets.count > 1) {
                    conversation.tweets = tweets;
                    [timelineItems addObject:conversation];
                }
            }
        }
    }
    _timelineItmes = timelineItems;
    
    for (id item in _timelineItmes) {
        if ([item isKindOfClass:[T1Tweet class]]) {
            [self _updateTweetReference:item];
        } else if ([item isKindOfClass:[T1Conversation class]]) {
            for (T1Tweet *tweet in ((T1Conversation *)item).tweets) {
                [self _updateTweetReference:tweet];
            }
        }
    }
    return YES;
}

- (void)_updateTweetReference:(T1Tweet *)tweet {
    if (!tweet) return;
    T1User *user;
    for (T1UserMention *mention in tweet.userMentions) {
        user = mention.uidStr ? _users[mention.uidStr] : nil;
        mention.user = user;
    }
    for (T1UserMention *mention in tweet.retweetedStatus.userMentions) {
        user = mention.uidStr ? _users[mention.uidStr] : nil;
        mention.user = user;
    }
    
    user = tweet.user;
    user = user.uidStr ? _users[user.uidStr] : nil;
    tweet.user = user;
    
    user = tweet.retweetedStatus.user;
    user = user.uidStr ? _users[user.uidStr] : nil;
    tweet.retweetedStatus.user = user;
    
    user = tweet.quotedStatus.user;
    user = user.uidStr ? _users[user.uidStr] : nil;
    tweet.quotedStatus.user = user;
}

@end
