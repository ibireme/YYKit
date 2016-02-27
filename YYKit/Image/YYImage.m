//
//  YYImage.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/10/20.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYImage.h"
#import "NSString+YYAdd.h"
#import "NSBundle+YYAdd.h"

@implementation YYImage {
    YYImageDecoder *_decoder;
    NSArray *_preloadedFrames;
    dispatch_semaphore_t _preloadedLock;
    NSUInteger _bytesPerFrame;
}

+ (YYImage *)imageNamed:(NSString *)name {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return nil;
    
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;
    
    // If no extension, guess by system supported (same as UIImage).
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSArray *scales = [NSBundle preferredScales];
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = [res stringByAppendingNameScale:scale];
        for (NSString *e in exts) {
            path = [[NSBundle mainBundle] pathForResource:scaledName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    
    return [[self alloc] initWithData:data scale:scale];
}

+ (YYImage *)imageWithContentsOfFile:(NSString *)path {
    return [[self alloc] initWithContentsOfFile:path];
}

+ (YYImage *)imageWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

+ (YYImage *)imageWithData:(NSData *)data scale:(CGFloat)scale {
    return [[self alloc] initWithData:data scale:scale];
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self initWithData:data scale:path.pathScale];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithData:data scale:1];
}

- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale {
    if (data.length == 0) return nil;
    if (scale <= 0) scale = [UIScreen mainScreen].scale;
    _preloadedLock = dispatch_semaphore_create(1);
    @autoreleasepool {
        YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:scale];
        YYImageFrame *frame = [decoder frameAtIndex:0 decodeForDisplay:YES];
        UIImage *image = frame.image;
        if (!image) return nil;
        self = [self initWithCGImage:image.CGImage scale:decoder.scale orientation:image.imageOrientation];
        if (!self) return nil;
        _animatedImageType = decoder.type;
        if (decoder.frameCount > 1) {
            _decoder = decoder;
            _bytesPerFrame = CGImageGetBytesPerRow(image.CGImage) * CGImageGetHeight(image.CGImage);
            _animatedImageMemorySize = _bytesPerFrame * decoder.frameCount;
        }
        self.isDecodedForDisplay = YES;
    }
    return self;
}

- (NSData *)animatedImageData {
    return _decoder.data;
}

- (void)setPreloadAllAnimatedImageFrames:(BOOL)preloadAllAnimatedImageFrames {
    if (_preloadAllAnimatedImageFrames != preloadAllAnimatedImageFrames) {
        if (preloadAllAnimatedImageFrames && _decoder.frameCount > 0) {
            NSMutableArray *frames = [NSMutableArray new];
            for (NSUInteger i = 0, max = _decoder.frameCount; i < max; i++) {
                UIImage *img = [self animatedImageFrameAtIndex:i];
                if (img) {
                    [frames addObject:img];
                } else {
                    [frames addObject:[NSNull null]];
                }
            }
            dispatch_semaphore_wait(_preloadedLock, DISPATCH_TIME_FOREVER);
            _preloadedFrames = frames;
            dispatch_semaphore_signal(_preloadedLock);
        } else {
            dispatch_semaphore_wait(_preloadedLock, DISPATCH_TIME_FOREVER);
            _preloadedFrames = nil;
            dispatch_semaphore_signal(_preloadedLock);
        }
    }
}

#pragma mark - protocol NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *scale = [aDecoder decodeObjectForKey:@"YYImageScale"];
    NSData *data = [aDecoder decodeObjectForKey:@"YYImageData"];
    if (data.length) {
        self = [self initWithData:data scale:scale.doubleValue];
    } else {
        self = [super initWithCoder:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (_decoder.data.length) {
        [aCoder encodeObject:@(self.scale) forKey:@"YYImageScale"];
        [aCoder encodeObject:_decoder.data forKey:@"YYImageData"];
    } else {
        [super encodeWithCoder:aCoder]; // Apple use UIImagePNGRepresentation() to encode UIImage.
    }
}

#pragma mark - protocol YYAnimatedImage

- (NSUInteger)animatedImageFrameCount {
    return _decoder.frameCount;
}

- (NSUInteger)animatedImageLoopCount {
    return _decoder.loopCount;
}

- (NSUInteger)animatedImageBytesPerFrame {
    return _bytesPerFrame;
}

- (UIImage *)animatedImageFrameAtIndex:(NSUInteger)index {
    if (index >= _decoder.frameCount) return nil;
    dispatch_semaphore_wait(_preloadedLock, DISPATCH_TIME_FOREVER);
    UIImage *image = _preloadedFrames[index];
    dispatch_semaphore_signal(_preloadedLock);
    if (image) return image == (id)[NSNull null] ? nil : image;
    return [_decoder frameAtIndex:index decodeForDisplay:YES].image;
}

- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index {
    NSTimeInterval duration = [_decoder frameDurationAtIndex:index];
    
    /*
     http://opensource.apple.com/source/WebCore/WebCore-7600.1.25/platform/graphics/cg/ImageSourceCG.cpp
     Many annoying ads specify a 0 duration to make an image flash as quickly as 
     possible. We follow Safari and Firefox's behavior and use a duration of 100 ms 
     for any frames that specify a duration of <= 10 ms.
     See <rdar://problem/7689300> and <http://webkit.org/b/36082> for more information.
     
     See also: http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser.
     */
    if (duration < 0.011f) return 0.100f;
    return duration;
}

@end
