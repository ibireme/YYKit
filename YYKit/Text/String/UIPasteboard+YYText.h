//
//  UIPasteboard+YYText.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/4/2.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Extend UIPasteboard to support image and attributed string.
 */
@interface UIPasteboard (YYText)

@property (nullable, nonatomic, copy) NSData *PNGData;    ///< PNG file data
@property (nullable, nonatomic, copy) NSData *JPEGData;   ///< JPEG file data
@property (nullable, nonatomic, copy) NSData *GIFData;    ///< GIF file data
@property (nullable, nonatomic, copy) NSData *WEBPData;   ///< WebP file data
@property (nullable, nonatomic, copy) NSData *imageData;  ///< image file data

/// Attributed string,
/// Set this attributed will also set the string property which is copy from the attributed string.
/// If the attributed string contains one or more image, it will also set the `images` property.
@property (nullable, nonatomic, copy) NSAttributedString *attributedString;

@end


/// The name identifying the attributed string in pasteboard.
UIKIT_EXTERN NSString *const YYPasteboardTypeAttributedString;

/// The UTI Type identifying WebP data in pasteboard.
UIKIT_EXTERN NSString *const YYUTTypeWEBP;

NS_ASSUME_NONNULL_END
