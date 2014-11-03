//
//  UIFont+YYAdd.m
//  YYKit
//
//  Created by ibireme on 14-5-11.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "UIFont+YYAdd.h"
#import "YYKitMacro.h"

SYNTH_DUMMY_CLASS(UIFont_YYAdd)


@implementation UIFont (YYAdd)

+ (UIFont *)fontWithCTFont:(CTFontRef)CTFont {
    if (!CTFont) return nil;
    CFStringRef name = CTFontCopyPostScriptName(CTFont);
    if (!name) return nil;
    CGFloat size = CTFontGetSize(CTFont);
    UIFont *font = [self fontWithName:(__bridge NSString *)(name) size:size];
    CFRelease(name);
    return font;
}

+ (UIFont *)fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size {
    if (!CGFont) return nil;
    CFStringRef name = CGFontCopyPostScriptName(CGFont);
    if (!name) return nil;
    UIFont *font = [self fontWithName:(__bridge NSString *)(name) size:size];
    CFRelease(name);
    return font;
}

- (CTFontRef)CTFont CF_RETURNS_RETAINED {
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.pointSize, NULL);
    return font;
}

- (CGFontRef)CGFont CF_RETURNS_RETAINED {
    CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)self.fontName);
    return font;
}

+ (BOOL)loadFontFromPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CFErrorRef error;
    BOOL suc = CTFontManagerRegisterFontsForURL((__bridge CFTypeRef)url, kCTFontManagerScopeNone, &error);
    if (!suc) {
        NSLog(@"Failed to load font: %@", error);
    }
    return suc;
}

+ (void)unloadFontFromPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CTFontManagerUnregisterFontsForURL((__bridge CFTypeRef)url, kCTFontManagerScopeNone, NULL);
}

+ (UIFont *)loadFontFromData:(NSData *)data {
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    if (!provider) return nil;
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    CGDataProviderRelease(provider);
    if (!fontRef) return nil;
    
    CFErrorRef errorRef;
    BOOL suc = CTFontManagerRegisterGraphicsFont(fontRef, &errorRef);
    if (!suc) {
        CFRelease(fontRef);
        NSLog(@"%@", errorRef);
        return nil;
    } else {
        CFStringRef fontName = CGFontCopyPostScriptName(fontRef);
        UIFont *font = [UIFont fontWithName:(__bridge NSString *)(fontName) size:[UIFont systemFontSize]];
        if (fontName) CFRelease(fontName);
        CGFontRelease(fontRef);
        return font;
    }
}

+ (BOOL)unloadFontFromData:(UIFont *)font {
    CGFontRef fontRef = CGFontCreateWithFontName((__bridge CFStringRef)font.fontName);
    if (!fontRef) return NO;
    CFErrorRef errorRef;
    BOOL suc = CTFontManagerUnregisterGraphicsFont(fontRef, &errorRef);
    CFRelease(fontRef);
    if (!suc) NSLog(@"%@", errorRef);
    return suc;
}

+ (NSData *)dataFromFont:(UIFont *)font {
    CGFontRef cgFont = font.CGFont;
    NSData *data = [self dataFromCGFont:cgFont];
    CGFontRelease(cgFont);
    return data;
}

typedef struct FontHeader {
    int32_t fVersion;
    uint16_t fNumTables;
    uint16_t fSearchRange;
    uint16_t fEntrySelector;
    uint16_t fRangeShift;
} FontHeader;

typedef struct TableEntry {
    uint32_t fTag;
    uint32_t fCheckSum;
    uint32_t fOffset;
    uint32_t fLength;
} TableEntry;

static uint32_t CalcTableCheckSum(const uint32_t *table, uint32_t numberOfBytesInTable) {
    uint32_t sum = 0;
    uint32_t nLongs = (numberOfBytesInTable + 3) / 4;
    while (nLongs-- > 0) {
        sum += CFSwapInt32HostToBig(*table++);
    }
    return sum;
}

//Reference:
//http://skia.googlecode.com/svn-history/r1473/trunk/src/ports/SkFontHost_mac_coretext.cpp
+ (NSData *)dataFromCGFont:(CGFontRef)cgFont {
    if (!cgFont) return nil;
    
    CFRetain(cgFont);
    
    CFArrayRef tags = CGFontCopyTableTags(cgFont);
    if (!tags) return nil;
    CFIndex tableCount = CFArrayGetCount(tags);
    
    size_t *tableSizes = malloc(sizeof(size_t) * tableCount);
    memset(tableSizes, 0, sizeof(size_t) * tableCount);
    
    BOOL containsCFFTable = NO;
    
    size_t totalSize = sizeof(FontHeader) + sizeof(TableEntry) * tableCount;
    
    for (CFIndex index = 0; index < tableCount; index++) {
        size_t tableSize = 0;
        uint32_t aTag = (uint32_t)CFArrayGetValueAtIndex(tags, index);
        if (aTag == 'CFF ' && !containsCFFTable) {
            containsCFFTable = YES;
        }
        CFDataRef tableDataRef = CGFontCopyTableForTag(cgFont, aTag);
        if (tableDataRef) {
            tableSize = CFDataGetLength(tableDataRef);
            CFRelease(tableDataRef);
        }
        totalSize += (tableSize + 3) & ~3;
        tableSizes[index] = tableSize;
    }
    
    unsigned char *stream = malloc(totalSize);
    memset(stream, 0, totalSize);
    char *dataStart = (char *)stream;
    char *dataPtr = dataStart;
    
    // compute font header entries
    uint16_t entrySelector = 0;
    uint16_t searchRange = 1;
    while (searchRange < tableCount >> 1) {
        entrySelector++;
        searchRange <<= 1;
    }
    searchRange <<= 4;
    
    uint16_t rangeShift = (tableCount << 4) - searchRange;
    
    // write font header (also called sfnt header, offset subtable)
    FontHeader *offsetTable = (FontHeader *)dataPtr;
    
    //OpenType Font contains CFF Table use 'OTTO' as version, and with .otf extension
    //otherwise 0001 0000
    offsetTable->fVersion = containsCFFTable ? 'OTTO' : CFSwapInt16HostToBig(1);
    offsetTable->fNumTables = CFSwapInt16HostToBig((uint16_t)tableCount);
    offsetTable->fSearchRange = CFSwapInt16HostToBig((uint16_t)searchRange);
    offsetTable->fEntrySelector = CFSwapInt16HostToBig((uint16_t)entrySelector);
    offsetTable->fRangeShift = CFSwapInt16HostToBig((uint16_t)rangeShift);
    
    dataPtr += sizeof(FontHeader);
    
    // write tables
    TableEntry *entry = (TableEntry *)dataPtr;
    dataPtr += sizeof(TableEntry) * tableCount;
    
    for (int index = 0; index < tableCount; ++index) {
        uint32_t aTag = (uint32_t)CFArrayGetValueAtIndex(tags, index);
        CFDataRef tableDataRef = CGFontCopyTableForTag(cgFont, aTag);
        size_t tableSize = CFDataGetLength(tableDataRef);
        
        memcpy(dataPtr, CFDataGetBytePtr(tableDataRef), tableSize);
        
        entry->fTag = CFSwapInt32HostToBig((uint32_t)aTag);
        entry->fCheckSum = CFSwapInt32HostToBig(CalcTableCheckSum((uint32_t *)dataPtr, (uint32_t)tableSize));
        
        uint32_t offset = (uint32_t)dataPtr - (uint32_t)dataStart;
        entry->fOffset = CFSwapInt32HostToBig((uint32_t)offset);
        entry->fLength = CFSwapInt32HostToBig((uint32_t)tableSize);
        dataPtr += (tableSize + 3) & ~3;
        ++entry;
        CFRelease(tableDataRef);
    }
    
    CFRelease(cgFont);
    CFRelease(tags);
    free(tableSizes);
    NSData *fontData = [NSData dataWithBytesNoCopy:stream length:totalSize freeWhenDone:YES];
    return fontData;
}

@end
