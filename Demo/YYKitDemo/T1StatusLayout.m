//
//  T1StatusLayout.m
//  YYKitExample
//
//  Created by guoyaoyuan on 15/10/10.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "T1StatusLayout.h"
#import "T1Helper.h"

@implementation T1StatusLayout

- (void)setTweet:(T1Tweet *)tweet {
    if (_tweet != tweet) {
        _tweet = tweet;
        [self layout];
    }
}

- (void)layout {
    [self reset];
    if (!_tweet) {
        if (_conversation) {
            _isConversationSplit = YES;
            _height = kT1ConversationSplitHeight;
            return;
        } else {
            return;
        }
    }
    
    if (_conversation) {
        BOOL isTop = NO, isBottom = NO;
        if (_tweet.tidStr) {
            NSUInteger index = [_conversation.contextIDs indexOfObject:_tweet.tidStr];
            if (index == 0) {
                isTop = YES;
            } else if (index + 1 == _conversation.contextIDs.count) {
                isBottom = YES;
            }
        }
        
        if (isTop) {
            _showTopLine = YES;
            _showConversationBottomJoin = YES;
        } else if (isBottom) {
            _showConversationTopJoin = YES;
        } else {
            _showConversationTopJoin = YES;
            _showConversationBottomJoin = YES;
        }
    } else {
        _showTopLine = YES;
    }
    
    T1Tweet *tweet = self.displayedTweet;
    
    UIFont *nameSubFont = [UIFont systemFontOfSize:kT1UserNameSubFontSize];
    NSMutableAttributedString *dateText = [[NSMutableAttributedString alloc] initWithString:[T1Helper stringWithTimelineDate:tweet.createdAt]];
    
    if (tweet.card) {
        UIImage *iconImage = [T1Helper imageNamed:@"ic_tweet_attr_summary_default"];
        NSAttributedString *icon = [NSAttributedString attachmentStringWithContent:iconImage contentMode:UIViewContentModeCenter attachmentSize:iconImage.size alignToFont:nameSubFont alignment:YYTextVerticalAlignmentCenter];
        [dateText insertString:@" " atIndex:0];
        [dateText insertAttributedString:icon atIndex:0];
    }
    dateText.font = nameSubFont;
    dateText.color = kT1UserNameSubColor;
    dateText.alignment = NSTextAlignmentRight;
    
    _dateTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kT1ContentWidth, kT1UserNameSubFontSize * 2) text:dateText];
    
    
    UIFont *nameFont = [UIFont systemFontOfSize:kT1UserNameFontSize];
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:(tweet.user.name ? tweet.user.name : @"")];
    nameText.font = nameFont;
    nameText.color = kT1UserNameColor;
    if (tweet.user.screenName) {
        NSMutableAttributedString *screenNameText = [[NSMutableAttributedString alloc] initWithString:tweet.user.screenName];
        [screenNameText insertString:@" @" atIndex:0];
        screenNameText.font = nameSubFont;
        screenNameText.color = kT1UserNameSubColor;
        [nameText appendAttributedString:screenNameText];
    }
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(kT1ContentWidth - _dateTextLayout.textBoundingRect.size.width - 5, kT1UserNameFontSize * 2)];
    nameContainer.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
    
    
    NSString *socialString = nil;
    if (_tweet.retweetedStatus) {
        if (_tweet.user.name) {
            socialString = [NSString stringWithFormat:@"%@ Retweeted",_tweet.user.name];
        }
    } else if (tweet.inReplyToScreenName) {
        socialString = [NSString stringWithFormat:@"in reply to @%@",tweet.inReplyToScreenName];
    }
    
    if (socialString) {
        NSMutableAttributedString *socialText = [[NSMutableAttributedString alloc] initWithString:socialString];
        socialText.font = nameSubFont;
        socialText.color = kT1UserNameSubColor;
        socialText.lineBreakMode = NSLineBreakByCharWrapping;
        YYTextContainer *socialContainer = [YYTextContainer containerWithSize:CGSizeMake(kT1ContentWidth, kT1UserNameFontSize * 2)];
        socialContainer.maximumNumberOfRows = 1;
        _socialTextLayout = [YYTextLayout layoutWithContainer:socialContainer text:socialText];
    }
    
    YYTextContainer *textContainer = [YYTextContainer containerWithSize:CGSizeMake(kT1ContentWidth + 2 * kT1TextContainerInset, CGFLOAT_MAX)];
    textContainer.insets = UIEdgeInsetsMake(0, kT1TextContainerInset, 0, kT1TextContainerInset);
    _textLayout = [YYTextLayout layoutWithContainer:textContainer text:[self textForTweet:tweet]];
    
    if (tweet.medias.count || tweet.extendedMedias.count) {
        NSMutableArray *images = [NSMutableArray new];
        NSMutableSet *imageIDs = [NSMutableSet new];
        
        for (T1Media *media in tweet.medias) {
            if ([media.type isEqualToString:@"photo"]) {
                if (media.mediaSmall && media.mediaLarge) {
                    if (media.midStr && ![imageIDs containsObject:media.midStr]) {
                        [images addObject:media];
                        [imageIDs addObject:media.midStr];
                    }
                }
            }
        }
        
        for (T1Media *media in tweet.extendedMedias) {
            if ([media.type isEqualToString:@"photo"]) {
                if (media.mediaSmall && media.mediaLarge) {
                    if (media.midStr && ![imageIDs containsObject:media.midStr]) {
                        [images addObject:media];
                        [imageIDs addObject:media.midStr];
                    }
                }
            }
        }
        
        while (images.count > 4) {
            [images removeLastObject];
        }
        if (images.count > 0) {
            _images = images;
        }
    }
    
    
    if (!_images && !_tweet.retweetedStatus && _tweet.quotedStatus) {
        T1Tweet *quote = _tweet.quotedStatus;
        NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:(quote.user.name ? quote.user.name : @"")];
        nameText.font = nameFont;
        nameText.color = kT1UserNameColor;
        if (quote.user.screenName) {
            NSMutableAttributedString *screenNameText = [[NSMutableAttributedString alloc] initWithString:quote.user.screenName];
            [screenNameText insertString:@" @" atIndex:0];
            screenNameText.font = nameSubFont;
            screenNameText.color = kT1UserNameSubColor;
            [nameText appendAttributedString:screenNameText];
        }
        nameText.lineBreakMode = NSLineBreakByCharWrapping;
        
        YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(kT1QuoteContentWidth, kT1UserNameFontSize * 2)];
        nameContainer.maximumNumberOfRows = 1;
        _quotedNameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
        
        NSAttributedString *quoteText = [self textForTweet:quote];
        _quotedTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kT1QuoteContentWidth, CGFLOAT_MAX) text:quoteText];
    }
    
    _retweetCountTextLayout = [self retweetCountTextLayoutForTweet:tweet];
    _favoriteCountTextLayout = [self favoriteCountTextLayoutForTweet:tweet];
    
    if (_socialTextLayout) {
        _paddingTop = kT1CellExtendedPadding;
    } else {
        _paddingTop = kT1CellPadding;
    }
    
    _textTop = _paddingTop + kT1UserNameFontSize + kT1CellInnerPadding;
    _textHeight = _textLayout ? (CGRectGetMaxY(_textLayout.textBoundingRect)) : 0;
    _imagesTop = _quoteTop = _textTop + _textHeight + kT1CellInnerPadding;
    if (_images) {
        _imagesHeight = kT1ContentWidth * (9.0 / 16.0);
    } else if (_quotedTextLayout) {
        _quoteHeight = 2 * kT1CellPadding + kT1UserNameFontSize + CGRectGetMaxY(_quotedTextLayout.textBoundingRect);
    }
    
    CGFloat height = 0;
    if (_imagesHeight > 0) {
        height = _imagesTop + _imagesHeight;
    } else if (_quoteHeight > 0) {
        height = _quoteTop + _quoteHeight;
    } else {
        height = _textTop + _textHeight;
    }
    height += kT1ActionsHeight;
    if (height < _paddingTop + kT1AvatarSize) {
        height = _paddingTop + kT1AvatarSize;
    }
    height += kT1CellExtendedPadding;
    _height = height;
}

- (void)reset {
    _height = 0;
    _paddingTop = 0;
    _textTop = 0;
    _textHeight = 0;
    _imagesTop = 0;
    _imagesHeight = 0;
    _quoteTop = 0;
    _quoteHeight = 0;
    
    _showTopLine = NO;
    _isConversationSplit = NO;
    _showConversationTopJoin = NO;
    _showConversationBottomJoin = NO;
    _socialTextLayout = nil;
    _nameTextLayout = nil;
    _dateTextLayout = nil;
    _textLayout = nil;
    _quotedNameTextLayout = nil;
    _quotedTextLayout = nil;
    _retweetCountTextLayout = nil;
    _favoriteCountTextLayout = nil;
    _images = nil;
}

- (NSAttributedString *)textForTweet:(T1Tweet *)tweet{
    if (tweet.text.length == 0) return nil;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tweet.text];
    text.font = [UIFont systemFontOfSize:kT1TextFontSize];
    text.color = kT1TextColor;
    
    for (T1URL *url in tweet.urls) {
        if (url.ranges) {
            for (NSValue *value in url.ranges) {
                [self setHighlightInfo:@{@"T1URL" : url} withRange:value.rangeValue toText:text];
            }
        } else {
            [self setHighlightInfo:@{@"T1URL" : url} withRange:url.range toText:text];
        }
    }
    
    for (T1Media *media in tweet.medias) {
        if (media.ranges) {
            for (NSValue *value in media.ranges) {
                [self setHighlightInfo:@{@"T1Media" : media} withRange:value.rangeValue toText:text];
            }
        } else {
            [self setHighlightInfo:@{@"T1Media" : media} withRange:media.range toText:text];
        }
    }
    
    for (T1Media *media in tweet.extendedMedias) {
        if (media.ranges) {
            for (NSValue *value in media.ranges) {
                [self setHighlightInfo:@{@"T1Media" : media} withRange:value.rangeValue toText:text];
            }
        } else {
            [self setHighlightInfo:@{@"T1Media" : media} withRange:media.range toText:text];
        }
    }
    
    return text;
}

- (void)setHighlightInfo:(NSDictionary*)info withRange:(NSRange)range toText:(NSMutableAttributedString *)text {
    if (range.length == 0 || text.length == 0) return;
    {
        NSString *str = text.string;
        unichar *chars = malloc(str.length * sizeof(unichar));
        if (!chars) return;
        [str getCharacters:chars range:NSMakeRange(0, str.length)];
        
        NSUInteger start = range.location, end = range.location + range.length;
        for (int i = 0; i < str.length; i++) {
            unichar c = chars[i];
            if (0xD800 <= c && c <= 0xDBFF) { // UTF16 lead surrogates
                if (start > i) start++;
                if (end > i) end++;
            }
        }
        free(chars);
        if (end <= start) return;
        range = NSMakeRange(start, end - start);
    }
    
    if (range.location >= text.length) return;
    if (range.location + range.length > text.length) return;
    
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 3;
    border.insets = UIEdgeInsetsMake(-2, -2, -2, -2);
    border.fillColor = kT1TextHighlightedBackgroundColor;
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setBackgroundBorder:border];
    highlight.userInfo = info;
    
    [text setTextHighlight:highlight range:range];
    [text setColor:kT1TextHighlightedColor range:range];
}

- (T1Tweet *)displayedTweet {
    return _tweet.retweetedStatus ? _tweet.retweetedStatus : _tweet;
}

- (YYTextLayout *)retweetCountTextLayoutForTweet:(T1Tweet *)tweet {
    if (tweet.retweetCount > 0) {
        NSMutableAttributedString *retweet = [[NSMutableAttributedString alloc] initWithString:[T1Helper shortedNumberDesc:tweet.retweetCount]];
        retweet.font = [UIFont systemFontOfSize:kT1ActionFontSize];
        retweet.color = tweet.retweeted ? kT1TextActionRetweetColor : kT1TextActionsColor;
        return [YYTextLayout layoutWithContainerSize:CGSizeMake(100, kT1ActionFontSize * 2) text:retweet];
    }
    return nil;
}
- (YYTextLayout *)favoriteCountTextLayoutForTweet:(T1Tweet *)tweet {
    if (tweet.favoriteCount > 0) {
        NSMutableAttributedString *favourite = [[NSMutableAttributedString alloc] initWithString:[T1Helper shortedNumberDesc:tweet.favoriteCount]];
        favourite.font = [UIFont systemFontOfSize:kT1ActionFontSize];
        favourite.color = tweet.favorited ? kT1TextActionFavoriteColor : kT1TextActionsColor;
        return [YYTextLayout layoutWithContainerSize:CGSizeMake(100, kT1ActionFontSize * 2) text:favourite];
    }
    return nil;
}
@end
