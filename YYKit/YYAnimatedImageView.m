//
//  YYAnimatedImageView.m
//  YYKit
//
//  Created by ibireme on 14/10/19.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYAnimatedImageView.h"
#import "YYWeakProxy.h"
#import "UIDevice+YYAdd.h"
#import "UIImage+YYAdd.h"
#import "YYKitMacro.h"
#import <libkern/OSAtomic.h>

#define BUFFER_SIZE (20 * 1024 * 1024) // 20MB (minimum memory buffer size)

#define LOCK(...) OSSpinLockLock(&_lock); \
__VA_ARGS__; \
OSSpinLockUnlock(&_lock);


@implementation YYAnimatedImageView {
    BOOL _hasAnimated;
    BOOL _hasHighlightAnimated;
    UIImage <YYAnimatedImage> *_curAnimatedImage;
    
    dispatch_once_t _onceToken;
    OSSpinLock _lock; ///< lock for _buffer
    NSOperationQueue *_requestQueue; ///< image request queue, serial
    
    CADisplayLink *_link; ///< ticker for change frame
    NSTimeInterval _time; ///< time after last frame
    
    UIImage *_curFrame; ///< current frame to display
    NSUInteger _curIndex; ///< current frame index (from 0)
    NSUInteger _totalIndex; ///< total frame count
    
    BOOL _loopEnd; ///< weather the loop is end.
    NSUInteger _curLoop; ///< current loop count (from 0)
    NSUInteger _totalLoop; ///< total loop count, 0 means infinity
    
    NSMutableDictionary *_buffer; ///< frame buffer
    BOOL _bufferMiss; ///< whether miss frame on last opportunity
    NSUInteger _maxBufferCount; ///< maxmium buffer count
    NSInteger _incrBufferCount; ///< current buffer count (will increase by step)
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    self.frame = (CGRect) {CGPointZero, image.size };
    self.image = image;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super init];
    CGSize size = image ? image.size : highlightedImage.size;
    self.frame = (CGRect) {CGPointZero, size };
    self.image = image;
    self.highlightedImage = highlightedImage;
    return self;
}

// init the animated params.
- (void)resetAnimated {
    dispatch_once(&_onceToken, ^{
        _lock = OS_SPINLOCK_INIT;
        _buffer = @{}.mutableCopy;
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 1;
        _link = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(step:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _link.paused = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    });
    
    [_requestQueue cancelAllOperations];
    LOCK([_buffer removeAllObjects]);
    _time = 0;
    _curIndex = 0;
    _curFrame = nil;
    _curLoop = 0;
    _totalLoop = 0;
    _totalIndex = 1;
    _loopEnd = NO;
    _bufferMiss = NO;
    _incrBufferCount = 0;
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    BOOL ani = [image conformsToProtocol:@protocol(YYAnimatedImage)];
    _hasAnimated = (ani && ((UIImage <YYAnimatedImage> *)image).animatedImageCount > 1);
    [self animatedChanged];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
    [super setHighlightedImage:highlightedImage];
    BOOL ani = [highlightedImage conformsToProtocol:@protocol(YYAnimatedImage)];
    _hasHighlightAnimated = (ani && ((UIImage <YYAnimatedImage> *)highlightedImage).animatedImageCount > 1);
    [self animatedChanged];
}

- (void)setAnimationImages:(NSArray *)animationImages {
    [super setAnimationImages:animationImages];
    [self animatedChanged];
}

- (void)setHighlightedAnimationImages:(NSArray *)highlightedAnimationImages {
    [super setHighlightedAnimationImages:highlightedAnimationImages];
    [self animatedChanged];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self animatedChanged];
}

- (void)animatedChanged {
    UIImage *newImg = nil;
    if (!_hasAnimated && !_hasHighlightAnimated) newImg = nil;
    else if (self.animationImages || self.highlightedAnimationImages) newImg = nil;
    else if (!_hasHighlightAnimated) newImg = self.image;
    else newImg = self.isHighlighted ? self.highlightedImage : self.image;
    if ((!_curAnimatedImage && newImg) || (_curAnimatedImage && !newImg)) {
        [self resetAnimated];
        _curAnimatedImage = (UIImage <YYAnimatedImage> *)newImg;
        if (newImg) {
            _curFrame = newImg;
            _totalLoop = _curAnimatedImage.animatedImageRepeatCount;
            _totalIndex = _curAnimatedImage.animatedImageCount;
            [self calcMaxBufferCount];
            _link.paused = !(self.superview && self.window);
        } else {
            _link.paused = YES;
        }
        [self.layer setNeedsDisplay];
    }
}

// dynamically adjust buffer size for current memory.
- (void)calcMaxBufferCount {
    NSUInteger bytes = _curAnimatedImage.animatedImageBytesPerFrame;
    if (bytes == 0) bytes = 1;
    
    int64_t total = [UIDevice currentDevice].memoryTotal;
    int64_t free = [UIDevice currentDevice].memoryFree;
    int64_t max = YY_MIN(total * 0.2, free * 0.6);
    max = YY_MAX(max, BUFFER_SIZE);
    _maxBufferCount = (float)max / (float)bytes;
    if (_maxBufferCount == 0) _maxBufferCount = 1;
}

- (void)dealloc {
    [_requestQueue cancelAllOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_link invalidate];
}

- (BOOL)isAnimating {
    if (_curAnimatedImage) {
        return _link.isPaused;
    } else {
        return [super isAnimating];
    }
}

- (void)stopAnimating {
    if (_curAnimatedImage) {
        _link.paused = YES;
    } else {
        [super stopAnimating];
    }
}

- (void)startAnimating {
    if (_curAnimatedImage) {
        _link.paused = NO;
    } else {
        [super startAnimating];
    }
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    [_requestQueue cancelAllOperations];
    [_requestQueue addOperationWithBlock: ^{
        _incrBufferCount = -60 - (int)(arc4random() % 120); // about 1~3 seconds to grow back..
        NSNumber *next = @((_curIndex + 1) % _totalIndex);
        LOCK(
             NSArray * keys = _buffer.allKeys;
             for (NSNumber * key in keys) {
                 if (![key isEqualToNumber:next]) { // keep the next frame for smoothly animation
                     [_buffer removeObjectForKey:key];
                 }
             }
        )//LOCK
    }];
}

- (void)step:(CADisplayLink *)link {
    UIImage <YYAnimatedImage> *image = _curAnimatedImage;
    NSMutableDictionary *buffer = _buffer;
    UIImage *bufferedImage = nil;
    NSUInteger nextIndex = (_curIndex + 1) % _totalIndex;
    
    if (!image) return;
    if (_loopEnd) { // view will keep in last frame
        [self stopAnimating];
        return;
    }
    
    NSTimeInterval delay = 0;
    if (!_bufferMiss) {
        _time += link.duration;
        delay = [image animatedImageDurationAtIndex:_curIndex];
        if (_time < delay) return;
        _time -= delay;
        if (nextIndex == 0) {
            _curLoop++;
            if (_curLoop > _totalLoop && _totalLoop != 0) {
                _loopEnd = YES;
            }
        }
        delay = [image animatedImageDurationAtIndex:nextIndex];
        if (_time > delay) _time = delay; // do not jump over frame
    }
    LOCK(
         bufferedImage = buffer[@(nextIndex)];
         if (bufferedImage) {
             if ((int)_incrBufferCount != _totalIndex) {
                 [buffer removeObjectForKey:@(nextIndex)];
             }
             _curIndex = nextIndex;
             _curFrame = bufferedImage;
             nextIndex = (_curIndex + 1) % _totalIndex;
             _bufferMiss = NO;
         } else {
             _bufferMiss = YES;
         }
    )//LOCK
    
    
    if (!_bufferMiss) {
        [self.layer setNeedsDisplay]; // let system call `displayLayer:`
    }
    
    if (_requestQueue.operationCount < 1) { // if some work not finished, wait for next opportunity
        [_requestQueue addOperationWithBlock: ^{
            _incrBufferCount++;
            if (_incrBufferCount == 0) [self calcMaxBufferCount];
            if ((int)_incrBufferCount > (int)_maxBufferCount) _incrBufferCount = _maxBufferCount;
            NSUInteger idx = nextIndex;
            NSUInteger max = _incrBufferCount < 1 ? 1 : _incrBufferCount;
            NSUInteger total = _totalIndex;
            for (int i = 0; i < max; i++, idx++) {
                @autoreleasepool {
                    if (idx >= total) idx = 0;
                    if (buffer[@(idx)] == nil) {
                        UIImage *img = [image animatedImageAtIndex:idx];
                        img = img.imageByDecoded;
                        LOCK(buffer[@(idx)] = img ? img : [NSNull null]);
                    }
                }
            }
        }];
    }
}

- (void)displayLayer:(CALayer *)layer {
    if (!_curAnimatedImage) return;
    layer.contents = (__bridge id)_curFrame.CGImage;
}

- (void)didMoved {
    if (self.superview && self.window) {
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self didMoved];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self didMoved];
}

@end
