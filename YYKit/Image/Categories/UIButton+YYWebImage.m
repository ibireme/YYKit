//
//  UIButton+YYWebImage.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIButton+YYWebImage.h"
#import "YYWebImageOperation.h"
#import "_YYWebImageSetter.h"
#import "YYKitMacro.h"
#import <objc/runtime.h>

YYSYNTH_DUMMY_CLASS(UIButton_YYWebImage)

static inline NSNumber *UIControlStateSingle(UIControlState state) {
    if (state & UIControlStateHighlighted) return @(UIControlStateHighlighted);
    if (state & UIControlStateDisabled) return @(UIControlStateDisabled);
    if (state & UIControlStateSelected) return @(UIControlStateSelected);
    return @(UIControlStateNormal);
}

static inline NSArray *UIControlStateMulti(UIControlState state) {
    NSMutableArray *array = [NSMutableArray new];
    if (state & UIControlStateHighlighted) [array addObject:@(UIControlStateHighlighted)];
    if (state & UIControlStateDisabled) [array addObject:@(UIControlStateDisabled)];
    if (state & UIControlStateSelected) [array addObject:@(UIControlStateSelected)];
    if ((state & 0xFF) == 0) [array addObject:@(UIControlStateNormal)];
    return array;
}

static int _YYWebImageSetterKey;
static int _YYWebImageBackgroundSetterKey;


@interface _YYWebImageSetterDicForButton : NSObject
- (_YYWebImageSetter *)setterForState:(NSNumber *)state;
- (_YYWebImageSetter *)lazySetterForState:(NSNumber *)state;
@end

@implementation _YYWebImageSetterDicForButton {
    NSMutableDictionary *_dic;
    dispatch_semaphore_t _lock;
}
- (instancetype)init {
    self = [super init];
    _lock = dispatch_semaphore_create(1);
    _dic = [NSMutableDictionary new];
    return self;
}
- (_YYWebImageSetter *)setterForState:(NSNumber *)state {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    _YYWebImageSetter *setter = _dic[state];
    dispatch_semaphore_signal(_lock);
    return setter;
    
}
- (_YYWebImageSetter *)lazySetterForState:(NSNumber *)state {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    _YYWebImageSetter *setter = _dic[state];
    if (!setter) {
        setter = [_YYWebImageSetter new];
        _dic[state] = setter;
    }
    dispatch_semaphore_signal(_lock);
    return setter;
}
@end


@implementation UIButton (YYWebImage)

#pragma mark - image

- (void)_setImageWithURL:(NSURL *)imageURL
          forSingleState:(NSNumber *)state
             placeholder:(UIImage *)placeholder
                 options:(YYWebImageOptions)options
                 manager:(YYWebImageManager *)manager
                progress:(YYWebImageProgressBlock)progress
               transform:(YYWebImageTransformBlock)transform
              completion:(YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [YYWebImageManager sharedManager];
    
    _YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    if (!dic) {
        dic = [_YYWebImageSetterDicForButton new];
        objc_setAssociatedObject(self, &_YYWebImageSetterKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _YYWebImageSetter *setter = [dic lazySetterForState:state];
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    dispatch_async_on_main_queue(^{
        if (!imageURL) {
            if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
                [self setImage:placeholder forState:state.integerValue];
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
                [self setImage:imageFromMemory forState:state.integerValue];
            }
            if(completion) completion(imageFromMemory, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
            return;
        }
        
        
        if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
            [self setImage:placeholder forState:state.integerValue];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (setImage && self) {
                        [self setImage:image forState:state.integerValue];
                    }
                    if (completion) completion(image, url, from, stage, error);
                });
            };
            
            [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
        });
    });
}

- (void)_cancelImageRequestForSingleState:(NSNumber *)state {
    _YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    _YYWebImageSetter *setter = [dic setterForState:state];
    if (setter) [setter cancel];
}

- (NSURL *)imageURLForState:(UIControlState)state {
    _YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    _YYWebImageSetter *setter = [dic setterForState:UIControlStateSingle(state)];
    return setter.imageURL;
}

- (void)setImageWithURL:(NSURL *)imageURL forState:(UIControlState)state placeholder:(UIImage *)placeholder {
    [self setImageWithURL:imageURL
                 forState:state
              placeholder:placeholder
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)setImageWithURL:(NSURL *)imageURL forState:(UIControlState)state options:(YYWebImageOptions)options {
    [self setImageWithURL:imageURL
                 forState:state
              placeholder:nil
                  options:options
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)setImageWithURL:(NSURL *)imageURL
               forState:(UIControlState)state
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
             completion:(YYWebImageCompletionBlock)completion {
    [self setImageWithURL:imageURL
                 forState:state
              placeholder:placeholder
                  options:options
                  manager:nil
                 progress:nil
                transform:nil
               completion:completion];
}

- (void)setImageWithURL:(NSURL *)imageURL
               forState:(UIControlState)state
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
               progress:(YYWebImageProgressBlock)progress
              transform:(YYWebImageTransformBlock)transform
             completion:(YYWebImageCompletionBlock)completion {
    [self setImageWithURL:imageURL
                 forState:state
              placeholder:placeholder
                  options:options
                  manager:nil
                 progress:progress
                transform:transform
               completion:completion];
}

- (void)setImageWithURL:(NSURL *)imageURL
               forState:(UIControlState)state
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
                manager:(YYWebImageManager *)manager
               progress:(YYWebImageProgressBlock)progress
              transform:(YYWebImageTransformBlock)transform
             completion:(YYWebImageCompletionBlock)completion {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _setImageWithURL:imageURL
                forSingleState:num
                   placeholder:placeholder
                       options:options
                       manager:manager
                      progress:progress
                     transform:transform
                    completion:completion];
    }
}

- (void)cancelImageRequestForState:(UIControlState)state {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _cancelImageRequestForSingleState:num];
    }
}


#pragma mark - background image

- (void)_setBackgroundImageWithURL:(NSURL *)imageURL
                    forSingleState:(NSNumber *)state
                       placeholder:(UIImage *)placeholder
                           options:(YYWebImageOptions)options
                           manager:(YYWebImageManager *)manager
                          progress:(YYWebImageProgressBlock)progress
                         transform:(YYWebImageTransformBlock)transform
                        completion:(YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [YYWebImageManager sharedManager];
    
    _YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageBackgroundSetterKey);
    if (!dic) {
        dic = [_YYWebImageSetterDicForButton new];
        objc_setAssociatedObject(self, &_YYWebImageBackgroundSetterKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _YYWebImageSetter *setter = [dic lazySetterForState:state];
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    dispatch_async_on_main_queue(^{
        if (!imageURL) {
            if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
                [self setBackgroundImage:placeholder forState:state.integerValue];
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
                [self setBackgroundImage:imageFromMemory forState:state.integerValue];
            }
            if(completion) completion(imageFromMemory, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
            return;
        }
        
        
        if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
            [self setBackgroundImage:placeholder forState:state.integerValue];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (setImage && self) {
                        [self setBackgroundImage:image forState:state.integerValue];
                    }
                    if (completion) completion(image, url, from, stage, error);
                });
            };
            
            [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
        });
    });
}

- (void)_cancelBackgroundImageRequestForSingleState:(NSNumber *)state {
    _YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageBackgroundSetterKey);
    _YYWebImageSetter *setter = [dic setterForState:state];
    if (setter) [setter cancel];
}

- (NSURL *)backgroundImageURLForState:(UIControlState)state {
    _YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageBackgroundSetterKey);
    _YYWebImageSetter *setter = [dic setterForState:UIControlStateSingle(state)];
    return setter.imageURL;
}

- (void)setBackgroundImageWithURL:(NSURL *)imageURL forState:(UIControlState)state placeholder:(UIImage *)placeholder {
    [self setBackgroundImageWithURL:imageURL
                           forState:state
                        placeholder:placeholder
                            options:kNilOptions
                            manager:nil
                           progress:nil
                          transform:nil
                         completion:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)imageURL forState:(UIControlState)state options:(YYWebImageOptions)options {
    [self setBackgroundImageWithURL:imageURL
                           forState:state
                        placeholder:nil
                            options:options
                            manager:nil
                           progress:nil
                          transform:nil
                         completion:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)imageURL
               forState:(UIControlState)state
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
             completion:(YYWebImageCompletionBlock)completion {
    [self setBackgroundImageWithURL:imageURL
                           forState:state
                        placeholder:placeholder
                            options:options
                            manager:nil
                           progress:nil
                          transform:nil
                         completion:completion];
}

- (void)setBackgroundImageWithURL:(NSURL *)imageURL
               forState:(UIControlState)state
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
               progress:(YYWebImageProgressBlock)progress
              transform:(YYWebImageTransformBlock)transform
             completion:(YYWebImageCompletionBlock)completion {
    [self setBackgroundImageWithURL:imageURL
                           forState:state
                        placeholder:placeholder
                            options:options
                            manager:nil
                           progress:progress
                          transform:transform
                         completion:completion];
}

- (void)setBackgroundImageWithURL:(NSURL *)imageURL
               forState:(UIControlState)state
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
                manager:(YYWebImageManager *)manager
               progress:(YYWebImageProgressBlock)progress
              transform:(YYWebImageTransformBlock)transform
             completion:(YYWebImageCompletionBlock)completion {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _setBackgroundImageWithURL:imageURL
                          forSingleState:num
                             placeholder:placeholder
                                 options:options
                                 manager:manager
                                progress:progress
                               transform:transform
                              completion:completion];
    }
}

- (void)cancelBackgroundImageRequestForState:(UIControlState)state {
    for (NSNumber *num in UIControlStateMulti(state)) {
        [self _cancelBackgroundImageRequestForSingleState:num];
    }
}

@end
