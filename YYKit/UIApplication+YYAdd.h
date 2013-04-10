//
//  UIApplication+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface UIApplication (YYAdd)

@property (nonatomic, readonly) NSURL *dirDocumentsURL;


@property (nonatomic, readonly) NSURL *dirCachesURL;


@property (nonatomic, readonly) NSURL *dirLibraryURL;


- (BOOL)isPirated;

@end
