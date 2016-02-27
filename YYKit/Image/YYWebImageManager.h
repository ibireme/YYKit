//
//  YYWebImageManager.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/19.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYImageCache.h>
#else
#import "YYImageCache.h"
#endif

@class YYWebImageOperation;

NS_ASSUME_NONNULL_BEGIN

/// The options to control image operation.
typedef NS_OPTIONS(NSUInteger, YYWebImageOptions) {
    
    /// Show network activity on status bar when download image.
    YYWebImageOptionShowNetworkActivity = 1 << 0,
    
    /// Display progressive/interlaced/baseline image during download (same as web browser).
    YYWebImageOptionProgressive = 1 << 1,
    
    /// Display blurred progressive JPEG or interlaced PNG image during download.
    /// This will ignore baseline image for better user experience.
    YYWebImageOptionProgressiveBlur = 1 << 2,
    
    /// Use NSURLCache instead of YYImageCache.
    YYWebImageOptionUseNSURLCache = 1 << 3,
    
    /// Allows untrusted SSL ceriticates.
    YYWebImageOptionAllowInvalidSSLCertificates = 1 << 4,
    
    /// Allows background task to download image when app is in background.
    YYWebImageOptionAllowBackgroundTask = 1 << 5,
    
    /// Handles cookies stored in NSHTTPCookieStore.
    YYWebImageOptionHandleCookies = 1 << 6,
    
    /// Load the image from remote and refresh the image cache.
    YYWebImageOptionRefreshImageCache = 1 << 7,
    
    /// Do not load image from/to disk cache.
    YYWebImageOptionIgnoreDiskCache = 1 << 8,
    
    /// Do not change the view's image before set a new URL to it.
    YYWebImageOptionIgnorePlaceHolder = 1 << 9,
    
    /// Ignore image decoding.
    /// This may used for image downloading without display.
    YYWebImageOptionIgnoreImageDecoding = 1 << 10,
    
    /// Ignore multi-frame image decoding.
    /// This will handle the GIF/APNG/WebP/ICO image as single frame image.
    YYWebImageOptionIgnoreAnimatedImage = 1 << 11,
    
    /// Set the image to view with a fade animation.
    /// This will add a "fade" animation on image view's layer for better user experience.
    YYWebImageOptionSetImageWithFadeAnimation = 1 << 12,
    
    /// Do not set the image to the view when image fetch complete.
    /// You may set the image manually.
    YYWebImageOptionAvoidSetImage = 1 << 13,
    
    /// This flag will add the URL to a blacklist (in memory) when the URL fail to be downloaded,
    /// so the library won't keep trying.
    YYWebImageOptionIgnoreFailedURL = 1 << 14,
};

/// Indicated where the image came from.
typedef NS_ENUM(NSUInteger, YYWebImageFromType) {
    
    /// No value.
    YYWebImageFromNone = 0,
    
    /// Fetched from memory cache immediately.
    /// If you called "setImageWithURL:..." and the image is already in memory,
    /// then you will get this value at the same call.
    YYWebImageFromMemoryCacheFast,
    
    /// Fetched from memory cache.
    YYWebImageFromMemoryCache,
    
    /// Fetched from disk cache.
    YYWebImageFromDiskCache,
    
    /// Fetched from remote (web or file path).
    YYWebImageFromRemote,
};

/// Indicated image fetch complete stage.
typedef NS_ENUM(NSInteger, YYWebImageStage) {
    
    /// Incomplete, progressive image.
    YYWebImageStageProgress  = -1,
    
    /// Cancelled.
    YYWebImageStageCancelled = 0,
    
    /// Finished (succeed or failed).
    YYWebImageStageFinished  = 1,
};


/**
 The block invoked in remote image fetch progress.
 
 @param receivedSize Current received size in bytes.
 @param expectedSize Expected total size in bytes (-1 means unknown).
 */
typedef void(^YYWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

/**
 The block invoked before remote image fetch finished to do additional image process.
 
 @discussion This block will be invoked before `YYWebImageCompletionBlock` to give
 you a chance to do additional image process (such as resize or crop). If there's
 no need to transform the image, just return the `image` parameter.
 
 @example You can clip the image, blur it and add rounded corners with these code:
    ^(UIImage *image, NSURL *url) {
        // Maybe you need to create an @autoreleasepool to limit memory cost.
        image = [image imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
        image = [image imageByBlurRadius:20 tintColor:nil tintMode:kCGBlendModeNormal saturation:1.2 maskImage:nil];
        image = [image imageByRoundCornerRadius:5];
        return image;
    }
 
 @param image The image fetched from url.
 @param url   The image url (remote or local file path).
 @return The transformed image.
 */
typedef UIImage * _Nullable (^YYWebImageTransformBlock)(UIImage *image, NSURL *url);

/**
 The block invoked when image fetch finished or cancelled.
 
 @param image       The image.
 @param url         The image url (remote or local file path).
 @param from        Where the image came from.
 @param error       Error during image fetching.
 @param finished    If the operation is cancelled, this value is NO, otherwise YES.
 */
typedef void (^YYWebImageCompletionBlock)(UIImage * _Nullable image,
                                          NSURL *url,
                                          YYWebImageFromType from,
                                          YYWebImageStage stage,
                                          NSError * _Nullable error);




/**
 A manager to create and manage web image operation.
 */
@interface YYWebImageManager : NSObject

/**
 Returns global YYWebImageManager instance.
 
 @return YYWebImageManager shared instance.
 */
+ (instancetype)sharedManager;

/**
 Creates a manager with an image cache and operation queue.
 
 @param cache  Image cache used by manager (pass nil to avoid image cache).
 @param queue  The operation queue on which image operations are scheduled and run
                (pass nil to make the new operation start immediately without queue).
 @return A new manager.
 */
- (instancetype)initWithCache:(nullable YYImageCache *)cache
                        queue:(nullable NSOperationQueue *)queue NS_DESIGNATED_INITIALIZER;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 Creates and returns a new image operation, the operation will start immediately.
 
 @param url        The image url (remote or local file path).
 @param options    The options to control image operation.
 @param progress   Progress block which will be invoked on background thread (pass nil to avoid).
 @param transform  Transform block which will be invoked on background thread  (pass nil to avoid).
 @param completion Completion block which will be invoked on background thread  (pass nil to avoid).
 @return A new image operation.
 */
- (nullable YYWebImageOperation *)requestImageWithURL:(NSURL *)url
                                              options:(YYWebImageOptions)options
                                             progress:(nullable YYWebImageProgressBlock)progress
                                            transform:(nullable YYWebImageTransformBlock)transform
                                           completion:(nullable YYWebImageCompletionBlock)completion;

/**
 The image cache used by image operation. 
 You can set it to nil to avoid image cache.
 */
@property (nullable, nonatomic, strong) YYImageCache *cache;

/**
 The operation queue on which image operations are scheduled and run.
 You can set it to nil to make the new operation start immediately without queue.
 
 You can use this queue to control maximum number of concurrent operations, to obtain 
 the status of the current operations, or to cancel all operations in this manager.
 */
@property (nullable, nonatomic, strong) NSOperationQueue *queue;

/**
 The shared transform block to process image. Default is nil.
 
 When called `requestImageWithURL:options:progress:transform:completion` and
 the `transform` is nil, this block will be used.
 */
@property (nullable, nonatomic, copy) YYWebImageTransformBlock sharedTransformBlock;

/**
 The image request timeout interval in seconds. Default is 15.
 */
@property (nonatomic) NSTimeInterval timeout;

/**
 The username used by NSURLCredential, default is nil.
 */
@property (nullable, nonatomic, copy) NSString *username;

/**
 The password used by NSURLCredential, default is nil.
 */
@property (nullable, nonatomic, copy) NSString *password;

/**
 The image HTTP request header. Default is "Accept:image/webp,image/\*;q=0.8".
 */
@property (nullable, nonatomic, copy) NSDictionary<NSString *, NSString *> *headers;

/**
 A block which will be invoked for each image HTTP request to do additional
 HTTP header process. Default is nil.
 
 Use this block to add or remove HTTP header field for a specified URL.
 */
@property (nullable, nonatomic, copy) NSDictionary<NSString *, NSString *> *(^headersFilter)(NSURL *url, NSDictionary<NSString *, NSString *> * _Nullable header);

/**
 A block which will be invoked for each image operation. Default is nil.
 
 Use this block to provide a custom image cache key for a specified URL.
 */
@property (nullable, nonatomic, copy) NSString *(^cacheKeyFilter)(NSURL *url);

/**
 Returns the HTTP headers for a specified URL.
 
 @param url A specified URL.
 @return HTTP headers.
 */
- (nullable NSDictionary<NSString *, NSString *> *)headersForURL:(NSURL *)url;

/**
 Returns the cache key for a specified URL.
 
 @param url A specified URL
 @return Cache key used in YYImageCache.
 */
- (NSString *)cacheKeyForURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
