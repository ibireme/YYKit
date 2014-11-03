//
//  YYGIFImage.m
//  YYKit
//
//  Created by ibireme on 14/10/20.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYGIFImage.h"
#import "YYKitMacro.h"
#import "NSString+YYAdd.h"
#import "UIImage+YYAdd.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation YYGIFImage {
    CGImageSourceRef _gifSource; // keep for gif decode
    NSData *_gifData; // keep for NSCoding
    NSUInteger _gifFrameCount;
    NSUInteger _gifRepeatCount;
    NSArray *_gifDelayTimes;
    NSUInteger _bytesPerFrame;
}

+ (instancetype)imageNamed:(NSString *)name {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return nil;
    
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    CGFloat scale = 0;
    
    // first search screen's scale, then search from high to low.
    NSMutableArray *scales = @[@3,@2,@1].mutableCopy;
    NSInteger screenScale = [UIScreen mainScreen].scale;
    [scales removeObject:@(screenScale)];
    [scales insertObject:@(screenScale) atIndex:0];
    
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber* )scales[s]).floatValue;
        NSString *scaledName = [res stringByAppendingNameScale:scale];
        // if no ext, guess by system supported.
        NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"gif",@"png",@"jpg",@"jpeg",@"bmp",@"tif",@"tiff"];
        for (int e = 0; e < exts.count; e++) {
            path = [[NSBundle mainBundle] pathForResource:scaledName ofType:exts[e]];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    
    return [[self alloc] initWithData:data scale:scale];
}

+ (instancetype)imageWithContentsOfFile:(NSString *)path {
    return [[self alloc] initWithContentsOfFile:path];
}

+ (instancetype)imageWithData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

+ (instancetype)imageWithData:(NSData *)data scale:(CGFloat)scale{
    return [[self alloc] initWithData:data scale:scale];
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self initWithData:data scale:path.pathScale];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithData:data scale:1];
}

- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale{
    if (data.length == 0) return nil;
    if (scale < 1) scale = 1;
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
    if (!source) return nil;
    size_t count = CGImageSourceGetCount(source);
    if (count == 0) { CFRelease(source); return nil; }
    BOOL isGIFType = UTTypeConformsTo(CGImageSourceGetType(source), kUTTypeGIF);
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CGImageRef decoded = CGImageCreateDecoded(imageRef);
    long frameByte = CGImageGetBytesPerRow(decoded) * CGImageGetWidth(decoded);
    CGImageRelease(imageRef);
    self = [self initWithCGImage:decoded scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(decoded);
    
    if (!self){
        CFRelease(source);
        return nil;
    }
    self->_gifSource = source;
    
    if (count > 1 && isGIFType) {
        _gifSource = source;
        _gifData = data;
        _gifFrameCount = count;
        
        CFDictionaryRef prop = CGImageSourceCopyProperties(source, NULL);
        if (prop) {
            NSNumber *repeat = CFDictionaryGetValue(prop, kCGImagePropertyGIFLoopCount);
            _gifRepeatCount = repeat.unsignedIntegerValue;
            CFRelease(prop);
        }
        
        NSMutableArray *delays = @[].mutableCopy;
        for (int i = 0; i < count; i++) {
            NSTimeInterval delay = 0;
            CFDictionaryRef dic = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            if (dic) {
                CFDictionaryRef dicGIF = CFDictionaryGetValue(dic, kCGImagePropertyGIFDictionary);
                if (dicGIF) {
                    NSNumber *num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFUnclampedDelayTime);
                    if (num.doubleValue <= __FLT_EPSILON__) {
                        num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFDelayTime);
                    }
                    delay = num.doubleValue;
                }
                CFRelease(dic);
            }
            
            // Web Browser Compatibility
            // http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
            if (delay < 0.02) delay = 0.1;
            [delays addObject:@(delay)];
        }
        _gifDelayTimes = delays;
    }
    
    if (_gifFrameCount > 1) {
        _bytesPerFrame = frameByte;
    }
    
    self.isImageDecoded = YES;
    return self;
}

- (void)dealloc {
    if (_gifSource) CFRelease(_gifSource);
}


#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *scale = [aDecoder decodeObjectForKey:@"YYGIFScale"];
    NSData *data = [aDecoder decodeObjectForKey:@"YYGIFData"];
    if (data) {
        self = [self initWithData:data scale:scale.floatValue];
    } else {
        self = [super initWithCoder:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    if (_gifData) {
        [aCoder encodeObject:@(self.scale) forKey:@"YYGIFScale"];
        [aCoder encodeObject:_gifData forKey:@"YYGIFData"];
    }
}

#pragma mark - YYAnimtedImage

- (NSUInteger)animatedImageCount {
    return _gifFrameCount ? _gifFrameCount : 1;
}

-(NSUInteger) animatedImageRepeatCount {
    return _gifRepeatCount;
}

- (NSUInteger) animatedImageBytesPerFrame {
    return _bytesPerFrame;
}

- (UIImage *)animatedImageAtIndex:(NSUInteger)index {
    if (index >= _gifFrameCount) return nil;
    NSMutableDictionary *options = @{}.mutableCopy;
    options[(id)kCGImageSourceShouldCache] = (id)kCFBooleanTrue;
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_gifSource, index, (CFTypeRef)options);
    CGImageRef decoded = CGImageCreateDecoded(imageRef);
    CGImageRelease(imageRef);
    UIImage *image = [UIImage imageWithCGImage:decoded scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(decoded);
    image.isImageDecoded = YES;
    return image;
}

- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index {
    if (index >= _gifDelayTimes.count) return 0;
    NSNumber *num = _gifDelayTimes[index];
    return num.doubleValue;
}

@end
