//
//  YYProcessStatus.h
//  YYKit
//
//  Created by ibireme on 14-9-29.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Utility class to get current running process info in the device.
 */
@interface YYProcessStatus : NSObject

/**
 Return all process info in this device.
 The array is sorted by pid ascending.
 
 @return Array of YYProcessStatus.
 */
+ (NSArray *)allProcessStatus;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger parentPid;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger flags;

@end
