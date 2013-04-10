//
//  UIDevice+Add.m
//  YYCore
//
//  Created by ibireme on 13-4-3.
//  2013 ibireme.
//

#import "UIDevice+YYAdd.h"
#import "YYCoreMacro.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

DUMMY_CLASS(UIDevice_YYAdd)

@implementation UIDevice (YYAdd)
@dynamic macAddress;

- (BOOL) isRetina{
    static dispatch_once_t one;
	static BOOL retina;
	dispatch_once(&one, ^{
        retina = [[UIScreen mainScreen] scale] == 2;
	});
	return retina;
}

- (BOOL) isPad{
    static dispatch_once_t one;
	static BOOL pad;
	dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
	});
	return pad;
}

- (BOOL) isSimulator{
    static dispatch_once_t one;
	static BOOL simu;
	dispatch_once(&one, ^{
        simu = NSNotFound != [[self model] rangeOfString:@"Simulator"].location;
	});
	return simu;
}

// should not predicate
- (BOOL)isJailbreaked {
    NSString *cydiaPath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        return YES;
    }
    
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        return YES;
    }
    return NO;
}


//copy from rr core
// should not predicate
- (NSString *)macAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) return nil;

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) return nil;

    if ((buf = malloc(len)) == NULL) return nil;

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return nil;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    free(buf);
    return outstring;
}

@end
