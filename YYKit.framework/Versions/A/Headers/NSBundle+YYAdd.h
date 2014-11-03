//
//  NSBundle+YYAdd.h
//  YYKit
//
//  Created by ibireme on 14-10-20.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides extensions for `NSBundle`.
 */
@interface NSBundle (YYAdd)

/**
 Returns the full pathname for the resource file identified by the specified 
 name and extension and residing in a given bundle directory. It first search
 the file with current screen's scale (such as @2x), then search from higher
 scale to lower scale.
 
 @param name       The name of a resource file contained in the directory 
 specified by bundlePath.
 
 @param ext        If extension is an empty string or nil, the extension is 
 assumed not to exist and the file is the first file encountered that exactly matches name.

 @param bundlePath The path of a top-level bundle directory. This must be a 
 valid path. For example, to specify the bundle directory for a Mac app, you 
 might specify the path /Applications/MyApp.app.
 
 @return The full pathname for the resource file or nil if the file could not be
 located. This method also returns nil if the bundle specified by the bundlePath 
 parameter does not exist or is not a readable directory.
 */
+ (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)bundlePath;

/**
 Returns the full pathname for the resource identified by the specified name and 
 file extension. It first search the file with current screen's scale (such as @2x),
 then search from higher scale to lower scale.
 
 @param name       The name of the resource file. If name is an empty string or 
 nil, returns the first file encountered of the supplied type.
 
 @param ext        If extension is an empty string or nil, the extension is 
 assumed not to exist and the file is the first file encountered that exactly matches name.

 
 @return The full pathname for the resource file or nil if the file could not be located.
 */
- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext;

/**
 Returns the full pathname for the resource identified by the specified name and 
 file extension and located in the specified bundle subdirectory. It first search 
 the file with current screen's scale (such as @2x), then search from higher 
 scale to lower scale.
 
 @param name       The name of the resource file.
 
 @param ext        If extension is an empty string or nil, all the files in 
 subpath and its subdirectories are returned. If an extension is provided the 
 subdirectories are not searched.
 
 @param subpath   The name of the bundle subdirectory. Can be nil.
 
 @return An array of full pathnames for the subpath or nil if no files are located.
 */
- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

@end
