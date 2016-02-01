//
//  T1Model.h
//  YYKitExample
//
//  Created by ibireme on 15/10/9.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@class T1User;


@interface T1UserMention : NSObject
@property (nonatomic, assign) uint32_t uid;
@property (nonatomic, strong) NSString *uidStr;
@property (nonatomic, strong) NSString *name;       // e.g. "Nick Lockwood"
@property (nonatomic, strong) NSString *screenName; // e.g. "nicklockwood"
@property (nonatomic, strong) NSArray<NSNumber *> *indices;     // Array<NSNumber> from, to

@property (nonatomic, assign) NSRange range;        // range from indices
@property (nonatomic, strong) NSArray<NSValue *> *ranges;      // Array<NSValue(NSRange)> nil if range is less than or equal to one.
@property (nonatomic, strong) T1User *user;         // reference
@end


@interface T1URL : NSObject
@property (nonatomic, strong) NSString *url;         // e.g. "http://t.co/YuvsPou0rj"
@property (nonatomic, strong) NSString *displayURL;  // e.g. "apple.com/tv/compare/"
@property (nonatomic, strong) NSString *expandedURL; // e.g. "http://www.apple.com/tv/compare/"
@property (nonatomic, strong) NSArray<NSNumber *> *indices;      // Array<NSNumber> from, to

@property (nonatomic, assign) NSRange range;         // range from indices
@property (nonatomic, strong) NSArray<NSValue *> *ranges;       // Array<NSValue(NSRange)> nil if range is less than or equal to one.
@end


@interface T1HashTag : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray<NSNumber *> *indices;  // Array<NSNumber> from, to

@property (nonatomic, assign) NSRange range;     // range from indices
@property (nonatomic, strong) NSArray<NSValue *> *ranges;   // Array<NSValue(NSRange)> nil if range is less than or equal to one.
@end


@interface T1MediaMeta : NSObject
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) NSString *resize; // fit, crop
@property (nonatomic, assign) BOOL isCrop;      // resize is "crop"
@property (nonatomic, strong) NSArray<NSValue *> *faces;   // Array<NSValue(CGRect)>
@property (nonatomic, strong) NSURL *url;       // add
@end


@interface T1Media : NSObject
@property (nonatomic, assign) uint64_t mid;
@property (nonatomic, strong) NSString *midStr;
@property (nonatomic, strong) NSString *type;          // photo/..
@property (nonatomic, strong) NSString *url;           // e.g. "http://t.co/X4kGxbKcBu"
@property (nonatomic, strong) NSString *displayURL;    // e.g. "pic.twitter.com/X4kGxbKcBu"
@property (nonatomic, strong) NSString *expandedURL;   // e.g. "http://twitter.com/edelwax/status/652117831883034624/photo/1"
@property (nonatomic, strong) NSString *mediaURL;      // e.g. "http://pbs.twimg.com/media/CQzJtkbXAAAO2v3.png"
@property (nonatomic, strong) NSString *mediaURLHttps; // e.g. "https://pbs.twimg.com/media/CQzJtkbXAAAO2v3.png"
@property (nonatomic, strong) NSArray<NSNumber *> *indices;        // Array<NSNumber> from, to

@property (nonatomic, assign) NSRange range;           // range from indices
@property (nonatomic, strong) NSArray<NSValue *> *ranges;         // Array<NSValue(NSRange)> nil if range is less than or equal to one.

@property (nonatomic, strong) T1MediaMeta *mediaThumb;
@property (nonatomic, strong) T1MediaMeta *mediaSmall;
@property (nonatomic, strong) T1MediaMeta *mediaMedium;
@property (nonatomic, strong) T1MediaMeta *mediaLarge;
@property (nonatomic, strong) T1MediaMeta *mediaOrig;
@end


@interface T1Place : NSObject
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *placeType;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSArray *containedWithin;
@property (nonatomic, strong) NSDictionary *boundingBox;
@property (nonatomic, strong) NSDictionary *attributes;
@end



@interface T1Card : NSObject
@property (nonatomic, strong) NSDictionary *users; // <NSString(uid), T1User>
@property (nonatomic, strong) NSString *cardTypeURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *bindingValues;
@end



@interface T1User : NSObject
@property (nonatomic, assign) uint64_t uid;
@property (nonatomic, strong) NSString *uidStr;
@property (nonatomic, strong) NSString *name;       // e.g. "Nick Lockwood"
@property (nonatomic, strong) NSString *screenName; // e.g. "nicklockwood"
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, assign) uint32_t listedCount;
@property (nonatomic, assign) uint32_t statusesCount;
@property (nonatomic, assign) uint32_t favouritesCount;
@property (nonatomic, assign) uint32_t friendsCount;

// http://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi_normal.jpeg original
// http://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi_reasonably_small.jpeg replaced
@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSURL *profileImageURLReasonablySmall; // replaced
@property (nonatomic, strong) NSURL *profileImageURLHttps;
@property (nonatomic, strong) NSURL *profileBackgroundImageURL;
@property (nonatomic, strong) NSURL *profileBackgroundImageURLHttps;

@property (nonatomic, strong) NSString *profileBackgroundColor;
@property (nonatomic, strong) NSString *profileTextColor;
@property (nonatomic, strong) NSString *profileSidebarFillColor;
@property (nonatomic, strong) NSString *profileSidebarBorderColor;
@property (nonatomic, strong) NSString *profileLinkColor;

@property (nonatomic, strong) NSDictionary *entities;
@property (nonatomic, strong) NSDictionary *counts;

@property (nonatomic, assign) BOOL verified;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL followRequestSent;
@property (nonatomic, assign) BOOL defaultProfile;
@property (nonatomic, assign) BOOL defaultProfileImage;
@property (nonatomic, assign) BOOL profileBackgroundTile;
@property (nonatomic, assign) BOOL profileUseBackgroundImage;
@property (nonatomic, assign) BOOL isProtected;
@property (nonatomic, assign) BOOL isTranslator;
@property (nonatomic, assign) BOOL notifications;
@property (nonatomic, assign) BOOL geoEnabled;
@property (nonatomic, assign) BOOL contributorsEnabled;
@property (nonatomic, assign) BOOL isTranslationEnabled;
@property (nonatomic, assign) BOOL hasExtendedProfile;

@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, assign) int32_t utcOffset;
@end



@interface T1Tweet : NSObject
@property (nonatomic, assign) uint64_t tid;
@property (nonatomic, strong) NSString *tidStr;

@property (nonatomic, strong) T1User *user;
@property (nonatomic, strong) T1Place *place;
@property (nonatomic, strong) T1Card *card;
@property (nonatomic, strong) T1Tweet *retweetedStatus;
@property (nonatomic, strong) T1Tweet *quotedStatus;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSArray<T1Media *> *medias;
@property (nonatomic, strong) NSArray<T1Media *> *extendedMedias;
@property (nonatomic, strong) NSArray<T1UserMention *> *userMentions;
@property (nonatomic, strong) NSArray<T1URL *> *urls;
@property (nonatomic, strong) NSArray<T1HashTag *> *hashTags;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) BOOL truncated;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL isQuoteStatus;
@property (nonatomic, assign) uint32_t favoriteCount;
@property (nonatomic, assign) uint32_t retweetCount;
@property (nonatomic, assign) uint64_t conversationID;
@property (nonatomic, assign) uint32_t inReplyToUserId;
@property (nonatomic, strong) NSArray *contributors;
@property (nonatomic, assign) uint64_t inReplyToStatusID;
@property (nonatomic, strong) NSString *inReplyToStatusIDStr;
@property (nonatomic, strong) NSString *inReplyToUserIDStr;
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSDictionary *geo;
@property (nonatomic, strong) NSString *supplementalLanguage;
@property (nonatomic, strong) NSArray *coordinates;
@end


@interface T1Conversation : NSObject
@property (nonatomic, strong) NSString *targetTweetID;
@property (nonatomic, strong) NSArray *participantIDs;
@property (nonatomic, assign) uint32_t participantsCount;
@property (nonatomic, assign) uint32_t targetCount; // 0 if no target items
@property (nonatomic, strong) NSString *rootUserID;
@property (nonatomic, strong) NSArray *contextIDs; //<
@property (nonatomic, strong) NSArray *entityIDs;

@property (nonatomic, strong) NSArray *tweets; // Array<T1Tweet>
@end





@interface T1APIRespose : NSObject
@property (nonatomic, strong) NSDictionary *moments; ///< empty
@property (nonatomic, strong) NSDictionary<NSString *, T1User *> *users; ///< <UID(NSString), T1User>
@property (nonatomic, strong) NSDictionary<NSString *, T1Tweet *> *tweets; ///< <TID(NSString), T1Tweet>
@property (nonatomic, strong) NSArray *timelineItmes; ///< Array<T1Tweet/T1Conversation>
@property (nonatomic, strong) NSArray *timeline; ///< Array<Dictionary>

@property (nonatomic, strong) NSString *cursorTop;
@property (nonatomic, strong) NSString *cursorBottom;
@property (nonatomic, strong) NSArray *cursorGaps;
@end
