//
//  YYLabel.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYLabel.h"
#import "YYAsyncLayer.h"
#import "YYWeakProxy.h"
#import "YYCGUtilities.h"
#import "NSAttributedString+YYText.h"

#if __has_include("YYDispatchQueuePool.h")
#import "YYDispatchQueuePool.h"
#else
#import <libkern/OSAtomic.h>
#endif

#ifdef YYDispatchQueuePool_h
static dispatch_queue_t YYLabelGetReleaseQueue() {
    return YYDispatchQueueGetForQOS(NSQualityOfServiceUtility);
}
#else
static dispatch_queue_t YYLabelGetReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}
#endif


#define kLongPressMinimumDuration 0.5 // Time in seconds the fingers must be held down for long press gesture.
#define kLongPressAllowableMovement 9.0 // Maximum movement in points allowed before the long press fails.
#define kHighlightFadeDuration 0.15 // Time in seconds for highlight fadeout animation.
#define kAsyncFadeDuration 0.08 // Time in seconds for async display fadeout animation.


@interface YYLabel() <YYTextDebugTarget, YYAsyncLayerDelegate> {
    NSMutableAttributedString *_innerText; ///< nonnull
    YYTextLayout *_innerLayout;
    YYTextContainer *_innerContainer; ///< nonnull
    
    NSMutableArray *_attachmentViews;
    NSMutableArray *_attachmentLayers;
    
    NSRange _highlightRange; ///< current highlight range
    YYTextHighlight *_highlight; ///< highlight attribute in `_highlightRange`
    YYTextLayout *_highlightLayout; ///< when _state.showingHighlight=YES, this layout should be displayed
    
    NSTimer *_longPressTimer;
    CGPoint _touchBeganPoint;
    
    struct {
        unsigned int layoutNeedUpdate : 1;
        unsigned int showingHighlight : 1;
        
        unsigned int trackingTouch : 1;
        unsigned int swallowTouch : 1;
        unsigned int touchMoved : 1;
        
        unsigned int contentsNeedFade : 1;
    } _state;
}
@end


@implementation YYLabel

#pragma mark - Private

- (void)_updateIfNeeded {
    if (_state.layoutNeedUpdate) {
        _state.layoutNeedUpdate = NO;
        [self _updateLayout];
        [self.layer setNeedsDisplay];
    }
}

- (void)_updateLayout {
    _innerLayout = [YYTextLayout layoutWithContainer:_innerContainer text:_innerText];
}

- (void)_setLayoutNeedUpdate {
    _state.layoutNeedUpdate = YES;
    [self _clearInnerLayout];
    [self _setLayoutNeedRedraw];
}

- (void)_setLayoutNeedRedraw {
    [self.layer setNeedsDisplay];
}

- (void)_clearInnerLayout {
    if (!_innerLayout) return;
    YYTextLayout *layout = _innerLayout;
    _innerLayout = nil;
    dispatch_async(YYLabelGetReleaseQueue(), ^{
        NSAttributedString *text = [layout text]; // capture to block and release in background
        if (layout.attachments.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [text length]; // capture to block and release in main thread (maybe there's UIView/CALayer attachments).
            });
        }
    });
}

- (void)_startLongPressTimer {
    [_longPressTimer invalidate];
    _longPressTimer = [NSTimer timerWithTimeInterval:kLongPressMinimumDuration
                                              target:[YYWeakProxy proxyWithTarget:self]
                                            selector:@selector(_trackDidLongPress)
                                            userInfo:nil
                                             repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_longPressTimer forMode:NSRunLoopCommonModes];
}

- (void)_endLongPressTimer {
    [_longPressTimer invalidate];
    _longPressTimer = nil;
}

- (void)_trackDidLongPress {
    [self _endLongPressTimer];
    if (_highlight) {
        YYTextAction longPressAction = _highlight.longPressAction ? _highlight.longPressAction : _highlightLongPressAction;
        if (longPressAction) {
            CGRect rect = [_innerLayout rectForRange:[YYTextRange rangeWithRange:_highlightRange]];
            rect = [self _convertRectFromLayout:rect];
            longPressAction(self, _innerText, _highlightRange, rect);
            [self _removeHighlightAnimated:YES];
            _state.trackingTouch = NO;
        }
    }
}

- (YYTextHighlight *)_getHighlightAtPoint:(CGPoint)point range:(NSRangePointer)range {
    if (!_innerLayout.containsHighlight) return nil;
    point = [self _convertPointToLayout:point];
    YYTextRange *textRange = [_innerLayout textRangeAtPoint:point];
    if (!textRange) return nil;
    
    NSUInteger startIndex = textRange.start.offset;
    if (startIndex == _innerText.length) {
        if (startIndex > 0) {
            startIndex--;
        }
    }
    NSRange highlightRange = {0};
    YYTextHighlight *highlight = [_innerText attribute:YYTextHighlightAttributeName
                                               atIndex:startIndex
                                 longestEffectiveRange:&highlightRange
                                               inRange:NSMakeRange(0, _innerText.length)];
    
    if (!highlight) return nil;
    if (range) *range = highlightRange;
    return highlight;
}

- (void)_showHighlightAnimated:(BOOL)animated {
    if (!_highlight) return;
    if (!_highlightLayout) {
        NSMutableAttributedString *hiText = _innerText.mutableCopy;
        NSDictionary *newAttrs = _highlight.attributes;
        [newAttrs enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [hiText setAttribute:key value:value range:_highlightRange];
        }];
        _highlightLayout = [YYTextLayout layoutWithContainer:_innerContainer text:hiText];
        if (!_highlightLayout) _highlight = nil;
    }
    
    if (_highlightLayout && !_state.showingHighlight) {
        _state.showingHighlight = YES;
        _state.contentsNeedFade = animated;
        [self _setLayoutNeedRedraw];
    }
}

- (void)_hideHighlightAnimated:(BOOL)animated {
    if (_state.showingHighlight) {
        _state.showingHighlight = NO;
        _state.contentsNeedFade = animated;
        [self _setLayoutNeedRedraw];
    }
}

- (void)_removeHighlightAnimated:(BOOL)animated {
    [self _hideHighlightAnimated:animated];
    _highlight = nil;
    _highlightLayout = nil;
}

- (void)_endTouch {
    [self _endLongPressTimer];
    [self _removeHighlightAnimated:YES];
    _state.trackingTouch = NO;
}

- (CGPoint)_convertPointToLayout:(CGPoint)point {
    CGSize boundingSize = _innerLayout.textBoundingSize;
    if (_innerLayout.container.isVerticalForm) {
        CGFloat w = _innerLayout.textBoundingSize.width;
        if (w < self.bounds.size.width) w = self.bounds.size.width;
        point.x += _innerLayout.container.size.width - w;
        if (_textVerticalAlignment == YYTextVerticalAlignmentCenter) {
            point.x += (self.bounds.size.width - boundingSize.width) * 0.5;
        } else if (_textVerticalAlignment == YYTextVerticalAlignmentBottom) {
            point.x += (self.bounds.size.width - boundingSize.width);
        }
        return point;
    } else {
        if (_textVerticalAlignment == YYTextVerticalAlignmentCenter) {
            point.y -= (self.bounds.size.height - boundingSize.height) * 0.5;
        } else if (_textVerticalAlignment == YYTextVerticalAlignmentBottom) {
            point.y -= (self.bounds.size.height - boundingSize.height);
        }
        return point;
    }
}

- (CGPoint)_convertPointFromLayout:(CGPoint)point {
    CGSize boundingSize = _innerLayout.textBoundingSize;
    if (_innerLayout.container.isVerticalForm) {
        CGFloat w = _innerLayout.textBoundingSize.width;
        if (w < self.bounds.size.width) w = self.bounds.size.width;
        point.x -= _innerLayout.container.size.width - w;
        if (boundingSize.width < self.bounds.size.width) {
            if (_textVerticalAlignment == YYTextVerticalAlignmentCenter) {
                point.x -= (self.bounds.size.width - boundingSize.width) * 0.5;
            } else if (_textVerticalAlignment == YYTextVerticalAlignmentBottom) {
                point.x -= (self.bounds.size.width - boundingSize.width);
            }
        }
        return point;
    } else {
        if (boundingSize.height < self.bounds.size.height) {
            if (_textVerticalAlignment == YYTextVerticalAlignmentCenter) {
                point.y += (self.bounds.size.height - boundingSize.height) * 0.5;
            } else if (_textVerticalAlignment == YYTextVerticalAlignmentBottom) {
                point.y += (self.bounds.size.height - boundingSize.height);
            }
        }
        return point;
    }
}

- (CGRect)_convertRectToLayout:(CGRect)rect {
    rect.origin = [self _convertPointToLayout:rect.origin];
    return rect;
}

- (CGRect)_convertRectFromLayout:(CGRect)rect {
    rect.origin = [self _convertPointFromLayout:rect.origin];
    return rect;
}

- (UIFont *)_defaultFont {
    return [UIFont systemFontOfSize:17];
}

- (NSShadow *)_shadowFromProperties {
    if (!_shadowColor || _shadowBlurRadius < 0) return nil;
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = _shadowColor;
    shadow.shadowOffset = _shadowOffset;
    shadow.shadowBlurRadius = _shadowBlurRadius;
    return shadow;
}

- (void)_updateOuterLineBreakMode {
    if (_innerContainer.truncationType) {
        switch (_innerContainer.truncationType) {
            case YYTextTruncationTypeStart: {
                _lineBreakMode = NSLineBreakByTruncatingHead;
            } break;
            case YYTextTruncationTypeEnd: {
                _lineBreakMode = NSLineBreakByTruncatingTail;
            } break;
            case YYTextTruncationTypeMiddle: {
                _lineBreakMode = NSLineBreakByTruncatingMiddle;
            } break;
            default:break;
        }
    } else {
        _lineBreakMode = _innerText.lineBreakMode;
    }
}

- (void)_updateOuterTextProperties {
    _text = [_innerText plainTextForRange:NSMakeRange(0, _innerText.length)];
    _font = _innerText.font;
    _textColor = _innerText.color;
    _textAlignment = _innerText.alignment;
    _lineBreakMode = _innerText.lineBreakMode;
    NSShadow *shadow = _innerText.shadow;
    _shadowColor = shadow.shadowColor;
    _shadowOffset = shadow.shadowOffset;
    _shadowBlurRadius = shadow.shadowBlurRadius;
    _attributedText = _innerText;
    [self _updateOuterLineBreakMode];
}

- (void)_updateOuterContainerProperties {
    _truncationToken = _innerContainer.truncationToken;
    _numberOfLines = _innerContainer.maximumNumberOfRows;
    _textContainerPath = _innerContainer.path;
    _exclusionPaths = _innerContainer.exclusionPaths;
    _textContainerInset = _innerContainer.insets;
    _verticalForm = _innerContainer.verticalForm;
    _linePositionModifier = _innerContainer.linePositionModifier;
    [self _updateOuterLineBreakMode];
}

- (void)_clearContents {
    CGImageRef image = (__bridge_retained CGImageRef)(self.layer.contents);
    self.layer.contents = nil;
    if (image) {
        dispatch_async(YYLabelGetReleaseQueue(), ^{
            CFRelease(image);
        });
    }
}

- (void)_initLabel {
    ((YYAsyncLayer *)self.layer).displaysAsynchronously = NO;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.contentMode = UIViewContentModeRedraw;
    
    _attachmentViews = [NSMutableArray new];
    _attachmentLayers = [NSMutableArray new];
    
    _debugOption = [YYTextDebugOption sharedDebugOption];
    [YYTextDebugOption addDebugTarget:self];
    
    _textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _numberOfLines = 1;
    _lineBreakMode = NSLineBreakByTruncatingTail;
    _innerText = [NSMutableAttributedString new];
    _innerContainer = [YYTextContainer new];
    _innerContainer.truncationType = YYTextTruncationTypeEnd;
    _innerContainer.maximumNumberOfRows = _numberOfLines;
    _clearContentsBeforeAsynchronouslyDisplay = YES;
    _fadeOnAsynchronouslyDisplay = YES;
    _fadeOnHighlight = YES;
    
    self.isAccessibilityElement = YES;
}

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    [self _initLabel];
    self.frame = frame;
    return self;
}

- (void)dealloc {
    [YYTextDebugOption removeDebugTarget:self];
    [_longPressTimer invalidate];
}

+ (Class)layerClass {
    return [YYAsyncLayer class];
}

- (void)setFrame:(CGRect)frame {
    CGSize oldSize = self.bounds.size;
    [super setFrame:frame];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        _innerContainer.size = self.bounds.size;
        if (!_ignoreCommonProperties) {
            _state.layoutNeedUpdate = YES;
        }
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedRedraw];
    }
}

- (void)setBounds:(CGRect)bounds {
    CGSize oldSize = self.bounds.size;
    [super setBounds:bounds];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        _innerContainer.size = self.bounds.size;
        if (!_ignoreCommonProperties) {
            _state.layoutNeedUpdate = YES;
        }
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedRedraw];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self _updateIfNeeded];
    if (!_innerLayout) return size;
    return [_innerLayout textBoundingSize];
}

- (NSString *)accessibilityLabel {
    return [_innerLayout.text plainTextForRange:_innerLayout.text.rangeOfAll];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_attributedText forKey:@"attributedText"];
    [aCoder encodeObject:_innerContainer forKey:@"innerContainer"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self _initLabel];
    YYTextContainer *innerContainer = [aDecoder decodeObjectForKey:@"innerContainer"];
    if (innerContainer) _innerContainer = innerContainer;
    [self _updateOuterContainerProperties];
    self.attributedText = [aDecoder decodeObjectForKey:@"attributedText"];
    [self _setLayoutNeedUpdate];
    return self;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _updateIfNeeded];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    _highlight = [self _getHighlightAtPoint:point range:&_highlightRange];
    _highlightLayout = nil;
    
    if (_highlight) {
        _touchBeganPoint = point;
        _state.trackingTouch = YES;
        _state.swallowTouch = YES;
        _state.touchMoved = NO;
        [self _startLongPressTimer];
        [self _showHighlightAnimated:NO];
    } else {
        _state.trackingTouch = NO;
        _state.swallowTouch = NO;
        _state.touchMoved = NO;
    }
    if (!_state.swallowTouch) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _updateIfNeeded];
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    if (_state.trackingTouch) {
        if (!_state.touchMoved) {
            CGFloat moveH = point.x - _touchBeganPoint.x;
            CGFloat moveV = point.y - _touchBeganPoint.y;
            if (fabs(moveH) > fabs(moveV)) {
                if (fabs(moveH) > kLongPressAllowableMovement) _state.touchMoved = YES;
            } else {
                if (fabs(moveV) > kLongPressAllowableMovement) _state.touchMoved = YES;
            }
            if (_state.touchMoved) {
                [self _endLongPressTimer];
            }
        }
        if (_state.touchMoved) {
            YYTextHighlight *highlight = [self _getHighlightAtPoint:point range:NULL];
            if (highlight == _highlight) {
                [self _showHighlightAnimated:_fadeOnHighlight];
            } else {
                [self _hideHighlightAnimated:_fadeOnHighlight];
            }
        }
    }
    
    if (!_state.swallowTouch) {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    if (_state.trackingTouch) {
        [self _endLongPressTimer];
        if (!_state.touchMoved || [self _getHighlightAtPoint:point range:NULL] == _highlight) {
            YYTextAction tapAction = _highlight.tapAction ? _highlight.tapAction : _highlightTapAction;
            if (tapAction) {
                CGRect rect = [_innerLayout rectForRange:[YYTextRange rangeWithRange:_highlightRange]];
                rect = [self _convertRectFromLayout:rect];
                tapAction(self, _innerText, _highlightRange, rect);
            }
        }
        [self _removeHighlightAnimated:_fadeOnHighlight];
    }
    
    if (!_state.swallowTouch) {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _endTouch];
    if (!_state.swallowTouch) [super touchesCancelled:touches withEvent:event];
}

#pragma mark - Properties

- (void)setText:(NSString *)text {
    if (_text == text || [_text isEqualToString:text]) return;
    _text = text.copy;
    BOOL needAddAttributes = _innerText.length == 0 && text.length > 0;
    [_innerText replaceCharactersInRange:NSMakeRange(0, _innerText.length) withString:text ? text : @""];
    if (needAddAttributes) {
        _innerText.font = _font ? _font : [self _defaultFont];
        _innerText.color = _textColor;
        _innerText.shadow = [self _shadowFromProperties];
        _innerText.alignment = _textAlignment;
        switch (_lineBreakMode) {
            case NSLineBreakByWordWrapping:
            case NSLineBreakByCharWrapping:
            case NSLineBreakByClipping: {
                _innerText.lineBreakMode = _lineBreakMode;
            } break;
            case NSLineBreakByTruncatingHead:
            case NSLineBreakByTruncatingTail:
            case NSLineBreakByTruncatingMiddle: {
                _innerText.lineBreakMode = NSLineBreakByWordWrapping;
            } break;
            default: break;
        }
    }
    if ([_textParser parseText:_innerText selectedRange:NULL]) {
        [self _updateOuterTextProperties];
    }
    if (!_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setFont:(UIFont *)font {
    if (_font == font || [_font isEqual:font]) return;
    _font = font;
    _innerText.font = _font ? _font : [self _defaultFont];
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor || [_textColor isEqual:textColor]) return;
    _textColor = textColor;
    _innerText.color = textColor;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
    }
}

- (void)setShadowColor:(UIColor *)shadowColor {
    if (_shadowColor == shadowColor || [_shadowColor isEqual:shadowColor]) return;
    _shadowColor = shadowColor;
    _innerText.shadow = [self _shadowFromProperties];
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
    }
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    if (CGSizeEqualToSize(_shadowOffset, shadowOffset)) return;
    _shadowOffset = shadowOffset;
    _innerText.shadow = [self _shadowFromProperties];
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
    }
}

- (void)setShadowBlurRadius:(CGFloat)shadowBlurRadius {
    if (_shadowBlurRadius == shadowBlurRadius) return;
    _shadowBlurRadius = shadowBlurRadius;
    _innerText.shadow = [self _shadowFromProperties];
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment == textAlignment) return;
    _textAlignment = textAlignment;
    _innerText.alignment = textAlignment;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (_lineBreakMode == lineBreakMode) return;
    _lineBreakMode = lineBreakMode;
    _innerText.lineBreakMode = lineBreakMode;
    // allow multi-line break
    switch (lineBreakMode) {
        case NSLineBreakByWordWrapping:
        case NSLineBreakByCharWrapping:
        case NSLineBreakByClipping: {
            _innerContainer.truncationType = YYTextTruncationTypeNone;
            _innerText.lineBreakMode = lineBreakMode;
        } break;
        case NSLineBreakByTruncatingHead:{
            _innerContainer.truncationType = YYTextTruncationTypeStart;
            _innerText.lineBreakMode = NSLineBreakByWordWrapping;
        } break;
        case NSLineBreakByTruncatingTail:{
            _innerContainer.truncationType = YYTextTruncationTypeEnd;
            _innerText.lineBreakMode = NSLineBreakByWordWrapping;
        } break;
        case NSLineBreakByTruncatingMiddle: {
            _innerContainer.truncationType = YYTextTruncationTypeMiddle;
            _innerText.lineBreakMode = NSLineBreakByWordWrapping;
        } break;
        default: break;
    }
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setTextVerticalAlignment:(YYTextVerticalAlignment)textVerticalAlignment {
    if (_textVerticalAlignment == textVerticalAlignment) return;
    _textVerticalAlignment = textVerticalAlignment;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setTruncationToken:(NSAttributedString *)truncationToken {
    if (_truncationToken == truncationToken || [_truncationToken isEqual:truncationToken]) return;
    _truncationToken = truncationToken.copy;
    _innerContainer.truncationToken = truncationToken;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    if (_numberOfLines == numberOfLines) return;
    _numberOfLines = numberOfLines;
    _innerContainer.maximumNumberOfRows = numberOfLines;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (attributedText.length > 0) {
        _innerText = attributedText.mutableCopy;
        switch (_lineBreakMode) {
            case NSLineBreakByWordWrapping:
            case NSLineBreakByCharWrapping:
            case NSLineBreakByClipping: {
                _innerText.lineBreakMode = _lineBreakMode;
            } break;
            case NSLineBreakByTruncatingHead:
            case NSLineBreakByTruncatingTail:
            case NSLineBreakByTruncatingMiddle: {
                _innerText.lineBreakMode = NSLineBreakByWordWrapping;
            } break;
            default: break;
        }
    } else {
        _innerText = [NSMutableAttributedString new];
    }
    [_textParser parseText:_innerText selectedRange:NULL];
    if (!_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _updateOuterTextProperties];
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setTextContainerPath:(UIBezierPath *)textContainerPath {
    if (_textContainerPath == textContainerPath || [_textContainerPath isEqual:textContainerPath]) return;
    _textContainerPath = textContainerPath.copy;
    _innerContainer.path = textContainerPath;
    if (!_textContainerPath) {
        _innerContainer.size = self.bounds.size;
        _innerContainer.insets = _textContainerInset;
    }
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setExclusionPaths:(NSArray *)exclusionPaths {
    if (_exclusionPaths == exclusionPaths || [_exclusionPaths isEqual:exclusionPaths]) return;
    _exclusionPaths = exclusionPaths.copy;
    _innerContainer.exclusionPaths = exclusionPaths;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    if (UIEdgeInsetsEqualToEdgeInsets(_textContainerInset, textContainerInset)) return;
    _textContainerInset = textContainerInset;
    _innerContainer.insets = textContainerInset;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setVerticalForm:(BOOL)verticalForm {
    if (_verticalForm == verticalForm) return;
    _verticalForm = verticalForm;
    _innerContainer.verticalForm = verticalForm;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setLinePositionModifier:(id<YYTextLinePositionModifier>)linePositionModifier {
    if (_linePositionModifier == linePositionModifier) return;
    _linePositionModifier = linePositionModifier;
    _innerContainer.linePositionModifier = linePositionModifier;
    if (_innerText.length && !_ignoreCommonProperties) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self _clearContents];
        }
        [self _setLayoutNeedUpdate];
        [self _endTouch];
    }
}

- (void)setTextParser:(id<YYTextParser>)textParser {
    if (_textParser == textParser || [_textParser isEqual:textParser]) return;
    _textParser = textParser;
    if ([_textParser parseText:_innerText selectedRange:NULL]) {
        [self _updateOuterTextProperties];
        if (!_ignoreCommonProperties) {
            if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
                [self _clearContents];
            }
            [self _setLayoutNeedUpdate];
            [self _endTouch];
        }
    }
}

- (void)setTextLayout:(YYTextLayout *)textLayout {
    _innerLayout = textLayout;
    
    if (_ignoreCommonProperties) {
        _innerText = (NSMutableAttributedString *)textLayout.text;
        _innerContainer = textLayout.container.copy;
    } else {
        _innerText = textLayout.text.mutableCopy;
        if (!_innerText) {
            _innerText = [NSMutableAttributedString new];
        }
        [self _updateOuterTextProperties];
        
        _innerContainer = textLayout.container.copy;
        if (!_innerContainer) {
            _innerContainer = [YYTextContainer new];
            _innerContainer.size = self.bounds.size;
            _innerContainer.insets = self.textContainerInset;
        }
        [self _updateOuterContainerProperties];
    }
    
    if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
        [self _clearContents];
    }
    _state.layoutNeedUpdate = NO;
    [self _setLayoutNeedRedraw];
    [self _endTouch];
}

- (YYTextLayout *)textLayout {
    [self _updateIfNeeded];
    return _innerLayout;
}

- (void)setDebugOption:(YYTextDebugOption *)debugOption {
    BOOL needDraw = _debugOption.needDrawDebug;
    _debugOption = debugOption.copy;
    if (_debugOption.needDrawDebug != needDraw) {
        [self _setLayoutNeedRedraw];
    }
}

- (void)setDisplaysAsynchronously:(BOOL)displaysAsynchronously {
    _displaysAsynchronously = displaysAsynchronously;
    ((YYAsyncLayer *)self.layer).displaysAsynchronously = displaysAsynchronously;
}

#pragma mark - YYAsyncLayerDelegate

- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    
    // capture current context
    BOOL contentsNeedFade = _state.contentsNeedFade;
    NSAttributedString *text = _innerText;
    YYTextContainer *container = _innerContainer;
    YYTextVerticalAlignment verticalAlignment = _textVerticalAlignment;
    YYTextDebugOption *debug = _debugOption;
    NSMutableArray *attachmentViews = _attachmentViews;
    NSMutableArray *attachmentLayers = _attachmentLayers;
    BOOL layoutNeedUpdate = _state.layoutNeedUpdate;
    BOOL fadeForAsync = _displaysAsynchronously && _fadeOnAsynchronouslyDisplay;
    __block YYTextLayout *layout = (_state.showingHighlight && _highlightLayout) ? _highlightLayout : _innerLayout;
    __block BOOL layoutUpdated = NO;
    if (layoutNeedUpdate) {
        text = text.copy;
        container = container.copy;
    }
    
    // create display task
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    
    task.willDisplay = ^(CALayer *layer) {
        [layer removeAnimationForKey:@"contents"];
        
        // If the attachment is not in new layout, or we don't know the new layout currently,
        // the attachment should be removed.
        for (UIView *view in attachmentViews) {
            if (layoutNeedUpdate || ![layout.attachmentContentsSet containsObject:view]) {
                if (view.superview == self) {
                    [view removeFromSuperview];
                }
            }
        }
        for (CALayer *layer in attachmentLayers) {
            if (layoutNeedUpdate || ![layout.attachmentContentsSet containsObject:layer]) {
                if (layer.superlayer == self.layer) {
                    [layer removeFromSuperlayer];
                }
            }
        }
        [attachmentViews removeAllObjects];
        [attachmentLayers removeAllObjects];
    };

    task.display = ^(CGContextRef context, CGSize size, BOOL (^isCancelled)(void)) {
        if (isCancelled()) return;
        if (text.length == 0) return;
        
        if (layoutNeedUpdate) {
            layout = [YYTextLayout layoutWithContainer:container text:text];
            if (isCancelled()) return;
            layoutUpdated = YES;
        }
        
        CGSize boundingSize = layout.textBoundingSize;
        CGPoint point = CGPointZero;
        if (verticalAlignment == YYTextVerticalAlignmentCenter) {
            if (layout.container.isVerticalForm) {
                point.x = (size.width - boundingSize.width) * 0.5;
            } else {
                point.y = (size.height - boundingSize.height) * 0.5;
            }
        } else if (verticalAlignment == YYTextVerticalAlignmentBottom) {
            if (layout.container.isVerticalForm) {
                point.x = (size.width - boundingSize.width);
            } else {
                point.y = (size.height - boundingSize.height);
            }
        }
        point = CGPointPixelRound(point);
        [layout drawInContext:context size:size point:point view:nil layer:nil debug:debug cancel:isCancelled];
    };

    task.didDisplay = ^(CALayer *layer, BOOL finished) {
        if (!finished) {
            // If the display task is cancelled, we should clear the attachments.
            for (YYTextAttachment *a in layout.attachments) {
                if ([a.content isKindOfClass:[UIView class]]) {
                    if (((UIView *)a.content).superview == layer.delegate) {
                        [((UIView *)a.content) removeFromSuperview];
                    }
                } else if ([a.content isKindOfClass:[CALayer class]]) {
                    if (((CALayer *)a.content).superlayer == layer) {
                        [((CALayer *)a.content) removeFromSuperlayer];
                    }
                }
            }
            return;
        }
        [layer removeAnimationForKey:@"contents"];
        
        YYLabel *view = layer.delegate;
        if (!view) return;
        if (view->_state.layoutNeedUpdate && layoutUpdated) {
            view->_innerLayout = layout;
            view->_state.layoutNeedUpdate = NO;
        }
        
        CGSize size = layer.bounds.size;
        CGSize boundingSize = layout.textBoundingSize;
        CGPoint point = CGPointZero;
        if (verticalAlignment == YYTextVerticalAlignmentCenter) {
            if (layout.container.isVerticalForm) {
                point.x = -(size.width - boundingSize.width) * 0.5;
            } else {
                point.y = (size.height - boundingSize.height) * 0.5;
            }
        } else if (verticalAlignment == YYTextVerticalAlignmentBottom) {
            if (layout.container.isVerticalForm) {
                point.x = -(size.width - boundingSize.width);
            } else {
                point.y = (size.height - boundingSize.height);
            }
        }
        point = CGPointPixelRound(point);
        [layout drawInContext:nil size:CGSizeZero point:point view:view layer:layer debug:nil cancel:NULL];
        for (YYTextAttachment *a in layout.attachments) {
            if ([a.content isKindOfClass:[UIView class]]) [attachmentViews addObject:a.content];
            else if ([a.content isKindOfClass:[CALayer class]]) [attachmentLayers addObject:a.content];
        }
        
        if (contentsNeedFade) {
            CATransition *transition = [CATransition animation];
            transition.duration = kHighlightFadeDuration;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            transition.type = kCATransitionFade;
            [layer addAnimation:transition forKey:@"contents"];
        } else if (fadeForAsync) {
            CATransition *transition = [CATransition animation];
            transition.duration = kAsyncFadeDuration;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            transition.type = kCATransitionFade;
            [layer addAnimation:transition forKey:@"contents"];
        }
    };
    
    return task;
}

@end
