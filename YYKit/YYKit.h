//
//  YYKit.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/3/30.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<YYKit/YYKit.h>)

FOUNDATION_EXPORT double YYKitVersionNumber;
FOUNDATION_EXPORT const unsigned char YYKitVersionString[];

#import <YYKit/YYKitMacro.h>
#import <YYKit/NSObject+YYAdd.h>
#import <YYKit/NSObject+YYAddForKVO.h>
#import <YYKit/NSObject+YYAddForARC.h>
#import <YYKit/NSString+YYAdd.h>
#import <YYKit/NSNumber+YYAdd.h>
#import <YYKit/NSData+YYAdd.h>
#import <YYKit/NSArray+YYAdd.h>
#import <YYKit/NSDictionary+YYAdd.h>
#import <YYKit/NSDate+YYAdd.h>
#import <YYKit/NSNotificationCenter+YYAdd.h>
#import <YYKit/NSKeyedUnarchiver+YYAdd.h>
#import <YYKit/NSTimer+YYAdd.h>
#import <YYKit/NSBundle+YYAdd.h>
#import <YYKit/NSThread+YYAdd.h>

#import <YYKit/UIColor+YYAdd.h>
#import <YYKit/UIImage+YYAdd.h>
#import <YYKit/UIControl+YYAdd.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>
#import <YYKit/UIGestureRecognizer+YYAdd.h>
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIScrollView+YYAdd.h>
#import <YYKit/UITableView+YYAdd.h>
#import <YYKit/UITextField+YYAdd.h>
#import <YYKit/UIScreen+YYAdd.h>
#import <YYKit/UIDevice+YYAdd.h>
#import <YYKit/UIApplication+YYAdd.h>
#import <YYKit/UIFont+YYAdd.h>
#import <YYKit/UIBezierPath+YYAdd.h>

#import <YYKit/CALayer+YYAdd.h>
#import <YYKit/YYCGUtilities.h>

#import <YYKit/NSObject+YYModel.h>
#import <YYKit/YYClassInfo.h>

#import <YYKit/YYCache.h>
#import <YYKit/YYMemoryCache.h>
#import <YYKit/YYDiskCache.h>
#import <YYKit/YYKVStorage.h>

#import <YYKit/YYImage.h>
#import <YYKit/YYFrameImage.h>
#import <YYKit/YYSpriteSheetImage.h>
#import <YYKit/YYAnimatedImageView.h>
#import <YYKit/YYImageCoder.h>
#import <YYKit/YYImageCache.h>
#import <YYKit/YYWebImageOperation.h>
#import <YYKit/YYWebImageManager.h>
#import <YYKit/UIImageView+YYWebImage.h>
#import <YYKit/UIButton+YYWebImage.h>
#import <YYKit/MKAnnotationView+YYWebImage.h>
#import <YYKit/CALayer+YYWebImage.h>

#import <YYKit/YYLabel.h>
#import <YYKit/YYTextView.h>
#import <YYKit/YYTextAttribute.h>
#import <YYKit/YYTextArchiver.h>
#import <YYKit/YYTextParser.h>
#import <YYKit/YYTextUtilities.h>
#import <YYKit/YYTextRunDelegate.h>
#import <YYKit/YYTextRubyAnnotation.h>
#import <YYKit/NSAttributedString+YYText.h>
#import <YYKit/NSParagraphStyle+YYText.h>
#import <YYKit/UIPasteboard+YYText.h>
#import <YYKit/YYTextLayout.h>
#import <YYKit/YYTextLine.h>
#import <YYKit/YYTextInput.h>
#import <YYKit/YYTextDebugOption.h>
#import <YYKit/YYTextContainerView.h>
#import <YYKit/YYTextSelectionView.h>
#import <YYKit/YYTextMagnifier.h>
#import <YYKit/YYTextEffectWindow.h>
#import <YYKit/YYTextKeyboardManager.h>

#import <YYKit/YYReachability.h>
#import <YYKit/YYGestureRecognizer.h>
#import <YYKit/YYFileHash.h>
#import <YYKit/YYKeychain.h>
#import <YYKit/YYWeakProxy.h>
#import <YYKit/YYTimer.h>
#import <YYKit/YYTransaction.h>
#import <YYKit/YYAsyncLayer.h>
#import <YYKit/YYSentinel.h>
#import <YYKit/YYDispatchQueuePool.h>
#import <YYKit/YYThreadSafeArray.h>
#import <YYKit/YYThreadSafeDictionary.h>

#else

#import "YYKitMacro.h"
#import "NSObject+YYAdd.h"
#import "NSObject+YYAddForKVO.h"
#import "NSObject+YYAddForARC.h"
#import "NSString+YYAdd.h"
#import "NSNumber+YYAdd.h"
#import "NSData+YYAdd.h"
#import "NSArray+YYAdd.h"
#import "NSDictionary+YYAdd.h"
#import "NSDate+YYAdd.h"
#import "NSNotificationCenter+YYAdd.h"
#import "NSKeyedUnarchiver+YYAdd.h"
#import "NSTimer+YYAdd.h"
#import "NSBundle+YYAdd.h"
#import "NSThread+YYAdd.h"

#import "UIColor+YYAdd.h"
#import "UIImage+YYAdd.h"
#import "UIControl+YYAdd.h"
#import "UIBarButtonItem+YYAdd.h"
#import "UIGestureRecognizer+YYAdd.h"
#import "UIView+YYAdd.h"
#import "UIScrollView+YYAdd.h"
#import "UITableView+YYAdd.h"
#import "UITextField+YYAdd.h"
#import "UIScreen+YYAdd.h"
#import "UIDevice+YYAdd.h"
#import "UIApplication+YYAdd.h"
#import "UIFont+YYAdd.h"
#import "UIBezierPath+YYAdd.h"

#import "CALayer+YYAdd.h"
#import "YYCGUtilities.h"

#import "NSObject+YYModel.h"
#import "YYClassInfo.h"

#import "YYCache.h"
#import "YYMemoryCache.h"
#import "YYDiskCache.h"
#import "YYKVStorage.h"

#import "YYImage.h"
#import "YYFrameImage.h"
#import "YYSpriteSheetImage.h"
#import "YYAnimatedImageView.h"
#import "YYImageCoder.h"
#import "YYImageCache.h"
#import "YYWebImageOperation.h"
#import "YYWebImageManager.h"
#import "UIImageView+YYWebImage.h"
#import "UIButton+YYWebImage.h"
#import "MKAnnotationView+YYWebImage.h"
#import "CALayer+YYWebImage.h"

#import "YYLabel.h"
#import "YYTextView.h"
#import "YYTextAttribute.h"
#import "YYTextArchiver.h"
#import "YYTextParser.h"
#import "YYTextUtilities.h"
#import "YYTextRunDelegate.h"
#import "YYTextRubyAnnotation.h"
#import "NSAttributedString+YYText.h"
#import "NSParagraphStyle+YYText.h"
#import "UIPasteboard+YYText.h"
#import "YYTextLayout.h"
#import "YYTextLine.h"
#import "YYTextInput.h"
#import "YYTextDebugOption.h"
#import "YYTextContainerView.h"
#import "YYTextSelectionView.h"
#import "YYTextMagnifier.h"
#import "YYTextEffectWindow.h"
#import "YYTextKeyboardManager.h"

#import "YYReachability.h"
#import "YYGestureRecognizer.h"
#import "YYFileHash.h"
#import "YYKeychain.h"
#import "YYWeakProxy.h"
#import "YYTimer.h"
#import "YYTransaction.h"
#import "YYAsyncLayer.h"
#import "YYSentinel.h"
#import "YYDispatchQueuePool.h"
#import "YYThreadSafeArray.h"
#import "YYThreadSafeDictionary.h"

#endif
