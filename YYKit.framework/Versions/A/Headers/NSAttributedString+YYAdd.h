//
//  NSAttributedString+RVAdd.h
//  TestCoreText
//
//  Created by ibireme on 14-5-21.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

/**
 Wrapper methods for CoreText.
 */
@interface NSMutableAttributedString (YYAdd)


#pragma mark - Set Any Attributes
///=============================================================================
/// @name Set Any Attributes
///=============================================================================

/**
 Sets the attributes for the characters.
 
 @param key   The attribute key.
 
 @param value The attribute value, pass nil or NSNullto remove the attribute.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setAttributeKey:(NSString *)key value:(id)value range:(NSRange)range;

/**
 Remove all attribltes in range.
 
 @param range  The range. Raises an NSRangeException if the range is invalid.
 */
- (void)removeAllAttributesInRange:(NSRange)range;


#pragma mark - Set Character Attributes
///=============================================================================
/// @name Set Character Attributes
///=============================================================================

/**
 The font of the text to which this attribute applies.
 Default is Helvetica 12.
 
 @param font  The font. Pass nil to remove the attribute.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setFont:(UIFont *)font range:(NSRange)range;

/**
 The foreground color of the text to which this attribute applies.
 Default is black.
 
 @param color The color. Pass nil to remove the attribute.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setColor:(UIColor *)color range:(NSRange)range;

/**
 Weather sets a foreground color using the context's fill color.
 Default is NO.
 
 @discussion  The reason this exists is because an NSAttributedString object
 defaults to a black color if no color attribute is set. This forces Core Text
 to set the color in the context. This attribute allows developers to sidestep
 this, making Core Text set nothing but font information in the CGContext.
 If set, this attribute also determines the color used by
 UnderlineStyleAttributeName, in which case it overrides the foreground color.
 
 @param value Whether the font color is from context.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setColorFromContext:(BOOL)value range:(NSRange)range;

/**
 The amount to kern the next character.. Default is 0pt.
 
 @discussion The kerning attribute indicates how many points the following
 character should be shifted from its default offset as defined by the current
 character's font in points: a positive kern indicates a shift farther away from
 and a negative kern indicates a shift closer to the current character. If this
 attribute is not present, standard kerning is used. If this attribute is set
 to 0.0, no kerning is done at all.
 
 @param kern  Positive to add kern, negative to reduce kern.
 
 @param range The Range. Raises an NSRangeException if the range is invalid.
 */
- (void)setKern:(CGFloat)kern range:(NSRange)range;

/**
 The type of ligatures to use. Default is LigatureStandard.
 
 @discussion Which ligatures are standard depends on the script and possibly the
 font. Arabic text, for example, requires ligatures for many character sequences
 but has a rich set of additional ligatures that combine characters. English
 text has no essential ligatures, and typically has only two standard ligatures,
 those for "fi" and "fl"—all others are considered more advanced or fancy.
 
 @param ligature The ligature enum.
 
 @param range    The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setLigature:(YYTextLigature)ligature range:(NSRange)range;

/**
 The stroke width. Default value is 0.0.
 
 @discussion This attribute, interpreted as a percentage of font point size,
 controls the text drawing mode: positive values effect drawing with stroke only;
 negative values are for stroke and fill. A typical value for outlined text is 3.0.
 
 @param width Positive make the text hollow, negative make fill and stroke.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range;

/**
 The stroke color. Default is the foreground color.
 
 @param color The color. Pass nil to remove the attribute.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setStrokeColor:(UIColor *)color range:(NSRange)range;

/**
 The underline color. Default is the foreground color.
 
 @param color The color. Pass nil to remove the attribute.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setUnderlineColor:(UIColor *)color range:(NSRange)range;

/**
 The style of underlining, to be applied at render time, for the text to which
 this attribute applies. Default is UnderlineStyleNone.
 
 @discussion Set a value of something other than UnderlineStyleNone to draw an
 underline. The underline color is determined by the text's foreground color.
 
 @param style The style option.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setUnderlineStyle:(YYTextUnderlineStyle)style range:(NSRange)range;

/**
 Controls vertical text positioning. Default value is NO.
 
 @discussion  If supported by the specified font, a value of YES enables
 superscripting. This valud is conflict with setSubscript:range:.
 
 @param value YES or NO.
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setSuperscript:(BOOL)value range:(NSRange)range;

/**
 Controls vertical text positioning. Default value is NO.
 
 @discussion  If supported by the specified font, a value of YES enables
 subscripting. This valud is conflict with setSuperscript:range:.
 
 @param value YES or NO.
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setSubscript:(BOOL)value range:(NSRange)range;

/**
 The orientation of the glyphs in the text to which this attribute applies.
 Default value is NO.
 
 @param value NO indicates that horizontal glyph forms are to be used;
 YES indicates that vertical glyph forms are to be used (left rotate 90°).
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setVerticalForms:(BOOL)value range:(NSRange)range;

/**
 Specifies text language. Default is unset.
 
 @discussion When this attribute is set to a valid identifier, it will
 be used to select localized glyphs (if supported by the font) and
 locale-specific line breaking rules.
 
 @param language An NSString containing a locale identifier.
 
 @param range    The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setLanguage:(NSString *)language range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The glyph info object to apply to the text associated with this attribute.
 
 @discussion  The glyph specified by this CTGlyphInfo object is assigned to the
 entire attribute range, provided that its contents match the specified base
 string and that the specified glyph is available in the font specified by
 FontAttributeName. See CTGlyphInfo Reference for more information.
 
 @param glyphInfo The glyphInfo. Pass nil to remove the attribute.
 
 @param range     The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setGlyphInfo:(CTGlyphInfoRef)glyphInfo range:(NSRange)range;

/**
 The run-delegate object to apply to an attribute range of the string.
 
 @discussion The run delegate controls such typographic traits as glyph ascent,
 descent, and width. The values returned by the embedded run delegate apply to
 each glyph resulting from the text in that range. Because an embedded object is
 only a display-time modification, you should avoid applying this attribute to a
 range of text with complex behavior, such as text having a change of writing
 direction or having combining marks. It is thus recommended you apply this
 attribute to a range containing the single character U+FFFC. See CTRunDelegate
 Reference for more information.
 
 @param runDelegate  The RunDelegate. Pass nil to remove the attribute.
 
 @param range        The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range;


#pragma mark - Set Paragraph Attributes
///=============================================================================
/// @name Set Paragraph Attributes
///=============================================================================

/**
 The paragraph style of the text to which this attribute applies.
 
 @discussion A paragraph style object is used to specify things like line
 alignment, tab rulers, writing direction, and so on. Default is an empty
 ParagraphStyle object. When use CoreText, pass a CTParagraphStyleRef object,
 When use NSText, pass an NSParagraphStyle object.
 
 @param style a NSParagraphStyle or CTParagraphStyleRef object.
 Pass nil to remove the attribute.
 
 @param range The range. Raises an NSRangeException if the range is invalid.
 */
- (void)setParaStyle:(id)style range:(NSRange)range;

@end
