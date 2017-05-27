//
//  YYWebImageOperation.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYImageCache.h>
#import <YYKit/YYWebImageManager.h>
#else
#import "YYImageCache.h"
#import "YYWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 The YYWebImageOperation class is an NSOperation subclass used to fetch image 
 from URL request.
 
 @discussion It's an asynchronous operation. You typically execute it by adding 
 it to an operation queue, or calls 'start' to execute it manually. When the 
 operation is started, it will:
 
     1. Get the image from the cache, if exist, return it with `completion` block.
     2. Start an URL connection to fetch image from the request, invoke the `progress`
        to notify request progress (and invoke `completion` block to return the 
        progressive image if enabled by progressive option).
     3. Process the image by invoke the `transform` block.
     4. Put the image to cache and return it with `completion` block.
 
 */
@interface YYWebImageOperation : NSOperation

@property (nonatomic, strong, readonly)           NSURLRequest      *request;  ///< The image URL request.
@property (nullable, nonatomic, strong, readonly) NSURLResponse     *response; ///< The response for request.
@property (nullable, nonatomic, strong, readonly) YYImageCache      *cache;    ///< The image cache.
@property (nonatomic, strong, readonly)           NSString          *cacheKey; ///< The image cache key.
@property (nonatomic, readonly)                   YYWebImageOptions options;   ///< The operation's option.

/**
 Whether the URL connection should consult the credential storage for authenticating 
 the connection. Default is YES.
 
 @discussion This is the value that is returned in the `NSURLConnectionDelegate` 
 method `-connectionShouldUseCredentialStorage:`.
 */
@property (nonatomic) BOOL shouldUseCredentialStorage;

/**
 The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.
 
 @discussion This will be overridden by any shared credentials that exist for the 
 username or password of the request URL, if present.
 */
@property (nullable, nonatomic, strong) NSURLCredential *credential;

/**
 Creates and returns a new operation.
 
 You should call `start` to execute this operation, or you can add the operation
 to an operation queue.
 
 @param request    The Image request. This value should not be nil.
 @param options    A mask to specify options to use for this operation.
 @param cache      An image cache. Pass nil to avoid image cache.
 @param cacheKey   An image cache key. Pass nil to avoid image cache.
 @param progress   A block invoked in image fetch progress.
                     The block will be invoked in background thread. Pass nil to avoid it.
 @param transform  A block invoked before image fetch finished to do additional image process.
                     The block will be invoked in background thread. Pass nil to avoid it.
 @param completion A block invoked when image fetch finished or cancelled.
                     The block will be invoked in background thread. Pass nil to avoid it.
 
 @return The image request opeartion, or nil if an error occurs.
 */
- (instancetype)initWithRequest:(NSURLRequest *)request
                        options:(YYWebImageOptions)options
                          cache:(nullable YYImageCache *)cache
                       cacheKey:(nullable NSString *)cacheKey
                       progress:(nullable YYWebImageProgressBlock)progress
                      transform:(nullable YYWebImageTransformBlock)transform
                     completion:(nullable YYWebImageCompletionBlock)completion NS_DESIGNATED_INITIALIZER;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
