//
//  YYKitMacro.h
//
//  Created by ibireme on 13-3-29.
//  Copyright 2013 ibireme.
//
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#ifndef YYKitMacro_h
#define YYKitMacro_h


// Use dummy class for category in static library.
#ifndef DUMMY_CLASS
#define DUMMY_CLASS(name) \
    @interface DUMMY_CLASS_ ## name : NSObject @end \
    @implementation DUMMY_CLASS_ ## name @end
#endif


/// Use DLog to print log while in debug model.
#ifndef DLog
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
#endif



/// A macro that converts a number from degress to radians.
#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(d) ((d) * M_PI / 180.0f)
#endif


/// A macro that converts a number from radians to degrees.
#ifndef RADIANS_TO_DEGREES
#define RADIANS_TO_DEGREES(r) ((d) * 180.0f / M_PI)
#endif


#ifndef NSRangeMake
///same as NSMakeRange()
static inline NSRange NSRangeMake(NSUInteger location, NSUInteger length) {
    NSRange r;
    r.location = location;
    r.length = length;
    return r;
}
#endif

#ifndef DegreesToRadians
static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}
#endif

#ifndef RadiansToDegrees
static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}
#endif

#ifndef ScreenWidth
static inline CGFloat ScreenWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}
#endif

#ifndef ScreenHeight
static inline CGFloat ScreenHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}
#endif

#ifndef CurrentTimeMillis
static inline uint64_t CurrentTimeMillis(){
    return (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
}
#endif


#ifndef dispatch_time_delay
/// get a dispatch_time delay from now
static inline dispatch_time_t dispatch_time_delay(NSTimeInterval second){
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}
#endif

/// get a dispatch_wall_time delay from now
#ifndef dispatch_walltime_delay
static inline dispatch_time_t dispatch_walltime_delay(NSTimeInterval second){
    return dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}
#endif

///get selector's arg count
static inline int sel_getArgCount(SEL sel) {
    const char *s = sel_getName(sel);
    int count = 0;
    while (*s != '\0') {
        if (*s == ':') count++;
        s++;
    }
    return count;
}



#endif // YYKitMacro_h
