//
// Copyright (c) 2013 Itty Bitty Apps. All rights reserved.

#import <Foundation/Foundation.h>

extern NSString * const IBARevealLoaderRequestStartNotification;
extern NSString * const IBARevealLoaderRequestStopNotification;

extern NSString * const IBARevealLoaderSetOptionsNotification;
extern NSString * const IBARevealLoaderOptionsLogLevelMaskKey;

@interface IBARevealLoader : NSObject

+ (void)startServer;
+ (void)stopServer;

@end
