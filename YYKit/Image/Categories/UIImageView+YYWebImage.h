//
//  UIImageView+YYWebImage.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYWebImageManager.h>
#else
#import "YYWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Web image methods for UIImageView.
 */
@interface UIImageView (YYWebImage)

#pragma mark - image

/**
 Current image URL.
 
 @discussion Set a new value to this property will cancel the previous request 
 operation and create a new request operation to fetch image. Set nil to clear 
 the image and image URL.
 */
@property (nullable, nonatomic, strong) NSURL *imageURL;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL The image url (remote or local file path).
 @param options  The options to use when request the image.
 */
- (void)setImageWithURL:(nullable NSURL *)imageURL options:(YYWebImageOptions)options;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder he image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param manager     The manager to create image request operation.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
 Cancel the current image request.
 */
- (void)cancelCurrentImageRequest;



#pragma mark - highlight image

/**
 Current highlighted image URL.
 
 @discussion Set a new value to this property will cancel the previous request
 operation and create a new request operation to fetch image. Set nil to clear
 the highlighted image and image URL.
 */
@property (nullable, nonatomic, strong) NSURL *highlightedImageURL;

/**
 Set the view's `highlightedImage` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

/**
 Set the view's `highlightedImage` with a specified URL.
 
 @param imageURL The image url (remote or local file path).
 @param options  The options to use when request the image.
 */
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL options:(YYWebImageOptions)options;

/**
 Set the view's `highlightedImage` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                           completion:(nullable YYWebImageCompletionBlock)completion;

/**
 Set the view's `highlightedImage` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                             progress:(nullable YYWebImageProgressBlock)progress
                            transform:(nullable YYWebImageTransformBlock)transform
                           completion:(nullable YYWebImageCompletionBlock)completion;

/**
 Set the view's `highlightedImage` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder he image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param manager     The manager to create image request operation.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                              manager:(nullable YYWebImageManager *)manager
                             progress:(nullable YYWebImageProgressBlock)progress
                            transform:(nullable YYWebImageTransformBlock)transform
                           completion:(nullable YYWebImageCompletionBlock)completion;

/**
 Cancel the current highlighed image request.
 */
- (void)cancelCurrentHighlightedImageRequest;

@end

NS_ASSUME_NONNULL_END
