//
//  UIDevice+Add.h
//  YYCore
//
//  Created by ibireme on 13-4-3.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface UIDevice (YYAdd)

- (BOOL) isRetina;

- (BOOL) isPad; //include iPad mini

- (BOOL) isSimulator;

- (BOOL) isJailbreaked;

@property (nonatomic, readonly) NSString *macAddress;

@end
