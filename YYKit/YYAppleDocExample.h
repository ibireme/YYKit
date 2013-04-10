//
//  YYAppleDocExample.h
//  YYCore
//
//  Created by ibireme on 13-4-6.
//  2013 ibireme.
//
// apple doc only use /** */


#import <UIKit/UIKit.h>

/** Normal Comment */
/*! Comment Big */

@interface YYAppleDocExample : NSObject

/// Single line comment spreading
/// over multiple lines
@property (nonatomic, assign) NSString *prop1;


/**
*Removes all targets and actions for all events from an internal dispatch table.
*/
///
- (void)removeAllTargets;
@end
