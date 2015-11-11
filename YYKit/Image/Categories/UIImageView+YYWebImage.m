//
//  UIImageView+YYWebImage.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIImageView+YYWebImage.h"
#import "YYWebImageOperation.h"
#import "_YYWebImageSetter.h"
#import "YYKitMacro.h"
#import <objc/runtime.h>

YYSYNTH_DUMMY_CLASS(UIImageView_YYWebImage)

static int _YYWebImageSetterKey;
static int _YYWebImageHighlightedSetterKey;


@implementation UIImageView (YYWebImage)

#pragma mark - image

- (NSURL *)imageURL {
    _YYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    return setter.imageURL;
}

/*
 "setImageWithURL" is conflict to AFNetworking and SDWebImage...WTF!
 So.. We use "setImageURL:" instead.
 */
- (void)setImageURL:(NSURL *)imageURL {
    [self setImageWithURL:imageURL
              placeholder:nil
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    [self setImageWithURL:imageURL
              placeholder:placeholder
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)setImageWithURL:(NSURL *)imageURL options:(YYWebImageOptions)options {
    [self setImageWithURL:imageURL
              placeholder:nil
                  options:options
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)setImageWithURL:(NSURL *)imageURL
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
             completion:(YYWebImageCompletionBlock)completion {
    [self setImageWithURL:imageURL
              placeholder:placeholder
                  options:options
                  manager:nil
                 progress:nil
                transform:nil
               completion:completion];
}

- (void)setImageWithURL:(NSURL *)imageURL
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
               progress:(YYWebImageProgressBlock)progress
              transform:(YYWebImageTransformBlock)transform
             completion:(YYWebImageCompletionBlock)completion {
    [self setImageWithURL:imageURL
              placeholder:placeholder
                  options:options
                  manager:nil
                 progress:progress
                transform:transform
               completion:completion];
}

- (void)setImageWithURL:(NSURL *)imageURL
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
                manager:(YYWebImageManager *)manager
               progress:(YYWebImageProgressBlock)progress
              transform:(YYWebImageTransformBlock)transform
             completion:(YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [YYWebImageManager sharedManager];
    
    _YYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    if (!setter) {
        setter = [_YYWebImageSetter new];
        objc_setAssociatedObject(self, &_YYWebImageSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    dispatch_async_on_main_queue(^{
        if ((options & YYWebImageOptionSetImageWithFadeAnimation) &&
            !(options & YYWebImageOptionAvoidSetImage)) {
            if (!self.highlighted) {
                [self.layer removeAnimationForKey:_YYWebImageFadeAnimationKey];
            }
        }
        
        if (!imageURL) {
            if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
                self.image = placeholder;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & YYWebImageOptionUseNSURLCache) &&
            !(options & YYWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:YYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & YYWebImageOptionAvoidSetImage)) {
                self.image = imageFromMemory;
            }
            if(completion) completion(imageFromMemory, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
            self.image = placeholder;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([_YYWebImageSetter setterQueue], ^{
            YYWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == YYWebImageStageFinished || stage == YYWebImageStageProgress) && image && !(options & YYWebImageOptionAvoidSetImage);
                BOOL showFade = ((options & YYWebImageOptionSetImageWithFadeAnimation) && !self.highlighted);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (setImage && self) {
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == YYWebImageStageFinished ? _YYWebImageFadeTime : _YYWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self.layer addAnimation:transition forKey:_YYWebImageFadeAnimationKey];
                        }
                        self.image = image;
                    }
                    if (completion) completion(image, url, from, stage, error);
                });
            };
            
            [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
        });
    });
}

- (void)cancelCurrentImageRequest {
    _YYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    if (setter) [setter cancel];
}


#pragma mark - highlighted image

- (NSURL *)highlightedImageURL {
    _YYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageHighlightedSetterKey);
    return setter.imageURL;
}

- (void)setHighlightedImageURL:(NSURL *)imageURL {
    [self setHighlightedImageWithURL:imageURL
                         placeholder:nil
                             options:kNilOptions
                             manager:nil
                            progress:nil
                           transform:nil
                          completion:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    [self setHighlightedImageWithURL:imageURL
                         placeholder:placeholder
                             options:kNilOptions
                             manager:nil
                            progress:nil
                           transform:nil
                          completion:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)imageURL options:(YYWebImageOptions)options {
    [self setHighlightedImageWithURL:imageURL
                         placeholder:nil
                             options:options
                             manager:nil
                            progress:nil
                           transform:nil
                          completion:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)imageURL
                       placeholder:(UIImage *)placeholder
                           options:(YYWebImageOptions)options
                        completion:(YYWebImageCompletionBlock)completion {
    [self setHighlightedImageWithURL:imageURL
                         placeholder:placeholder
                             options:options
                             manager:nil
                            progress:nil
                           transform:nil
                          completion:completion];
}

- (void)setHighlightedImageWithURL:(NSURL *)imageURL
                       placeholder:(UIImage *)placeholder
                           options:(YYWebImageOptions)options
                          progress:(YYWebImageProgressBlock)progress
                         transform:(YYWebImageTransformBlock)transform
                        completion:(YYWebImageCompletionBlock)completion {
    [self setHighlightedImageWithURL:imageURL
                         placeholder:placeholder
                             options:options
                             manager:nil
                            progress:progress
                           transform:nil
                          completion:completion];
}

- (void)setHighlightedImageWithURL:(NSURL *)imageURL
                       placeholder:(UIImage *)placeholder
                           options:(YYWebImageOptions)options
                           manager:(YYWebImageManager *)manager
                          progress:(YYWebImageProgressBlock)progress
                         transform:(YYWebImageTransformBlock)transform
                        completion:(YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [YYWebImageManager sharedManager];
    
    _YYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageHighlightedSetterKey);
    if (!setter) {
        setter = [_YYWebImageSetter new];
        objc_setAssociatedObject(self, &_YYWebImageHighlightedSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    dispatch_async_on_main_queue(^{
        if ((options & YYWebImageOptionSetImageWithFadeAnimation) &&
            !(options & YYWebImageOptionAvoidSetImage)) {
            if (self.highlighted) {
                [self.layer removeAnimationForKey:_YYWebImageFadeAnimationKey];
            }
        }
        if (!imageURL) {
            if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
                self.highlightedImage = placeholder;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & YYWebImageOptionUseNSURLCache) &&
            !(options & YYWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:YYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & YYWebImageOptionAvoidSetImage)) {
                self.highlightedImage = imageFromMemory;
            }
            if(completion) completion(imageFromMemory, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
            self.highlightedImage = placeholder;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([_YYWebImageSetter setterQueue], ^{
            YYWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == YYWebImageStageFinished || stage == YYWebImageStageProgress) && image && !(options & YYWebImageOptionAvoidSetImage);
                BOOL showFade = ((options & YYWebImageOptionSetImageWithFadeAnimation) && self.highlighted);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (setImage && self) {
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == YYWebImageStageFinished ? _YYWebImageFadeTime : _YYWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self.layer addAnimation:transition forKey:_YYWebImageFadeAnimationKey];
                        }
                        self.highlightedImage = image;
                    }
                    if (completion) completion(image, url, from, stage, error);
                });
            };
            
            [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
        });
    });
}

- (void)cancelCurrentHighlightedImageRequest {
    _YYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageHighlightedSetterKey);
    if (setter) [setter cancel];
}

@end
