//
//  YYModelExample.m
//  YYKitExample
//
//  Created by ibireme on 15/7/18.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYModelExample.h"
#import "YYKit.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark Simple Object Example

@interface YYBook : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) uint64_t pages;
@property (nonatomic, strong) NSDate *publishDate;
@end

@implementation YYBook
@end

static void SimpleObjectExample() {
    YYBook *book = [YYBook modelWithJSON:@"     \
    {                                           \
       \"name\": \"Harry Potter\",              \
       \"pages\": 512,                          \
       \"publishDate\": \"2010-01-01\"          \
    }"];
    NSString *bookJSON = [book modelToJSONString];
    NSLog(@"Book: %@", bookJSON);
}




////////////////////////////////////////////////////////////////////////////////
#pragma mark Nest Object Example

@interface YYUser : NSObject
@property (nonatomic, assign) uint64_t uid;
@property (nonatomic, copy) NSString *name;
@end

@implementation YYUser
@end

@interface YYRepo : NSObject
@property (nonatomic, assign) uint64_t rid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) YYUser *owner;
@end

@implementation YYRepo
@end

static void NestObjectExample() {
    YYRepo *repo = [YYRepo modelWithJSON:@"         \
    {                                               \
        \"rid\": 123456789,                         \
        \"name\": \"YYKit\",                        \
        \"createTime\" : \"2011-06-09T06:24:26Z\",  \
        \"owner\": {                                \
            \"uid\" : 989898,                       \
            \"name\" : \"ibireme\"                  \
        } \
    }"];
    NSString *repoJSON = [repo modelToJSONString];
    NSLog(@"Repo: %@", repoJSON);
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark Container Object Example


@interface YYPhoto : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *desc;
@end

@implementation YYPhoto
@end

@interface YYAlbum : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *photos; // Array<YYPhoto>
@property (nonatomic, strong) NSDictionary *likedUsers; // Key:name(NSString) Value:user(YYUser)
@property (nonatomic, strong) NSSet *likedUserIds; // Set<NSNumber>
@end

@implementation YYAlbum
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"photos" : YYPhoto.class,
             @"likedUsers" : YYUser.class,
             @"likedUserIds" : NSNumber.class};
}
@end

static void ContainerObjectExample() {
    YYAlbum *album = [YYAlbum modelWithJSON:@"          \
    {                                                   \
    \"name\" : \"Happy Birthday\",                      \
    \"photos\" : [                                      \
        {                                               \
            \"url\":\"http://example.com/1.png\",       \
            \"desc\":\"Happy~\"                         \
        },                                              \
        {                                               \
            \"url\":\"http://example.com/2.png\",       \
            \"desc\":\"Yeah!\"                          \
        }                                               \
    ],                                                  \
    \"likedUsers\" : {                                  \
        \"Jony\" : {\"uid\":10001,\"name\":\"Jony\"},   \
        \"Anna\" : {\"uid\":10002,\"name\":\"Anna\"}    \
    },                                                  \
    \"likedUserIds\" : [10001,10002]                    \
    }"];
    NSString *albumJSON = [album modelToJSONString];
    NSLog(@"Album: %@", albumJSON);
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark Custom Mapper Example

@interface YYMessage : NSObject
@property (nonatomic, assign) uint64_t messageId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *time;
@end

@implementation YYMessage
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"messageId":@"i",
             @"content":@"c",
             @"time":@"t"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    uint64_t timestamp = [dic unsignedLongLongValueForKey:@"t" default:0];
    self.time = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    return YES;
}
- (void)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    dic[@"t"] = @([self.time timeIntervalSince1970] * 1000).description;
}
@end

static void CustomMapperExample() {
    YYMessage *message = [YYMessage modelWithJSON:@"{\"i\":\"2000000001\",\"c\":\"Hello\",\"t\":\"1437237598000\"}"];
    NSString *messageJSON = [message modelToJSONString];
    NSLog(@"Book: %@", messageJSON);
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark Coding/Copying/hash/equal Example

@interface YYShadow :NSObject <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIColor *color;
@end

@implementation YYShadow
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (NSUInteger)hash { return [self modelHash]; }
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
@end

static void CodingCopyingHashEqualExample() {
    YYShadow *shadow = [YYShadow new];
    shadow.name = @"Test";
    shadow.size = CGSizeMake(10, 0);
    shadow.color = [UIColor blueColor];
    
    YYShadow *shadow2 = [shadow deepCopy]; // Archive and Unachive
    BOOL equal = [shadow isEqual:shadow2];
    NSLog(@"shadow equals: %@",equal ? @"YES" : @"NO");
}




@implementation YYModelExample

- (void)runExample {
    SimpleObjectExample();
    NestObjectExample();
    ContainerObjectExample();
    CustomMapperExample();
    CodingCopyingHashEqualExample();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [UILabel new];
    label.size = CGSizeMake(kScreenWidth, 30);
    label.centerY = self.view.height / 2 - (kiOS7Later ? 0 : 32);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"See code in YYModelExample.m";
    [self.view addSubview:label];
    
    [self runExample];
}

@end
