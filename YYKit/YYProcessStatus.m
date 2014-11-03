//
//  YYProcessStatus.m
//  YYKit
//
//  Created by ibireme on 14-9-29.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYProcessStatus.h"
#include <sys/sysctl.h>
#include <mach/mach.h>

@implementation YYProcessStatus

+ (NSArray *)allProcessStatus {
    NSMutableArray *arr = @[].mutableCopy;
    
    int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };
    u_int miblen = sizeof(mib) / sizeof(mib[0]);
    size_t size = 0;
    int st = 0;
    sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc *process = NULL;
    struct kinfo_proc *newprocess = NULL;
    
    do {
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess) { //fail alloc
            if (process) free(process);
            return nil;
        }
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0) {
        if (size % sizeof(struct kinfo_proc) == 0) {
            long nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess) {
                for (long i = nprocess - 1; i >= 0; i--) {
                    struct kinfo_proc *proc = &process[i];
                    YYProcessStatus *info = [YYProcessStatus new];
                    info.pid = proc->kp_proc.p_pid;
                    info.name = [[NSString alloc] initWithFormat:@"%s", proc->kp_proc.p_comm];
                    info.priority = proc->kp_proc.p_priority;
                    info.startTime = [NSDate dateWithTimeIntervalSince1970:proc->kp_proc.p_un.__p_starttime.tv_sec];
                    info.parentPid = [self parentPIDForProcess:(int)proc->kp_proc.p_pid];
                    info.flags = proc->kp_proc.p_flag;
                    
                    [arr addObject:info];
                }
            }
        }
    }
    
    if (process) free(process);
    
    [arr sortUsingComparator: ^NSComparisonResult (YYProcessStatus *p1, YYProcessStatus *p2) {
        if (p1.pid < p2.pid) return NSOrderedAscending;
        else if (p1.pid > p2.pid) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    return arr;
}

// Parent ID for a certain PID
+ (int)parentPIDForProcess:(int)pid {
    struct kinfo_proc info;
    size_t length = sizeof(struct kinfo_proc);
    int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, pid };
    
    if (sysctl(mib, 4, &info, &length, NULL, 0) < 0) return -1;
    if (length == 0) return -1;
    
    int PPID = info.kp_eproc.e_ppid;
    if (PPID <= 0) return -1;
    
    return PPID;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%zd %@", self.pid, self.name];
}

@end
