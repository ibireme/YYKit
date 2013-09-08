//
//  NSObject+Add.m
//  YYKit
//
//  Created by ibireme on 13-4-3.
//  Copyright 2013 ibireme.
//

#import "NSObject+YYAdd.h"
#import "YYKitMacro.h"

DUMMY_CLASS(NSObject_YYAdd)

/**
 Notice this file is none-ARC
 */
#if __has_feature(objc_arc)
#error add -fno-objc-arc to compiler flags
#endif



@implementation NSObject (YYAdd)

//"project build" add Other Warning Flags: "-Wno-arc-performSelector-leaks"
// #pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (id)performSelector:(SEL)aSelector withObjects:(id)firstObj, ...{
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (!sig) {
        NSString *reason =
            [NSString stringWithFormat:
             @"-[%@ %@]:YYKit unrecognized selector sent to instance %p",
             NSStringFromClass(self.class),
             NSStringFromSelector(aSelector),
             self];
        
        @throw([NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil]);
    }

    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:aSelector];
    [inv setArgument:&firstObj atIndex:2];
    
    //int arg_count = sel_getArgCount(aSelector);
    int arg_count = [sig numberOfArguments] - 2;
    va_list arg_ptr;
    va_start(arg_ptr, firstObj);
    for (int i = 0; i < arg_count - 1; i++) {
        id obj = va_arg(arg_ptr, id);
        [inv setArgument:&obj atIndex:i + 3];
    }
    va_end(arg_ptr);

    [inv invoke];
    id retVal = nil;
    if (sig.methodReturnLength) {
        [inv getReturnValue:&retVal];
    }
    return [[retVal retain] autorelease];
}


- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay {
    [self performSelector:aSelector withObject:nil afterDelay:delay];
}


- (void)performSelector:(SEL)aSelector
             afterDelay:(NSTimeInterval)delay
            withObjects:(id)firstObj, ...{
    
    NSInvocation *inv = nil;
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (sig) {
        inv = [NSInvocation invocationWithMethodSignature:sig];
        [inv setTarget:self];
        [inv setSelector:aSelector];
        [inv setArgument:&firstObj atIndex:2];

        //int arg_count = sel_getArgCount(aSelector);
        int arg_count = [sig numberOfArguments] - 2;
        va_list arg_ptr;
        va_start(arg_ptr, firstObj);
        for (int i = 0; i < arg_count - 1; i++) {
            id obj = va_arg(arg_ptr, id);
            [inv setArgument:&obj atIndex:i + 3];
        }
        va_end(arg_ptr);
    }

    [inv retainArguments];
    NSObject *tmpSelf = self;
    dispatch_time_t popTime =
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_current_queue(), ^{
        if (inv == nil) {
            NSString *reason =
                [NSString stringWithFormat:
                 @"-[%@ %@]:YYKit unrecognized selector sent to instance %p",
                 NSStringFromClass(tmpSelf.class),
                 NSStringFromSelector(aSelector),
                 tmpSelf];
            
            @throw([NSException exceptionWithName:NSInvalidArgumentException
                                           reason:reason
                                         userInfo:nil]);
        }
        [inv invoke];
    });
}





+ (BOOL)swizzleMethod:(SEL)originalSel withMethod:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;

    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));

    method_exchangeImplementations(
        class_getInstanceMethod(self, originalSel),
        class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSel withClassMethod:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}




- (void)associateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)associateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)associatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)associatedValueRemove:(id)value{
    objc_removeAssociatedObjects(value);
}





+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}


@end
