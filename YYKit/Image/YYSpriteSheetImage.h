//
//  YYSpriteImage.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/4/21.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYAnimatedImageView.h>
#else
#import "YYAnimatedImageView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 An image to display sprite sheet animation.
 
 @discussion It is a fully compatible `UIImage` subclass.
 The animation can be played by YYAnimatedImageView.
 
 Sample Code:
  
    // 8 * 12 sprites in a single sheet image
    UIImage *spriteSheet = [UIImage imageNamed:@"sprite-sheet"];
    NSMutableArray *contentRects = [NSMutableArray new];
    NSMutableArray *durations = [NSMutableArray new];
    for (int j = 0; j < 12; j++) {
        for (int i = 0; i < 8; i++) {
            CGRect rect;
            rect.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
            rect.origin.x = img.size.width / 8 * i;
            rect.origin.y = img.size.height / 12 * j;
            [contentRects addObject:[NSValue valueWithCGRect:rect]];
            [durations addObject:@(1 / 60.0)];
        }
    }
    YYSpriteSheetImage *sprite;
    sprite = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:img
                                                     contentRects:contentRects
                                                   frameDurations:durations
                                                        loopCount:0];
    YYAnimatedImageView *imgView = [YYAnimatedImageView new];
    imgView.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
    imgView.image = sprite;
 
 
 
 @discussion It can also be used to display single frame in sprite sheet image.
 Sample Code:
 
    YYSpriteSheetImage *sheet = ...;
    UIImageView *imageView = ...;
    imageView.image = sheet;
    imageView.layer.contentsRect = [sheet contentsRectForCALayerAtIndex:6];
 
 */
@interface YYSpriteSheetImage : UIImage <YYAnimatedImage>

/**
 Creates and returns an image object.
 
 @param image          The sprite sheet image (contains all frames).
 
 @param contentRects   The sprite sheet image frame rects in the image coordinates.
     The rectangle should not outside the image's bounds. The objects in this array
     should be created with [NSValue valueWithCGRect:].
 
 @param frameDurations The sprite sheet image frame's durations in seconds. 
     The objects in this array should be NSNumber.
 
 @param loopCount      Animation loop count, 0 means infinite looping.
 
 @return An image object, or nil if an error occurs.
 */
- (nullable instancetype)initWithSpriteSheetImage:(UIImage *)image
                                     contentRects:(NSArray<NSValue *> *)contentRects
                                   frameDurations:(NSArray<NSNumber *> *)frameDurations
                                        loopCount:(NSUInteger)loopCount;

@property (nonatomic, readonly) NSArray<NSValue *> *contentRects;
@property (nonatomic, readonly) NSArray<NSValue *> *frameDurations;
@property (nonatomic, readonly) NSUInteger loopCount;

/**
 Get the contents rect for CALayer.
 See "contentsRect" property in CALayer for more information.
 
 @param index Index of frame.
 @return Contents Rect.
 */
- (CGRect)contentsRectForCALayerAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
