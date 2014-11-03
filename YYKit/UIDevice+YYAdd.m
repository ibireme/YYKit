//
//  UIDevice+Add.m
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright (c) 2013 ibireme. All rights reserved.
//

#import "UIDevice+YYAdd.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#import "YYKitMacro.h"
#import "NSString+YYAdd.h"

SYNTH_DUMMY_CLASS(UIDevice_YYAdd)


@implementation UIDevice (YYAdd)

- (BOOL)isPad {
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

- (BOOL)isSimulator {
    static dispatch_once_t one;
    static BOOL simu;
    dispatch_once(&one, ^{
        simu = NSNotFound != [[self model] rangeOfString:@"Simulator"].location;
    });
    return simu;
}

- (BOOL)isJailbroken {
    if ([self isSimulator]) return NO; // Dont't check simulator
    
    NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package/com.saurik.cydia"];
    if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString stringWithUUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
        
    return NO;
}

- (BOOL)canMakePhoneCalls {
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}

- (NSString *)ipAddressWIFI {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

- (NSString *)ipAddressCell {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

- (NSString *)ipAddressExternal {
    NSURL *url = [NSURL URLWithString:@"http://bot.whatismyipaddress.com"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setTimeoutInterval:10];
    
    NSHTTPURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err) {
        NSLog(@"%@", err);
        return nil;
    }
    if (res.statusCode != 200) {
        return nil;
    }
    NSString *ip = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ip;
}

- (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (NSString *)machineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        if ([model isEqualToString:@"iPhone1,1"]) name = @"iPhone 1G";
        else if ([model isEqualToString:@"iPhone1,2"]) name = @"iPhone 3G";
        else if ([model isEqualToString:@"iPhone2,1"]) name = @"iPhone 3GS";
        else if ([model isEqualToString:@"iPhone3,1"]) name = @"iPhone 4 (GSM)";
        else if ([model isEqualToString:@"iPhone3,2"]) name = @"iPhone 4";
        else if ([model isEqualToString:@"iPhone3,3"]) name = @"iPhone 4 (CDMA)";
        else if ([model isEqualToString:@"iPhone4,1"]) name = @"iPhone 4S";
        else if ([model isEqualToString:@"iPhone5,1"]) name = @"iPhone 5";
        else if ([model isEqualToString:@"iPhone5,2"]) name = @"iPhone 5";
        else if ([model isEqualToString:@"iPhone5,3"]) name = @"iPhone 5c";
        else if ([model isEqualToString:@"iPhone5,4"]) name = @"iPhone 5c";
        else if ([model isEqualToString:@"iPhone6,1"]) name = @"iPhone 5s";
        else if ([model isEqualToString:@"iPhone6,2"]) name = @"iPhone 5s";
        else if ([model isEqualToString:@"iPhone7,1"]) name = @"iPhone 6 Plus";
        else if ([model isEqualToString:@"iPhone7,2"]) name = @"iPhone 6";
        
        else if ([model isEqualToString:@"iPod1,1"]) name = @"iPod 1";
        else if ([model isEqualToString:@"iPod2,1"]) name = @"iPod 2";
        else if ([model isEqualToString:@"iPod3,1"]) name = @"iPod 3";
        else if ([model isEqualToString:@"iPod4,1"]) name = @"iPod 4";
        else if ([model isEqualToString:@"iPod5,1"]) name = @"iPod 5";
        
        else if ([model isEqualToString:@"iPad1,1"]) name = @"iPad 1";
        else if ([model isEqualToString:@"iPad2,1"]) name = @"iPad 2 (WiFi)";
        else if ([model isEqualToString:@"iPad2,2"]) name = @"iPad 2 (GSM)";
        else if ([model isEqualToString:@"iPad2,3"]) name = @"iPad 2 (CDMA)";
        else if ([model isEqualToString:@"iPad2,4"]) name = @"iPad 2";
        else if ([model isEqualToString:@"iPad2,5"]) name = @"iPad mini 1";
        else if ([model isEqualToString:@"iPad2,6"]) name = @"iPad mini 1";
        else if ([model isEqualToString:@"iPad2,7"]) name = @"iPad mini 1";
        else if ([model isEqualToString:@"iPad3,1"]) name = @"iPad 3 (WiFi)";
        else if ([model isEqualToString:@"iPad3,2"]) name = @"iPad 3 (4G)";
        else if ([model isEqualToString:@"iPad3,3"]) name = @"iPad 3 (4G)";
        else if ([model isEqualToString:@"iPad3,4"]) name = @"iPad 4";
        else if ([model isEqualToString:@"iPad3,5"]) name = @"iPad 4";
        else if ([model isEqualToString:@"iPad3,6"]) name = @"iPad 4";
        else if ([model isEqualToString:@"iPad4,1"]) name = @"iPad Air";
        else if ([model isEqualToString:@"iPad4,2"]) name = @"iPad Air";
        else if ([model isEqualToString:@"iPad4,3"]) name = @"iPad Air";
        else if ([model isEqualToString:@"iPad4,4"]) name = @"iPad mini 2";
        else if ([model isEqualToString:@"iPad4,5"]) name = @"iPad mini 2";
        else if ([model isEqualToString:@"iPad4,6"]) name = @"iPad mini 2";
        else if ([model isEqualToString:@"iPad4,7"]) name = @"iPad mini 3";
        else if ([model isEqualToString:@"iPad4,8"]) name = @"iPad mini 3";
        else if ([model isEqualToString:@"iPad4,9"]) name = @"iPad mini 3";
        else if ([model isEqualToString:@"iPad5,3"]) name = @"iPad Air 2";
        else if ([model isEqualToString:@"iPad5,4"]) name = @"iPad Air 2";
        
        else if ([model isEqualToString:@"i386"]) name = @"Simulator x86";
        else if ([model isEqualToString:@"x86_64"]) name = @"Simulator x64";
        else name = model;
    });
    return name;
}

- (NSDate *)systemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}

- (int64_t)diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)diskSpaceUsed {
    int64_t total = self.diskSpace;
    int64_t free = self.diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

- (int64_t)memoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}

- (int64_t)memoryUsed {
    vm_statistics_data_t vm;
    mach_msg_type_number_t size = HOST_VM_INFO_COUNT;
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm, &size);
    if (kern != KERN_SUCCESS) return -1;
    int64_t mem = vm_page_size * (vm.active_count +
                                  vm.inactive_count +
                                  vm.wire_count);
    if (mem < 0) mem = -1;
    return mem;
}

- (int64_t)memoryFree {
    vm_statistics_data_t vm;
    mach_msg_type_number_t size = HOST_VM_INFO_COUNT;
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm, &size);
    if (kern != KERN_SUCCESS) return -1;
    int64_t mem = vm_page_size * vm.free_count;
    if (mem < 0) mem = -1;
    return mem;
}

- (int64_t)memoryActive {
    vm_statistics_data_t vm;
    mach_msg_type_number_t size = HOST_VM_INFO_COUNT;
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm, &size);
    if (kern != KERN_SUCCESS) return -1;
    int64_t mem = vm_page_size * vm.active_count;
    if (mem < 0) mem = -1;
    return mem;
}

- (int64_t)memoryInactive {
    vm_statistics_data_t vm;
    mach_msg_type_number_t size = HOST_VM_INFO_COUNT;
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm, &size);
    if (kern != KERN_SUCCESS) return -1;
    int64_t mem = vm_page_size * vm.inactive_count;
    if (mem < 0) mem = -1;
    return mem;
}

- (int64_t)memoryWired {
    vm_statistics_data_t vm;
    mach_msg_type_number_t size = HOST_VM_INFO_COUNT;
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm, &size);
    if (kern != KERN_SUCCESS) return -1;
    int64_t mem = vm_page_size * vm.wire_count;
    if (mem < 0) mem = -1;
    return mem;
}

- (int64_t)memoryPurgable {
    vm_statistics_data_t vm;
    mach_msg_type_number_t size = HOST_VM_INFO_COUNT;
    kern_return_t kern = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm, &size);
    if (kern != KERN_SUCCESS) return -1;
    int64_t mem = vm_page_size * vm.purgeable_count;
    if (mem < 0) mem = -1;
    return mem;
}

- (NSUInteger)cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

- (float)cpuUsage {
    float cpu = 0;
    NSArray *cpus = [self cpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

- (NSArray *)cpuUsagePerProcessor {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = @[].mutableCopy;
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}

@end
