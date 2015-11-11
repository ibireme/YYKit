//
//  YYBPGCoder.m
//  YYKitExample
//
//  Created by ibireme on 15/8/13.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYBPGCoder.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <bpg/libbpg.h>

#define YY_FOUR_CC(c1,c2,c3,c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))

/// Returns byte-aligned size.
static inline size_t _YYImageByteAlign(size_t size, size_t alignment) {
    return ((size + (alignment - 1)) / alignment) * alignment;
}

/**
 A callback used in CGDataProviderCreateWithData() to release data.
 
 Example:
 
 void *data = malloc(size);
 CGDataProviderRef provider = CGDataProviderCreateWithData(data, data, size, YYCGDataProviderReleaseDataCallback);
 */
static void _YYCGDataProviderReleaseDataCallback(void *info, const void *data, size_t size) {
    free(info);
}

CGImageRef YYCGImageCreateWithBPGData(CFDataRef bpgData, BOOL decodeForDisplay) {
    BPGDecoderContext *decoderContext = NULL;
    BPGImageInfo imageInfo = {0};
    size_t width, height, lineSize, stride, size;
    uint8_t *rgbaLine = NULL, *rgbaBuffer = NULL;
    CGDataProviderRef dataProvider = NULL;
    CGImageRef cgImage = NULL;
    CGBitmapInfo bitmapInfo;
    
    if (!bpgData || CFDataGetLength(bpgData) == 0) return NULL;
    decoderContext = bpg_decoder_open();
    if (!decoderContext) return NULL;
    if (bpg_decoder_decode(decoderContext, CFDataGetBytePtr(bpgData), (int)CFDataGetLength(bpgData)) < 0) goto fail;
    if (bpg_decoder_get_info(decoderContext, &imageInfo) < 0) goto fail;
    
    width = imageInfo.width;
    height = imageInfo.height;
    lineSize = 4 * width;
    stride = _YYImageByteAlign(lineSize, 32);
    size = stride * height;
    
    if (width == 0 || height == 0) goto fail;
    rgbaLine = malloc(lineSize);
    if (!rgbaLine) goto fail;
    rgbaBuffer = malloc(size);
    if (!rgbaBuffer) goto fail;
    if (bpg_decoder_start(decoderContext, BPG_OUTPUT_FORMAT_RGBA32) < 0) goto fail;
    
    for (int y = 0; y < height; y++) {
        if (bpg_decoder_get_line(decoderContext, rgbaLine) < 0) goto fail;
        memcpy(rgbaBuffer + (y * stride), rgbaLine, lineSize);
    }
    free(rgbaLine);
    rgbaLine = NULL;
    bpg_decoder_close(decoderContext);
    decoderContext = NULL;
    
    if (decodeForDisplay) {
        vImage_Buffer src;
        src.data = rgbaBuffer;
        src.width = width;
        src.height = height;
        src.rowBytes = stride;
        vImage_Error error;
        
        // premultiply RGBA
        error = vImagePremultiplyData_RGBA8888(&src, &src, kvImageNoFlags);
        if (error != kvImageNoError) goto fail;
        
        // convert to bgrA
        uint8_t map[4] = {2,1,0,3};
        error = vImagePermuteChannels_ARGB8888(&src, &src, map, kvImageNoFlags);
        if (error != kvImageNoError) goto fail;
        bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
    } else {
        bitmapInfo = kCGImageAlphaLast | kCGBitmapByteOrderDefault;
    }
    
    dataProvider = CGDataProviderCreateWithData(rgbaBuffer, rgbaBuffer, size, _YYCGDataProviderReleaseDataCallback);
    if (!dataProvider) goto fail;
    rgbaBuffer = NULL; // hold by provider
    cgImage = CGImageCreate(width, height, 8, 32, stride, YYCGColorSpaceGetDeviceRGB(),
                            bitmapInfo, dataProvider, NULL, NO,
                            kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    return cgImage;
    
fail:
    if (decoderContext) bpg_decoder_close(decoderContext);
    if (rgbaLine) free(rgbaLine);
    if (rgbaBuffer) free(rgbaBuffer);
    return NULL;
}


CGImageRef YYCGImageCreateFrameWithBPGData(CFDataRef bpgData, NSUInteger frameIndex, BOOL decodeForDisplay) {
    BPGDecoderContext *decoderContext = NULL;
    BPGImageInfo imageInfo = {0};
    size_t width, height, lineSize, stride, size;
    uint8_t *rgbaLine = NULL, *rgbaBuffer = NULL;
    CGDataProviderRef dataProvider = NULL;
    CGImageRef cgImage = NULL;
    CGBitmapInfo bitmapInfo;
    
    if (!bpgData || CFDataGetLength(bpgData) == 0) return NULL;
    decoderContext = bpg_decoder_open();
    if (!decoderContext) return NULL;
    if (bpg_decoder_decode(decoderContext, CFDataGetBytePtr(bpgData), (int)CFDataGetLength(bpgData)) < 0) goto fail;
    if (bpg_decoder_get_info(decoderContext, &imageInfo) < 0) goto fail;
    
    width = imageInfo.width;
    height = imageInfo.height;
    lineSize = 4 * width;
    stride = _YYImageByteAlign(lineSize, 32);
    size = stride * height;
    
    if (width == 0 || height == 0) goto fail;
    rgbaLine = malloc(lineSize);
    if (!rgbaLine) goto fail;
    rgbaBuffer = malloc(size);
    if (!rgbaBuffer) goto fail;
    
    for (NSUInteger i = 0; i <= frameIndex; i++) {
        if (bpg_decoder_start(decoderContext, BPG_OUTPUT_FORMAT_RGBA32) < 0) goto fail;
    }
    
    for (int y = 0; y < height; y++) {
        if (bpg_decoder_get_line(decoderContext, rgbaLine) < 0) goto fail;
        memcpy(rgbaBuffer + (y * stride), rgbaLine, lineSize);
    }
    free(rgbaLine);
    rgbaLine = NULL;
    bpg_decoder_close(decoderContext);
    decoderContext = NULL;
    
    if (decodeForDisplay) {
        vImage_Buffer src;
        src.data = rgbaBuffer;
        src.width = width;
        src.height = height;
        src.rowBytes = stride;
        vImage_Error error;
        
        // premultiply RGBA
        error = vImagePremultiplyData_RGBA8888(&src, &src, kvImageNoFlags);
        if (error != kvImageNoError) goto fail;
        
        // convert to BGRA
        uint8_t map[4] = {2,1,0,3};
        error = vImagePermuteChannels_ARGB8888(&src, &src, map, kvImageNoFlags);
        if (error != kvImageNoError) goto fail;
        bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
    } else {
        bitmapInfo = kCGImageAlphaLast | kCGBitmapByteOrderDefault;
    }
    
    dataProvider = CGDataProviderCreateWithData(rgbaBuffer, rgbaBuffer, size, _YYCGDataProviderReleaseDataCallback);
    if (!dataProvider) goto fail;
    rgbaBuffer = NULL; // hold by provider
    cgImage = CGImageCreate(width, height, 8, 32, stride, YYCGColorSpaceGetDeviceRGB(),
                            bitmapInfo, dataProvider, NULL, NO,
                            kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    return cgImage;
    
fail:
    if (decoderContext) bpg_decoder_close(decoderContext);
    if (rgbaLine) free(rgbaLine);
    if (rgbaBuffer) free(rgbaBuffer);
    return NULL;
}


void YYCGImageDecodeAllFrameInBPGData(CFDataRef bpgData, BOOL decodeForDisplay) {
    BPGDecoderContext *decoderContext = NULL;
    BPGImageInfo imageInfo = {0};
    size_t width, height, lineSize, stride, size;
    uint8_t *rgbaLine = NULL, *rgbaBuffer = NULL;
    CGDataProviderRef dataProvider = NULL;
    CGImageRef cgImage = NULL;
    CGBitmapInfo bitmapInfo;
    
    if (!bpgData || CFDataGetLength(bpgData) == 0) return;
    decoderContext = bpg_decoder_open();
    if (!decoderContext) return;
    if (bpg_decoder_decode(decoderContext, CFDataGetBytePtr(bpgData), (int)CFDataGetLength(bpgData)) < 0) goto end;
    if (bpg_decoder_get_info(decoderContext, &imageInfo) < 0) goto end;
    
    width = imageInfo.width;
    height = imageInfo.height;
    lineSize = 4 * width;
    stride = _YYImageByteAlign(lineSize, 32);
    size = stride * height;
    
    
    for (;;) {
        if (bpg_decoder_start(decoderContext, BPG_OUTPUT_FORMAT_RGBA32) < 0) goto end;
        
        if (width == 0 || height == 0) goto end;
        rgbaLine = malloc(lineSize);
        if (!rgbaLine) goto end;
        rgbaBuffer = malloc(size);
        if (!rgbaBuffer) goto end;
        
        for (int y = 0; y < height; y++) {
            if (bpg_decoder_get_line(decoderContext, rgbaLine) < 0) goto end;
            memcpy(rgbaBuffer + (y * stride), rgbaLine, lineSize);
        }
        free(rgbaLine);
        rgbaLine = NULL;
        
        if (decodeForDisplay) {
            vImage_Buffer src;
            src.data = rgbaBuffer;
            src.width = width;
            src.height = height;
            src.rowBytes = stride;
            vImage_Error error;
            
            // premultiply RGBA
            error = vImagePremultiplyData_RGBA8888(&src, &src, kvImageNoFlags);
            if (error != kvImageNoError) goto end;
            
            // convert to BGRA
            uint8_t map[4] = {2,1,0,3};
            error = vImagePermuteChannels_ARGB8888(&src, &src, map, kvImageNoFlags);
            if (error != kvImageNoError) goto end;
            bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
        } else {
            bitmapInfo = kCGImageAlphaLast | kCGBitmapByteOrderDefault;
        }
        
        dataProvider = CGDataProviderCreateWithData(rgbaBuffer, rgbaBuffer, size, _YYCGDataProviderReleaseDataCallback);
        if (!dataProvider) goto end;
        rgbaBuffer = NULL; // hold by provider
        cgImage = CGImageCreate(width, height, 8, 32, stride, YYCGColorSpaceGetDeviceRGB(),
                                bitmapInfo, dataProvider, NULL, NO,
                                kCGRenderingIntentDefault);
        
        CGDataProviderRelease(dataProvider);
        if (cgImage) CFRelease(cgImage);
    }
    return;
    
end:
    if (decoderContext) bpg_decoder_close(decoderContext);
    if (rgbaLine) free(rgbaLine);
    if (rgbaBuffer) free(rgbaBuffer);
    return;
}


BOOL YYImageIsBPGData(CFDataRef data) {
    if (!data || CFDataGetLength(data) < 8) return NO;
    const uint8_t *bytes = CFDataGetBytePtr(data);
    uint32_t magic = *((uint32_t *)bytes);
    return magic == YY_FOUR_CC('B', 'P', 'G', 0xFB);
}
