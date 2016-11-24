//
//  Copyright (c) 2014 Itty Bitty Apps Pty Ltd. All rights reserved.

#ifndef reveal_core_IBANetServiceTypes_h
#define reveal_core_IBANetServiceTypes_h
#import <dns_sd.h>

typedef NS_ENUM(uint32_t, IBANetServiceInterface) {
    IBANetServiceInterfaceAny = kDNSServiceInterfaceIndexAny,
    IBANetServiceInterfaceLocalOnly = kDNSServiceInterfaceIndexLocalOnly,
    IBANetServiceInterfaceUnicast = kDNSServiceInterfaceIndexUnicast,
    IBANetServiceInterfaceP2P = kDNSServiceInterfaceIndexP2P
};

#endif
