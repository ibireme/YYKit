//
//  NSObject+Add.m
//  YYCore
//
//  Created by ibireme on 13-4-3.
//  2013 ibireme.
//

#import "NSObject+YYAdd.h"
#import "YYCoreMacro.h"

DUMMY_CLASS(NSObject_YYAdd)

#if __has_feature(objc_arc)
#warning add -fno-objc-arc for compiler flags
#endif










@interface NSString (DLIntrospection)

+ (NSString *)decodeType:(const char *)cString;

@end

@implementation NSString (DLIntrospection)

//https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
+ (NSString *)decodeType:(const char *)cString {
    if (!strcmp(cString, @encode(id))) return @"id";
    if (!strcmp(cString, @encode(void))) return @"void";
    if (!strcmp(cString, @encode(float))) return @"float";
    if (!strcmp(cString, @encode(int))) return @"int";
    if (!strcmp(cString, @encode(BOOL))) return @"BOOL";
    if (!strcmp(cString, @encode(char *))) return @"char *";
    if (!strcmp(cString, @encode(double))) return @"double";
    if (!strcmp(cString, @encode(Class))) return @"class";
    if (!strcmp(cString, @encode(SEL))) return @"SEL";
    if (!strcmp(cString, @encode(unsigned int))) return @"unsigned int";
    
    //@TODO: do handle bitmasks
    NSString *result = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    if ([[result substringToIndex:1] isEqualToString:@"@"] && [result rangeOfString:@"?"].location == NSNotFound) {
        result = [[result substringWithRange:NSMakeRange(2, result.length - 3)] stringByAppendingString:@"*"];
    } else
        if ([[result substringToIndex:1] isEqualToString:@"^"]) {
            result = [NSString stringWithFormat:@"%@ *",
                      [NSString decodeType:[[result substringFromIndex:1] cStringUsingEncoding:NSUTF8StringEncoding]]];
        }
    return result;
}

@end



/**
 * notice this file is no-Arc
 */
@implementation NSObject (YYAdd)

//"project build" add Other Warning Flags: "-Wno-arc-performSelector-leaks"
// #pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (id)performSelector:(SEL)aSelector withObjects:(id)firstObj, ...{
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (!sig) {
        NSString *eReason = [NSString stringWithFormat:
                             @"-[%@ %@]:YYCore unrecognized selector sent to instance %p",
                             NSStringFromClass(self.class),
                             NSStringFromSelector(aSelector),
                             self];
        @throw([NSException exceptionWithName:NSInvalidArgumentException reason:eReason userInfo:nil]);
    }

    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:aSelector];
    [inv setArgument:&firstObj atIndex:2];

    int arg_count = sel_getArgCount(aSelector);
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

- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay withObjects:(id)firstObj, ...{
    NSInvocation *inv = nil;
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (sig) {
        inv = [NSInvocation invocationWithMethodSignature:sig];
        [inv setTarget:self];
        [inv setSelector:aSelector];
        [inv setArgument:&firstObj atIndex:2];

        int arg_count = sel_getArgCount(aSelector);
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
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_current_queue(), ^{
        if (inv == nil) {
            NSString *eReason = [NSString stringWithFormat:
                                 @"-[%@ %@]:YYCore unrecognized selector sent to instance %p",
                                 NSStringFromClass(tmpSelf.class),
                                 NSStringFromSelector(aSelector),
                                 tmpSelf];
            @throw([NSException exceptionWithName:NSInvalidArgumentException reason:eReason userInfo:nil]);
        }
        [inv invoke];
    });
}


+ (NSArray *)classMethods {
    return [self methodsForClass:object_getClass([self class]) typeFormat:@"+"];
}

+ (NSArray *)instanceMethods {
    return [self methodsForClass:[self class] typeFormat:@"-"];
}


#pragma mark - Private

+ (NSArray *)methodsForClass:(Class)class typeFormat:(NSString *)type {
    unsigned int outCount;
    Method *methods = class_copyMethodList(class, &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        NSString *methodDescription = [NSString stringWithFormat:@"%@ (%@)%@",
                                       type,
                                       [NSString decodeType:method_copyReturnType(methods[i])],
                                       NSStringFromSelector(method_getName(methods[i]))];
        
        NSInteger args = method_getNumberOfArguments(methods[i]);
        NSMutableArray *selParts = [[methodDescription componentsSeparatedByString:@":"] mutableCopy];
        NSInteger offset = 2; //1-st arg is object (@), 2-nd is SEL (:)
        
        for (int idx = offset; idx < args; idx++) {
            NSString *returnType = [NSString decodeType:method_copyArgumentType(methods[i], idx)];
            selParts[idx - offset] = [NSString stringWithFormat:@"%@:(%@)arg%d",
                                      selParts[idx - offset],
                                      returnType,
                                      idx - 2];
        }
        [result addObject:[selParts componentsJoinedByString:@" "]];
        [selParts release];
    }
    free(methods);
    return result.count ? [[result copy] autorelease]: nil;
}


+ (NSArray *)properties {
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        [result addObject:[self formattedPropery:properties[i]]];
    }
    free(properties);
    return result.count ? [[result copy] autorelease]: nil;
}

+ (NSArray *)instanceVariables {
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        NSString *type = [NSString decodeType:ivar_getTypeEncoding(ivars[i])];
        NSString *name = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSUTF8StringEncoding];
        NSString *ivarDescription = [NSString stringWithFormat:@"%@ %@", type, name];
        [result addObject:ivarDescription];
    }
    free(ivars);
    return result.count ? [[result copy] autorelease] : nil;
}

//private
+ (NSString *)formattedPropery:(objc_property_t)prop {
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(prop, &attrCount);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    for (int idx = 0; idx < attrCount; idx++) {
        NSString *name = [NSString stringWithCString:attrs[idx].name encoding:NSUTF8StringEncoding];
        NSString *value = [NSString stringWithCString:attrs[idx].value encoding:NSUTF8StringEncoding];
        [attributes setObject:value forKey:name];
    }
    free(attrs);
    NSMutableString *property = [NSMutableString stringWithFormat:@"@property "];
    NSMutableArray *attrsArray = [NSMutableArray array];
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5
    [attrsArray addObject:[attributes objectForKey:@"N"] ? @"nonatomic" : @"atomic"];
    
    if ([attributes objectForKey:@"&"]) {
        [attrsArray addObject:@"strong"];
    } else if ([attributes objectForKey:@"C"]) {
        [attrsArray addObject:@"copy"];
    } else if ([attributes objectForKey:@"W"]) {
        [attrsArray addObject:@"weak"];
    } else {
        [attrsArray addObject:@"assign"];
    }
    if ([attributes objectForKey:@"R"]) {[attrsArray addObject:@"readonly"];}
    if ([attributes objectForKey:@"G"]) {
        [attrsArray addObject:[NSString stringWithFormat:@"getter=%@", [attributes objectForKey:@"G"]]];
    }
    if ([attributes objectForKey:@"S"]) {
        [attrsArray addObject:[NSString stringWithFormat:@"setter=%@", [attributes objectForKey:@"G"]]];
    }
    
    [property appendFormat:@"(%@) %@ %@",
     [attrsArray componentsJoinedByString:@", "],
     [NSString decodeType:[[attributes objectForKey:@"T"] cStringUsingEncoding:NSUTF8StringEncoding]],
     [NSString stringWithCString:property_getName(prop) encoding:NSUTF8StringEncoding]];
    return [[property copy] autorelease];
}




void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}



+ (BOOL)swizzleMethod:(SEL)originalSel withMethod:(SEL)newSel
{
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) {
        return NO;
    }
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)newSel {
    Class c = object_getClass((id)self);
    return [c swizzleMethod:origSel withMethod:newSel];
}



@end
