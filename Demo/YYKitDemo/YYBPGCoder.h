//
//  YYBPGCoder.h
//  YYKitExample
//
//  Created by ibireme on 15/8/13.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYKit.h"

/*
 BPG image format:
 http://bellard.org/bpg/
 */

/**
 Decode BPG data
 @param bpgData  BPG image data.
 @param decodeForDisplay  YES: returns a premultiply BRGA format image, NO: returns an ARGB format image.
 @return A new image, or NULL if an error occurs.
 */
CG_EXTERN CGImageRef YYCGImageCreateWithBPGData(CFDataRef bpgData, BOOL decodeForDisplay);

/**
 Decode a frame from BPG image data, returns NULL if an error occurs.
 @warning This method should only be used for benchmark.
 */
CG_EXTERN CGImageRef YYCGImageCreateFrameWithBPGData(CFDataRef bpgData, NSUInteger frameIndex, BOOL decodeForDisplay);

/**
 Decode all frames in BPG image data, returns NULL if an error occurs.
 @warning This method should only be used for benchmark.
 */
CG_EXTERN void YYCGImageDecodeAllFrameInBPGData(CFDataRef bpgData, BOOL decodeForDisplay);

/**
 Whether data is bpg.
 */
CG_EXTERN BOOL YYImageIsBPGData(CFDataRef data);


