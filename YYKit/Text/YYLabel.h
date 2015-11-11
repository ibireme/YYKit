//
//  YYLabel.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYTextParser.h>
#import <YYKit/YYTextLayout.h>
#import <YYKit/YYTextAttribute.h>
#else
#import "YYTextParser.h"
#import "YYTextLayout.h"
#import "YYTextAttribute.h"
#endif

/**
 The YYLabel class implements a read-only text view.
 
 @discussion The API and behavior is similar to UILabel, but provides more features:
 
 * It supports asynchronous layout and rendering (to avoid blocking UI thread).
 * It extends the CoreText attributes to support more text effects.
 * It allows to add UIImage, UIView and CALayer as text attachments.
 * It allows to add 'highlight' link to some range of text to allow user interact with.
 * It allows to add container path and exclusion paths to control text container's shape.
 * It supports vertical form layout to display CJK text.
 
 See NSAttributedString+YYText.h for more convenience methods to set the attributes.
 See YYTextAttribute.h and YYTextLayout.h for more information.
 */
@interface YYLabel : UIView <NSCoding>

#pragma mark - Accessing the Text Attributes
///=============================================================================
/// @name Accessing the Text Attributes
///=============================================================================

/**
 The text displayed by the label. Default is nil.
 Set a new value to this property also replaces the text in `attributedText`.
 Get the value returns the plain text in `attributedText`.
 */
@property (nonatomic, copy) NSString *text;

/**
 The font of the text. Default is 12-point system font.
 Set a new value to this property also causes the new font to be applied to the entire `attributedText`.
 Get the value returns the font at the head of `attributedText`.
 */
@property (nonatomic, retain) UIFont *font;

/**
 The color of the text. Default is black.
 Set a new value to this property also causes the new color to be applied to the entire `attributedText`.
 Get the value returns the color at the head of `attributedText`.
 */
@property (nonatomic, retain) UIColor *textColor;

/**
 The shadow color of the text. Default is nil.
 Set a new value to this property also causes the shadow color to be applied to the entire `attributedText`.
 Get the value returns the shadow color at the head of `attributedText`.
 */
@property (nonatomic, retain) UIColor *shadowColor;

/**
 The shadow offset of the text. Default is CGSizeZero.
 Set a new value to this property also causes the shadow offset to be applied to the entire `attributedText`.
 Get the value returns the shadow offset at the head of `attributedText`.
 */
@property (nonatomic, assign) CGSize shadowOffset;

/**
 The shadow blur of the text. Default is 0.
 Set a new value to this property also causes the shadow blur to be applied to the entire `attributedText`.
 Get the value returns the shadow blur at the head of `attributedText`.
 */
@property (nonatomic, assign) CGFloat shadowBlurRadius;

/**
 The technique to use for aligning the text. Default is NSLeftTextAlignment.
 Set a new value to this property also causes the new alignment to be applied to the entire `attributedText`.
 Get the value returns the alignment at the head of `attributedText`.
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/**
 The text vertical aligmnent in container. Default is YYTextVerticalAlignmentCenter.
 */
@property (nonatomic, assign) YYTextVerticalAlignment textVerticalAlignment;

/**
 The styled text displayed by the label.
 Set a new value to this property also replaces the value of the `text`, `font`, `textColor`,
 `textAlignment` and other properties in label.
 
 @discussion It only support the attributes declared in CoreText and YYTextAttribute.
 See `NSAttributedString+YYText` for more convenience methods to set the attributes.
 */
@property (nonatomic, copy) NSAttributedString *attributedText;

/**
 The technique to use for wrapping and truncating the label's text.
 Default is NSLineBreakByTruncatingTail.
 */
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;

/**
 The truncation token string used when text is truncated. Default is nil.
 When the value is nil, the label use "…" as default truncation token.
 */
@property (nonatomic, copy) NSAttributedString *truncationToken;

/**
 The maximum number of lines to use for rendering text. Default value is 1.
 0 means no limit.
 */
@property (nonatomic, assign) NSUInteger numberOfLines;

/**
 When `text` or `attributedText` is changed, the parser will be called to modify the text.
 It can be used to add code highlighting or emoticon replacement to text view. 
 The default value is nil.
 
 See `YYTextParser` protocol for more information.
 */
@property (nonatomic, strong) id<YYTextParser> textParser;

/**
 The current text layout in text view. It can be used to query the text layout information.
 Set a new value to this property also replaces most properties in this label, such as `text`,
 `color`, `attributedText`, `lineBreakMode`, `textContainerPath`, `exclusionPaths` and so on.
 */
@property (nonatomic, strong) YYTextLayout *textLayout;


#pragma mark - Configuring the Text Container
///=============================================================================
/// @name Configuring the Text Container
///=============================================================================

/**
 A UIBezierPath object that specifies the shape of the text frame. Default value is nil.
 */
@property (nonatomic, copy) UIBezierPath *textContainerPath;

/**
 An array of UIBezierPath objects representing the exclusion paths inside the
 receiver's bounding rectangle. Default value is nil.
 */
@property (nonatomic, copy) NSArray *exclusionPaths;

/**
 The inset of the text container's layout area within the text view's content area.
 Default value is UIEdgeInsetsZero.
 */
@property (nonatomic, assign) UIEdgeInsets textContainerInset;

/**
 Whether the receiver's layout orientation is vertical form. Default is NO.
 It may used to display CJK text.
 */
@property (nonatomic, assign, getter=isVerticalForm) BOOL verticalForm;

/**
 The text line position modifier used to modify the lines' position in layout.
 Default value is nil.
 See `YYTextLinePositionModifier` protocol for more information.
 */
@property (nonatomic, copy) id<YYTextLinePositionModifier> linePositionModifier;

/**
 The debug option to display CoreText layout result.
 The default value is [YYTextDebugOption sharedDebugOption].
 */
@property (nonatomic, copy) YYTextDebugOption *debugOption;


#pragma mark - Interacting with Text Data
///=============================================================================
/// @name Interacting with Text Data
///=============================================================================

/**
 When user tap the highlight range of text, this action will be called.
 The default value is nil.
 */
@property (nonatomic, copy) YYTextAction highlightTapAction;

/**
 When user long press the highlight range of text, this action will be called.
 The default value is nil. 
 */
@property (nonatomic, copy) YYTextAction highlightLongPressAction;


#pragma mark - Configuring the Display Mode
///=============================================================================
/// @name Configuring the Display Mode
///=============================================================================

/**
 A Boolean value indicating whether the layout and rendering codes are running
 asynchronously on background threads. 
 
 The default value is `NO`.
 */
@property (nonatomic, assign) BOOL displaysAsynchronously;

/**
 If the value is YES, and the layer is rendered asynchronously, then it will
 set label.layer.contents to nil before display. 
 
 The default value is `YES`.
 
 @discussion When the asynchronously display is enabled, the layer's content will
 be updated after the background render process finished. If the render process
 can not finished in a vsync time (1/60 second), the old content will be still kept
 for display. You may manually clear the content by set the layer.contents to nil 
 after you update the label's properties, or you can just set this property to YES.
 */
@property (nonatomic, assign) BOOL clearContentsBeforeAsynchronouslyDisplay;

/**
 If the value is YES, and the layer is rendered asynchronously, then it will add 
 a fade animation on layer when the contents of layer changed. 
 
 The default value is `YES`.
 */
@property (nonatomic, assign) BOOL fadeOnAsynchronouslyDisplay;

/**
 If the value is YES, then it will add a fade animation on layer when some range
 of text become highlighted. 
 
 The default value is `YES`.
 */
@property (nonatomic, assign) BOOL fadeOnHighlight;

/**
 Ignore common properties (such as text, font, textColor, attributedText...) and
 only use "textLayout" to display content. 
 
 The default value is `NO`.
 
 @discussion If you control the label content only through "textLayout", then
 you may set this value to YES for higher performance.
 */
@property (nonatomic, assign) BOOL ignoreCommonProperties;

/*
 Tips:
 
 1. If you only need a UILabel alternative to display rich text and receive link touch event, 
    you do not need to adjust the display mode properties.
 
 2. If you have performance issues, you may enable the asynchronous display mode
    by setting the `displaysAsynchronously` to YES.
 
 3. If you want to get the highest performance, you should do text layout with
    `YYTextLayout` class in background thread. Here's an example:
    
    YYLabel *label = [YYLabel new];
    label.displaysAsynchronously = YES;
    label.ignoreCommonProperties = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
        // Create attributed string.
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Some Text"];
        text.font = [UIFont systemFontOfSize:16];
        text.color = [UIColor grayColor];
        [text setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
 
        // Create text container
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(100, CGFLOAT_MAX);
        container.maximumNumberOfRows = 0;
        
        // Generate a text layout.
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            label.size = layout.textBoundingSize;
            label.textLayout = layout;
        });
    });
 
 */

@end
