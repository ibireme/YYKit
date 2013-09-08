//
//  UIApplication+YYAdd.m
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import "UIApplication+YYAdd.h"
#import "NSArray+YYAdd.h"
#import "YYKitMacro.h"

DUMMY_CLASS(UIApplication_YYDebug)



NSString *NSDocumentsFolder() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES) firstObject];
}

NSString *NSLibraryFolder() {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                        NSUserDomainMask, YES) firstObject];
}

NSString *NSBundleFolder() {
    return [[NSBundle mainBundle] bundlePath];
}

@implementation UIApplication (YYAdd)

- (NSURL *)documentsURL {
	return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}


- (NSURL *)cachesURL {
	return [[[NSFileManager defaultManager]
             URLsForDirectory:NSCachesDirectory
             inDomains:NSUserDomainMask] lastObject];
}


- (NSURL *)libraryURL {
	return [[[NSFileManager defaultManager]
             URLsForDirectory:NSLibraryDirectory
             inDomains:NSUserDomainMask] lastObject];
}


- (BOOL)isPirated{
    
    if ([[[NSBundle mainBundle] infoDictionary]
         objectForKey:@"SignerIdentity"]) {
        return YES;
    }
    
    if (![self _fileExistMainBundle:@"_CodeSignature"]) {
        return YES;
    }
    
    if (![self _fileExistMainBundle:@"CodeResources"]) {
        return YES;
    }
    
    if (![self _fileExistMainBundle:@"ResourceRules.plist"]) {
        return YES;
    }
    
    //you may test binary's modify time ...but,
    //if someone want to crack your app, this method is useless..
    //you need to change this method's name and do more check..
    return NO;
}

- (BOOL)_fileExistMainBundle:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

@end
