//
//  YYReachability.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/6.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYReachabilityStatus) {
    YYReachabilityStatusNone  = 0, ///< Not Reachable
    YYReachabilityStatusWWAN  = 1, ///< Reachable via WWAN (2G/3G/4G)
    YYReachabilityStatusWiFi  = 2, ///< Reachable via WiFi
};

typedef NS_ENUM(NSUInteger, YYReachabilityWWANStatus) {
    YYReachabilityWWANStatusNone  = 0, ///< Not Reachable vis WWAN
    YYReachabilityWWANStatus2G = 2, ///< Reachable via 2G (GPRS/EDGE)       10~100Kbps
    YYReachabilityWWANStatus3G = 3, ///< Reachable via 3G (WCDMA/HSDPA/...) 1~10Mbps
    YYReachabilityWWANStatus4G = 4, ///< Reachable via 4G (eHRPD/LTE)       100Mbps
};


/**
 `YYReachability` can used to monitor the network status of an iOS device.
 */
@interface YYReachability : NSObject

@property (nonatomic, readonly) SCNetworkReachabilityFlags flags;                           ///< Current flags.
@property (nonatomic, readonly) YYReachabilityStatus status;                                ///< Current status.
@property (nonatomic, readonly) YYReachabilityWWANStatus wwanStatus NS_AVAILABLE_IOS(7_0);  ///< Current WWAN status.
@property (nonatomic, readonly, getter=isReachable) BOOL reachable;

/// Notify block which will be called on main thread when network changed.
@property (nullable, nonatomic, copy) void (^notifyBlock)(YYReachability *reachability);

+ (instancetype)reachability;
+ (instancetype)reachabilityForLocalWifi;
+ (nullable instancetype)reachabilityWithHostname:(NSString *)hostname;
+ (nullable instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

@end

NS_ASSUME_NONNULL_END
