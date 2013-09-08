//
//  UIApplication+YYAdd.h
//  YYKit
//
//  Created by ibireme on 13-4-4.
//  Copyright 2013 ibireme.
//

#import <UIKit/UIKit.h>

/**
 Return "Documents" folder in this app's sandbox.
 */
NSString *NSDocumentsFolder(void);

/**
 Return "Library" folder in this app's sandbox.
 */
NSString *NSLibraryFolder(void);

/**
 Return app's bundle folder (xxx.app).
 */
NSString *NSBundleFolder(void);


/**
 Provide some some common method for `UIApplication`.
 */
@interface UIApplication (YYAdd)


/**
 Return "Documents" folder in this app's sandbox.
 */
@property (nonatomic,strong, readonly) NSURL *documentsURL;

/**
 Return "Caches" folder in this app's sandbox.
 */
@property (nonatomic,strong, readonly) NSURL *cachesURL;

/**
 Return "Library" folder in this app's sandbox.
 */
@property (nonatomic,strong, readonly) NSURL *libraryURL;


/** 
 Return if this app is priated (not from appstore).
 
 @return `YES` if the application may be pirated.
         `NO` if it is probably not pirated.
 */
- (BOOL)isPirated;

@end
