//
//  UIDevice+Add.h
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright 2013 ibireme.
//

#import <UIKit/UIKit.h>


/**
 Provide some some common method for `UIDevice`.
 */
@interface UIDevice (YYAdd)

/**
 Returns if the device has retina display.
 */
- (BOOL) isRetina;

/**
 Returns if the device is iPad/iPad Mini.
 */
- (BOOL) isPad;


/**
 Returns `YES` if the device is a simulator.
 */
- (BOOL) isSimulator;

/**
 Returns `YES` when this device is jailbroken.
 */
- (BOOL) isJailbreake;


- (BOOL)isOS4;
- (BOOL)isOS5;
- (BOOL)isOS6;
- (BOOL)isOS7;


/**
 Return the MAC address of this device.
 e.g. AA:BB:CC:DD:EE:FF
 */
@property (nonatomic,strong, readonly) NSString *macAddress;

/**
 Return the current IP address of this device.
 e.g. 192.168.1.1
 */
@property (nonatomic,strong, readonly) NSString *ipAddress;

/**
 Return avaliable device memory in Byte.
 Return -1 when error occured.
 */
@property (nonatomic, readonly) int64_t availableMemory;


@end
