//
//  YYWebImage.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYWebImage/YYWebImage.h>)
FOUNDATION_EXPORT double YYWebImageVersionNumber;
FOUNDATION_EXPORT const unsigned char YYWebImageVersionString[];
#import <YYWebImage/YYImageCache.h>
#import <YYWebImage/YYWebImageOperation.h>
#import <YYWebImage/YYWebImageManager.h>
#import <YYWebImage/UIImage+YYWebImage.h>
#import <YYWebImage/UIImageView+YYWebImage.h>
#import <YYWebImage/UIButton+YYWebImage.h>
#import <YYWebImage/CALayer+YYWebImage.h>
#import <YYWebImage/MKAnnotationView+YYWebImage.h>
#else
#import "YYImageCache.h"
#import "YYWebImageOperation.h"
#import "YYWebImageManager.h"
#import "UIImage+YYWebImage.h"
#import "UIImageView+YYWebImage.h"
#import "UIButton+YYWebImage.h"
#import "CALayer+YYWebImage.h"
#import "MKAnnotationView+YYWebImage.h"
#endif

#if __has_include(<YYImage/YYImage.h>)
#import <YYImage/YYImage.h>
#elif __has_include(<YYWebImage/YYImage.h>)
#import <YYWebImage/YYImage.h>
#import <YYWebImage/YYFrameImage.h>
#import <YYWebImage/YYSpriteSheetImage.h>
#import <YYWebImage/YYImageCoder.h>
#import <YYWebImage/YYAnimatedImageView.h>
#else
#import "YYImage.h"
#import "YYFrameImage.h"
#import "YYSpriteSheetImage.h"
#import "YYImageCoder.h"
#import "YYAnimatedImageView.h"
#endif

#if __has_include(<YYCache/YYCache.h>)
#import <YYCache/YYCache.h>
#elif __has_include(<YYWebImage/YYCache.h>)
#import <YYWebImage/YYCache.h>
#import <YYWebImage/YYMemoryCache.h>
#import <YYWebImage/YYDiskCache.h>
#import <YYWebImage/YYKVStorage.h>
#else
#import "YYCache.h"
#import "YYMemoryCache.h"
#import "YYDiskCache.h"
#import "YYKVStorage.h"
#endif

