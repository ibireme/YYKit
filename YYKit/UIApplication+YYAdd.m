//
//  UIApplication+YYAdd.m
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import "UIApplication+YYAdd.h"

#import "YYCoreMacro.h"
DUMMY_CLASS(UIApplication_YYDebug)

@implementation UIApplication (YYAdd)

- (NSURL *)dirDocumentsURL {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSURL *)dirCachesURL {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSURL *)dirLibraryURL {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}


- (BOOL)isPirated{
    
    if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"SignerIdentity"]) {
        return YES;
    }
    
    if (![self fileExistMainBundle:@"_CodeSignature"]) {
        return YES;
    }
    
    if (![self fileExistMainBundle:@"CodeResources"]) {
        return YES;
    }
    
    if (![self fileExistMainBundle:@"ResourceRules.plist"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)fileExistMainBundle:(NSString *)name{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    return [[NSFileManager defaultManager] fileExistsAtPath:([NSString stringWithFormat:@"%@/%@", bundlePath,name])];
}

@end
