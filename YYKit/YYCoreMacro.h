//
//  YYDebugCommon.h
//
//  Created by ibireme on 13-3-29.
//  2013 ibireme.
//
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#ifndef YYCore_YYMacro_h
#define YYCore_YYMacro_h


#define LOG_CLASS_MSG NSLog(@"[+%@ %@]",NSStringFromClass(self.class),NSStringFromSelector(_cmd))
#define LOG_INST_MSG NSLog(@"[-%@ %@]",NSStringFromClass(self.class),NSStringFromSelector(_cmd))


#ifndef DUMMY_CLASS
#define DUMMY_CLASS(name) \
    @interface DUMMY_CLASS_ ## name : NSObject @end \
    @implementation DUMMY_CLASS_ ## name @end
#endif


#define YYMAX(a, b)     ((a) > (b) ? (a) : (b))
#define YYMIN(a, b)     ((a) < (b) ? (a) : (b))
#define YYMAX3(a, b, c) ((a) > (b) ? ((a) > (c) ? (a) : (c)) : ((b) > (c) ? (b) : (c)))
#define YYMIN3(a, b, c) ((a) < (b) ? ((a) < (c) ? (a) : (c)) : ((b) < (c) ? (b) : (c)))



#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(d) ((d) * M_PI / 180)
#endif

#ifndef RADIANS_TO_DEGREES
#define RADIANS_TO_DEGREES(r) ((d) * 180 / M_PI)
#endif


static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

static inline CGFloat ScreenWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}

static inline CGFloat ScreenHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}

static inline long long CurrentTimeMillis(){
    return [NSDate timeIntervalSinceReferenceDate] * 1000LL;
}

static inline long long CurrentTimeNanos(){
    return [NSDate timeIntervalSinceReferenceDate] * 1000000LL;
}


static inline dispatch_time_t dispatch_time_delay(double second){
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

static inline dispatch_time_t dispatch_walltime_delay(double second){
    return dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}


static inline int sel_getArgCount(SEL sel) {
    const char *s = sel_getName(sel);
    int count = 0;
    while (*s != '\0') {
        if (*s == ':') count++;
        s++;
    }
    return count;
}



#endif //YYCore_YYMacro_h
