//
//  YYKitMacro.h
//
//  Created by ibireme on 13-3-29.
//  Copyright (c) 2013 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/time.h>

#ifndef YYKitMacro_h
#define YYKitMacro_h

#ifdef __cplusplus
#define YY_EXTERN_C_BEGIN  extern "C" {
#define YY_EXTERN_C_END  }
#else
#define YY_EXTERN_C_BEGIN
#define YY_EXTERN_C_END
#endif


YY_EXTERN_C_BEGIN

/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
     SYNTH_DUMMY_CLASS(NSObject_YYAdd)
 */
#ifndef SYNTH_DUMMY_CLASS
#define SYNTH_DUMMY_CLASS(name) \
@interface SYNTH_DUMMY_CLASS_ ## name : NSObject @end \
@implementation SYNTH_DUMMY_CLASS_ ## name @end
#endif


/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
     @interface NSObject (MyAdd)
     @property (nonatomic, retain) UIColor *myColor;
     @end
     
     #import <objc/runtime.h>
     @implementation NSObject (MyAdd)
        SYNTH_DYNAMIC_PROPERTY_OBJ(myColor, setMyColor, RETAIN, UIColor *)
     @end
 */
#ifndef SYNTH_DYNAMIC_PROPERTY_OBJ
#define SYNTH_DYNAMIC_PROPERTY_OBJ(getter, setter, association, type) \
- (void)setter : (type)object { \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## association); \
} \
- (type)getter { \
    return objc_getAssociatedObject(self, @selector(setter:)); \
}
#endif


/**
 Synthsize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
     @interface NSObject (MyAdd)
     @property (nonatomic, retain) CGPoint myPoint;
     @end
     
     #import <objc/runtime.h>
     @implementation NSObject (MyAdd)
        SYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
     @end
 */
#ifndef SYNTH_DYNAMIC_PROPERTY_CTYPE
#define SYNTH_DYNAMIC_PROPERTY_CTYPE(getter, setter, type) \
- (void)setter : (type)object { \
    NSValue *value = [NSValue value:&object withObjCType:@encode(type)]; \
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
} \
- (type)getter { \
    type cValue = { 0 }; \
    NSValue *value = objc_getAssociatedObject(self, @selector(setter:)); \
    [value getValue:&cValue]; \
    return cValue; \
}
#endif


/**
 Synthesize a sharedInstace.
 *******************************************************************************
 Example:
     - (MyManager *)sharedManager {
         SYNTH_SHARED_INSTANCE();
     }
 */
#ifndef SYNTH_SHARED_INSTANCE
#define SYNTH_SHARED_INSTANCE() \
    static id sharedInstance = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        sharedInstance  = [[[self class] alloc] init]; \
    }); \
    return sharedInstance;
#endif


/**
 A macro that converts a number from degress to radians.
 */
#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(d) ((d) * M_PI / 180.0)
#endif


/**
 A macro that converts a number from radians to degrees.
 */
#ifndef RADIANS_TO_DEGREES
#define RADIANS_TO_DEGREES(r) ((d) * 180.0 / M_PI)
#endif


#ifndef kScreenWidth
extern CGSize YYDeviceScreenSize;
#define kScreenWidth YYDeviceScreenSize.width
#endif

#ifndef kScreenHeight
extern CGSize YYDeviceScreenSize;
#define kScreenHeight YYDeviceScreenSize.height
#endif

#ifndef kScreenSize
extern CGSize YYDeviceScreenSize;
#define kScreenSize YYDeviceScreenSize
#endif

#ifndef kSystemVersion
extern float YYDeviceSystemVersion;
#define kSystemVersion YYDeviceSystemVersion
#endif

#ifndef kiOS6Later
extern float YYDeviceSystemVersion;
#define kiOS6Later (YYDeviceSystemVersion >= 6)
#endif

#ifndef kiOS7Later
extern float YYDeviceSystemVersion;
#define kiOS7Later (YYDeviceSystemVersion >= 7)
#endif

#ifndef kiOS8Later
extern float YYDeviceSystemVersion;
#define kiOS8Later (YYDeviceSystemVersion >= 8)
#endif

#ifndef kIsSimulator
extern BOOL YYDeviceIsSimulator;
#define kIsSimulator YYDeviceIsSimulator
#endif

#ifndef YY_MAX
#define YY_MAX(a, b)  (((a) > (b)) ? (a) : (b))
#endif

#ifndef YY_MIN
#define YY_MIN(a, b)  (((a) < (b)) ? (a) : (b))
#endif

#ifndef YY_ABS
#define YY_ABS(a)  (((a) < 0) ? -(a) : (a))
#endif

#ifndef YY_CLAMP
#define YY_CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
#endif

#ifndef YY_SWAP
#define YY_SWAP(a, b)  do { __typeof__(a) _tmp_ = (a); (a) = (b); (b) = _tmp_; } while (0)
#endif



/**
 Profile time cost.
 
 @param ^block     code to profile
 @param ^complete  code time cost (ms)
 */
static inline void ProfileTime(void (^block)(void), void (^complete)(double ms)) {
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

/**
 same as NSMakeRange()
 */
static inline NSRange NSRangeMake(NSUInteger location, NSUInteger length) {
    NSRange r;
    r.location = location;
    r.length = length;
    return r;
}

/**
 Ceil the rect (for string drawing calculate)
 */
static inline CGRect CGRectCeil(CGRect rect) {
    return CGRectMake(ceil(rect.origin.x), ceil(rect.origin.y), ceil(rect.size.width), ceil(rect.size.height));
}

/**
 Ceil the size (for string drawing calculate)
 */
static inline CGSize CGSizeCeil(CGSize size) {
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

/**
 The Center of this rect.
 */
static inline CGPoint CGRectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

static inline uint64_t CurrentTimeMillis() {
    return (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
}

/**
 Returns a dispatch_time delay from now.
 */
static inline dispatch_time_t dispatch_time_delay(NSTimeInterval second) {
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time delay from now.
 */
static inline dispatch_time_t dispatch_walltime_delay(NSTimeInterval second) {
    return dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time from NSDate.
 */
static inline dispatch_time_t dispatch_walltime_date(NSDate *date) {
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    return milestone;
}

static inline bool dispatch_is_main_queue() {
    // pthread_main_np(void);
    return [NSThread isMainThread];
}

YY_EXTERN_C_END
#endif
