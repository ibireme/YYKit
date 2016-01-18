//
//  YYImageProfileExample.m
//  YYKitExample
//
//  Created by ibireme on 15/8/10.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYImageBenchmark.h"
#import "YYKit.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "YYBPGCoder.h"

/*
 Enable this value and run in simulator, the image will write to desktop.
 Then you can view this image with preview.
 */
#define ENABLE_OUTPUT 0
#define IMAGE_OUTPUT_DIR @"/Users/ibireme/Desktop/image_out/"



@implementation YYImageBenchmark {
    UIActivityIndicatorView *_indicator;
    UIView *_hud;
    NSMutableArray *_titles;
    NSMutableArray *_blocks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHUD];
    _titles = [NSMutableArray new];
    _blocks = [NSMutableArray new];
    self.title = @"Benchmark (See Logs in Xcode)";
    
    [self addCell:@"ImageIO Image Decode" selector:@selector(runImageDecodeBenchmark)];
    [self addCell:@"ImageIO Image Encode" selector:@selector(runImageEncodeBenchmark)];
    [self addCell:@"WebP Encode and Decode (Slow)" selector:@selector(runWebPBenchmark)];
    [self addCell:@"BPG Decode" selector:@selector(runBPGBenchmark)];
    [self addCell:@"Animated Image Decode" selector:@selector(runAnimatedImageBenchmark)];
    
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title selector:(SEL)sel {
    __weak typeof(self) _self = self;
    void (^block)(void) = ^() {
        if (![_self respondsToSelector:sel]) return;
        
        [_self startHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_self performSelector:sel];
#pragma clang diagnostic pop
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self stopHUD];
            });
        });
    };
    [_titles addObject:title];
    [_blocks addObject:block];
}

- (void)dealloc {
    [_hud removeFromSuperview];
}

- (void)initHUD {
    _hud = [UIView new];
    _hud.size = CGSizeMake(130, 80);
    _hud.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7];
    _hud.clipsToBounds = YES;
    _hud.layer.cornerRadius = 5;
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.size = CGSizeMake(50, 50);
    _indicator.centerX = _hud.width / 2;
    _indicator.centerY = _hud.height / 2 - 9;
    [_hud addSubview:_indicator];
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.size = CGSizeMake(_hud.width, 20);
    label.text = @"See logs in Xcode";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.centerX = _hud.width / 2;
    label.bottom = _hud.height - 8;
    [_hud addSubview:label];
}

- (void)startHUD {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    _hud.center = CGPointMake(window.width / 2, window.height / 2);
    [_indicator startAnimating];
    
    [window addSubview:_hud];
    self.navigationController.view.userInteractionEnabled = NO;
}

- (void)stopHUD {
    [_indicator stopAnimating];
    [_hud removeFromSuperview];
    self.navigationController.view.userInteractionEnabled = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ((void (^)(void))_blocks[indexPath.row])();
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

#pragma mark - Benchmark

- (NSArray *)imageNames {
    return @[ @"dribbble", @"lena" ];
}

- (NSArray *)imageSizes {
    return @[  @64, @128, @256, @512 ];
}

- (NSArray *)imageSources {
    return @[ @"imageio", @"photoshop", @"imageoptim", @"pngcrush", @"tinypng", @"twitter", @"weibo", @"facebook" ];
}

- (NSArray *)imageTypes {
    return @[ (id)kUTTypeJPEG, (id)kUTTypeJPEG2000, (id)kUTTypeTIFF, (id)kUTTypeGIF, (id)kUTTypePNG, (id)kUTTypeBMP ];
}

- (NSString *)imageTypeGetExt:(id)type {
    static NSDictionary *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{(id)kUTTypeJPEG : @"jpg",
                (id)kUTTypeJPEG2000 : @"jp2",
                (id)kUTTypeTIFF : @"tif",
                (id)kUTTypeGIF : @"gif",
                (id)kUTTypePNG : @"png",
                (id)kUTTypeBMP : @"bmp"};
    });
    return type ? map[type] : nil;
}

- (NSArray *)imageTypeGetQuality:(NSString *)type {
    BOOL hasQuality = [type isEqualToString:(id)kUTTypeJPEG] || [type isEqualToString:(id)kUTTypeJPEG2000] || [type isEqualToString:@"webp"];
    return hasQuality ? @[@1.0, @0.95, @0.9, @0.85, @0.8, @0.75, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0] : @[@1.0];
}

- (void)runImageDecodeBenchmark {
    printf("==========================================\n");
    printf("ImageIO Decode Benchmark\n");
    printf("name    size type quality length decode_time\n");
    
    for (NSString *imageName in self.imageNames) {
        for (NSNumber *imageSize in self.imageSizes) {
            for (NSString *imageSource in self.imageSources) {
                for (NSString *imageType in @[@"png", @"jpg"]) {
                    @autoreleasepool {
                        NSString *fileName = [NSString stringWithFormat:@"%@%@_%@",imageName, imageSize, imageSource];
                        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:imageType];
                        NSData *data = filePath ? [NSData dataWithContentsOfFile:filePath] : nil;
                        if (!data) continue;
                        int count = 100;
                        YYBenchmark(^{
                            for (int i = 0; i < count; i++) {
                                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
                                CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(NO)});
                                CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
                                CFRelease(decoded);
                                CFRelease(image);
                                CFRelease(source);
                            }
                        }, ^(double ms) {
                            printf("%8s %3d %3s %10s %6d %2.3f\n", imageName.UTF8String, imageSize.intValue, imageType.UTF8String, imageSource.UTF8String, (int)data.length, ms / count);
                        });
                        
#if ENABLE_OUTPUT
                        if ([UIDevice currentDevice].isSimulator) {
                            NSString *outFilePath = [NSString stringWithFormat:@"%@%@.%@", IMAGE_OUTPUT_DIR, fileName, imageType];
                            [data writeToFile:outFilePath atomically:YES];
                        }
#endif
                    }
                }
            }
        }
    }
    
    printf("------------------------------------------\n\n");
}

- (void)runImageEncodeBenchmark {
    printf("==========================================\n");
    printf("ImageIO Encode Benchmark\n");
    printf("name    size type quality length encode decode\n");
    
    for (NSString *imageName in self.imageNames) {
        for (NSNumber *imageSize in self.imageSizes) {
            NSString *fileName = [NSString stringWithFormat:@"%@%@_imageio",imageName, imageSize];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
            NSData *data = filePath ? [NSData dataWithContentsOfFile:filePath] : nil;
            CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(NO)});
            CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
            
            for (NSString *uti in [self imageTypes]) {
                for (NSNumber *quality in [self imageTypeGetQuality:uti]) {
                    __block int encodeCount = 0;
                    __block double encodeTime = 0;
                    __block long length = 0;
                    __block CFMutableDataRef outData = NULL;
                    __block int decodeCount = 0;
                    __block double decodeTime = 0;
                    
                    while (encodeTime < 200) { //200ms
                        YYBenchmark(^{
                            if (outData) CFRelease(outData);
                            outData = CFDataCreateMutable(CFAllocatorGetDefault(), 0);
                            CGImageDestinationRef dest = CGImageDestinationCreateWithData(outData, (CFStringRef)uti, 1, NULL);
                            NSDictionary *options = @{(id)kCGImageDestinationLossyCompressionQuality : quality };
                            CGImageDestinationAddImage(dest, decoded, (CFDictionaryRef)options);
                            CGImageDestinationFinalize(dest);
                            length = CFDataGetLength(outData);
                            CFRelease(dest);
                        }, ^(double ms) {
                            encodeTime += ms;
                            encodeCount += 1;
                        });
                    }
                    
#if ENABLE_OUTPUT
                    if ([UIDevice currentDevice].isSimulator) {
                        NSString *outFilePath = [NSString stringWithFormat:@"%@%@%@_%.2f.%@", IMAGE_OUTPUT_DIR, imageName, imageSize, quality.floatValue, [self imageTypeGetExt:uti]];
                        [((__bridge NSData *)outData) writeToFile:outFilePath atomically:YES];
                    }
#endif
                    
                    decodeCount = 100;
                    YYBenchmark(^{
                        for (int i = 0; i < decodeCount; i++) {
                            CGImageSourceRef source = CGImageSourceCreateWithData(outData, NULL);
                            CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(NO)});
                            CGImageRef decoded = YYCGImageCreateDecodedCopy(image, NO);
                            CFRelease(decoded);
                            CFRelease(image);
                            CFRelease(source);
                        }
                    }, ^(double ms) {
                        decodeTime = ms;
                    });
                    CFRelease(outData);
                    
                    printf("%8s %3d %3s  %.2f  %7d  %7.3f %7.3f\n",imageName.UTF8String, imageSize.intValue, [self imageTypeGetExt:uti].UTF8String, quality.floatValue, (int)length, encodeTime / encodeCount, decodeTime / decodeCount);
                    
                }
            }
            
            CFRelease(decoded);
            CFRelease(image);
            CFRelease(source);
        }
    }
    
    printf("------------------------------------------\n\n");
}

- (void)runWebPBenchmark {
    printf("==========================================\n");
    printf("WebP Benchmark\n");
    printf("name size  type  quality method length encode   decode\n");

    for (NSString *imageName in self.imageNames) {
        for (NSNumber *imageSize in self.imageSizes) {
            NSString *fileName = [NSString stringWithFormat:@"%@%@_imageio", imageName, imageSize];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
            NSData *data = filePath ? [NSData dataWithContentsOfFile:filePath] : nil;
            CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache : @(NO) });
            CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
            
            for (NSNumber *lossless in @[ @YES, @NO ]) {
                for (NSNumber *q in [self imageTypeGetQuality:@"webp"]) {
                    for (NSNumber *m in @[ @0, @1, @2, @3, @4, @5, @6 ]) {
                        @autoreleasepool {
                            __block int encodeCount = 0;
                            __block double encodeTime = 0;
                            __block long length = 0;
                            __block CFDataRef webpData = NULL;
                            int decodeCount = 100;
                            double decodeTime[8] = {0};  // useThreads,bypassFiltering,noFancyUpsampling 0,0,0; 0,0,1; 0,1,0; 0,1,1; 1,0,0; 1,0,1; 1,1,0; 1,1,1
                            
                            while (encodeTime < 200) {  // 200ms
                                YYBenchmark( ^{
                                      if (webpData) CFRelease(webpData);
                                      webpData = YYCGImageCreateEncodedWebPData(decoded, lossless.boolValue, q.floatValue, m.intValue, YYImagePresetDefault);
                                      length = CFDataGetLength(webpData);
                                    }, ^(double ms) {
                                      encodeTime += ms;
                                      encodeCount += 1;
                                    });
                            }
#if ENABLE_OUTPUT
                            if ([UIDevice currentDevice].isSimulator) {
                                NSString *outFilePath = [NSString
                                    stringWithFormat:@"%@%@%@_%@_q%.2f_m%d.webp", IMAGE_OUTPUT_DIR, imageName, imageSize,
                                                     lossless.boolValue ? @"lossless" : @"lossy", q.floatValue, m.intValue];
                                [((__bridge NSData *)webpData)writeToFile:outFilePath atomically:YES];
                                
                                CGImageRef image = YYCGImageCreateWithWebPData(webpData, NO, NO, NO, NO);
                                NSData *pngData = UIImagePNGRepresentation([UIImage imageWithCGImage:image]);
                                NSString *pngOutFilePath = [NSString
                                                         stringWithFormat:@"%@%@%@_%@_q%.2f_m%d.webp.png", IMAGE_OUTPUT_DIR, imageName, imageSize,
                                                         lossless.boolValue ? @"lossless" : @"lossy", q.floatValue, m.intValue];
                                [pngData writeToFile:pngOutFilePath atomically:YES];
                                CFRelease(image);
                            }
#endif

                            for (NSNumber *useThreads in @[ @NO, @YES ]) {
                                for (NSNumber *bypassFiltering in @[ @NO, @YES ]) {
                                    for (NSNumber *noFancyUpsampling in @[ @NO, @YES ]) {
                                        __block double time = 0;
                                        YYBenchmark(^{
                                              for (int i = 0; i < decodeCount; i++) {
                                                  CGImageRef image = YYCGImageCreateWithWebPData(webpData, YES, useThreads.boolValue, bypassFiltering.boolValue,noFancyUpsampling.boolValue);
                                                  CFRelease(image);
                                              }
                                            }, ^(double ms) {
                                              time = ms;
                                            });
                                        decodeTime[useThreads.intValue << 2 | bypassFiltering.intValue << 1 |
                                                   noFancyUpsampling.intValue] = time;
                                    }
                                }
                            }
                            if (webpData) CFRelease(webpData);
                            
                            printf("%8s %3d %.8s %.2f  %1d %7d %9.3f  %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n",
                                   imageName.UTF8String, imageSize.intValue, lossless.boolValue ? "lossless" : "lossy",
                                   q.floatValue, m.intValue, (int)length, encodeTime / encodeCount, decodeTime[0] / decodeCount,
                                   decodeTime[1] / decodeCount, decodeTime[2] / decodeCount, decodeTime[3] / decodeCount,
                                   decodeTime[4] / decodeCount, decodeTime[5] / decodeCount, decodeTime[6] / decodeCount,
                                   decodeTime[7] / decodeCount);
                        }
                    }
                }
            }

            CFRelease(decoded);
            CFRelease(image);
            CFRelease(source);
        }
    }

    printf("------------------------------------------\n\n");
}

- (void)runBPGBenchmark {
    printf("==========================================\n");
    printf("BPG Decode Benchmark\n");
    printf("name    size  quality length decode_time\n");
    
    for (NSString *imageName in self.imageNames) {
        for (NSNumber *imageSize in self.imageSizes) {
            for (NSString *quality in @[ @"lossless",@"q0",@"q5",@"q10",@"q15",@"q20",@"q25",@"q30",@"q35",@"q40",@"q45",@"q50"]) {
                @autoreleasepool {
                    NSString *fileName = [NSString stringWithFormat:@"%@%@_%@",imageName, imageSize, quality];
                    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"bpg"];
                    NSData *data = filePath ? [NSData dataWithContentsOfFile:filePath] : nil;
                    if (!data) continue;
                    int count = 100;
                    YYBenchmark(^{
                        for (int i = 0; i < count; i++) {
                            CGImageRef image = YYCGImageCreateWithBPGData((__bridge CFDataRef)data, YES);
                            CFRelease(image);
                        }
                    }, ^(double ms) {
                        printf("%8s %3d %8s %6d %2.3f\n", imageName.UTF8String, imageSize.intValue, quality.UTF8String, (int)data.length, ms / count);
                    });
                    
                    
#if ENABLE_OUTPUT
                    if ([UIDevice currentDevice].isSimulator) {
                        NSString *outFilePath = [NSString stringWithFormat:@"%@%@.bpg", IMAGE_OUTPUT_DIR,fileName];
                        [data writeToFile:outFilePath atomically:YES];
                        
                        CGImageRef image = YYCGImageCreateWithBPGData((__bridge CFDataRef)data, YES);
                        NSData *pngData = UIImagePNGRepresentation([UIImage imageWithCGImage:image]);
                        CFRelease(image);
                        NSString *pngOutFilePath = [NSString stringWithFormat:@"%@%@.bpg.png", IMAGE_OUTPUT_DIR,fileName];
                        [pngData writeToFile:pngOutFilePath atomically:YES];
                    }
#endif
                    
                }
            }
        }
    }
    
    printf("------------------------------------------\n\n");
}

- (void)runAnimatedImageBenchmark {
    printf("==========================================\n");
    printf("Animated Image Decode Benckmark\n");
    if (!kiOS8Later) {
        printf("APNG require iOS8 or later\n");
        return;
    }
    
    NSData *gif = [NSData dataNamed:@"ermilio.gif"];
    NSData *apng = [NSData dataNamed:@"ermilio.png"];
    
    NSData *webp_q85 = [NSData dataNamed:@"ermilio_q85.webp"];
    NSData *webp_q90 = [NSData dataNamed:@"ermilio_q90.webp"];
    NSData *webp_lossless = [NSData dataNamed:@"ermilio_lossless.webp"];
    
    NSData *bpg_q15 = [NSData dataNamed:@"ermilio_q15.bpg"];
    NSData *bpg_q20 = [NSData dataNamed:@"ermilio_q20.bpg"];
    NSData *bpg_lossless = [NSData dataNamed:@"ermilio_lossless.bpg"];
    
    NSArray *datas = @[gif, apng, webp_q85, webp_q90, webp_lossless, bpg_q20, bpg_q15, bpg_lossless];
    NSArray *names = @[@"gif", @"apng", @"webp_85", @"webp_90", @"webp_ll", @"bpg_20", @"bpg_15", @"bpg_ll"];
    
    
#if ENABLE_OUTPUT
    if ([UIDevice currentDevice].isSimulator) {
        @autoreleasepool {
            NSString *outPath = [NSString stringWithFormat:@"%@ermilio.gif.png",IMAGE_OUTPUT_DIR];
            NSData *outData = UIImagePNGRepresentation([UIImage imageWithData:gif]);
            [outData writeToFile:outPath atomically:YES];
            [gif writeToFile:[NSString stringWithFormat:@"%@ermilio.gif",IMAGE_OUTPUT_DIR] atomically:YES];
        }
        @autoreleasepool {
            NSString *outPath = [NSString stringWithFormat:@"%@ermilio.apng.png",IMAGE_OUTPUT_DIR];
            NSData *outData = UIImagePNGRepresentation([UIImage imageWithData:apng]);
            [outData writeToFile:outPath atomically:YES];
            [apng writeToFile:[NSString stringWithFormat:@"%@ermilio.png",IMAGE_OUTPUT_DIR] atomically:YES];
        }
        @autoreleasepool {
            NSString *outPath = [NSString stringWithFormat:@"%@ermilio_q85.webp.png",IMAGE_OUTPUT_DIR];
            NSData *outData = UIImagePNGRepresentation([YYImageDecoder decodeImage:webp_q85 scale:1]);
            [outData writeToFile:outPath atomically:YES];
            [webp_q85 writeToFile:[NSString stringWithFormat:@"%@ermilio_q85.webp",IMAGE_OUTPUT_DIR] atomically:YES];
        }
        @autoreleasepool {
            NSString *outPath = [NSString stringWithFormat:@"%@ermilio_q90.webp.png",IMAGE_OUTPUT_DIR];
            NSData *outData = UIImagePNGRepresentation([YYImageDecoder decodeImage:webp_q90 scale:1]);
            [outData writeToFile:outPath atomically:YES];
            [webp_q90 writeToFile:[NSString stringWithFormat:@"%@ermilio_q90.webp",IMAGE_OUTPUT_DIR] atomically:YES];
        }
        @autoreleasepool {
            NSString *outPath = [NSString stringWithFormat:@"%@ermilio_lossless.webp.png",IMAGE_OUTPUT_DIR];
            NSData *outData = UIImagePNGRepresentation([YYImageDecoder decodeImage:webp_lossless scale:1]);
            [outData writeToFile:outPath atomically:YES];
            [webp_lossless writeToFile:[NSString stringWithFormat:@"%@ermilio_lossless.webp",IMAGE_OUTPUT_DIR] atomically:YES];
        }
        @autoreleasepool {
            NSString *outPath = [NSString stringWithFormat:@"%@ermilio_q15.bpg.png",IMAGE_OUTPUT_DIR];
            CGImageRef imageRef = YYCGImageCreateWithBPGData((__bridge CFDataRef)bpg_q15, NO);
            NSData *outData = UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef]);
            [outData writeToFile:outPath atomically:YES];
            CFRelease(imageRef);
            [bpg_q15 writeToFile:[NSString stringWithFormat:@"%@ermilio_q15.bpg",IMAGE_OUTPUT_DIR] atomically:YES];
        }
        @autoreleasepool {
            NSString *outPath = [NSString stringWithFormat:@"%@ermilio_q20.bpg.png",IMAGE_OUTPUT_DIR];
            CGImageRef imageRef = YYCGImageCreateWithBPGData((__bridge CFDataRef)bpg_q20, NO);
            NSData *outData = UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef]);
            [outData writeToFile:outPath atomically:YES];
            CFRelease(imageRef);
            [bpg_q20 writeToFile:[NSString stringWithFormat:@"%@ermilio_q20.bpg",IMAGE_OUTPUT_DIR] atomically:YES];
        }
        @autoreleasepool {
            NSString *outPath = [NSString stringWithFormat:@"%@ermilio_lossless.bpg.png",IMAGE_OUTPUT_DIR];
            CGImageRef imageRef = YYCGImageCreateWithBPGData((__bridge CFDataRef)bpg_lossless, NO);
            NSData *outData = UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef]);
            [outData writeToFile:outPath atomically:YES];
            CFRelease(imageRef);
            [bpg_lossless writeToFile:[NSString stringWithFormat:@"%@ermilio_lossless.bpg",IMAGE_OUTPUT_DIR] atomically:YES];
        }
    }
#endif
    
    
    printf("------------------------------------------\n");
    printf("image   length\n");
    for (int i = 0; i < names.count; i++) {
        NSString *name = names[i];
        NSData *data = datas[i];
        printf("%7s %6d\n",name.UTF8String, (int)data.length);
    }
    printf("\n\n");
    
    int count = 20;
    int frame_num = 28;
    
    typedef void (^CoverDecodeBlock)(id src);
    typedef void (^SingleFrameDecodeBlock)(id src, NSUInteger index);
    typedef void (^AllFrameDecodeBlock)(id src, BOOL reverseOrder);
    
    /// Cover: gif/apng
    CoverDecodeBlock imageioCoverDecoder = ^(NSData *data){
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(NO)});
        CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
        CFRelease(decoded);
        CFRelease(image);
        CFRelease(source);
    };
    
    /// Cover: gif/apng/webp
    CoverDecodeBlock yyCoverDecoder = ^(NSData *data) {
        @autoreleasepool {
            YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:1];
            [decoder frameAtIndex:0 decodeForDisplay:YES];
        }
    };
    
    /// Cover: webp
    CoverDecodeBlock webpCoverDecoder = ^(NSData *data) {
        CGImageRef image = YYCGImageCreateWithWebPData((__bridge CFDataRef)data, YES, NO, NO, NO);
        CFRelease(image);
    };
    
    /// Cover: bpg
    CoverDecodeBlock bpgCoverDecoder = ^(NSData *data) {
        CGImageRef image = YYCGImageCreateWithBPGData((__bridge CFDataRef)data, YES);
        CFRelease(image);
    };
    
    NSArray *coverSrcs = @[@"gif       imageio", gif, imageioCoverDecoder,
                           @"gif     yydecoder", gif, yyCoverDecoder,
                           @"apng      imageio", apng, imageioCoverDecoder,
                           @"apng    yydecoder", apng, yyCoverDecoder,
                           @"webp_85   yyimage", webp_q85, webpCoverDecoder,
                           @"webp_85 yydecocer", webp_q85, yyCoverDecoder,
                           @"webp_90   yyimage", webp_q90, webpCoverDecoder,
                           @"webp_90 yydecocer", webp_q90, yyCoverDecoder,
                           @"webp_ll   yyimage", webp_lossless, webpCoverDecoder,
                           @"webp_ll yydecoder", webp_lossless, yyCoverDecoder,
                           @"bpg_20    yyimage", bpg_q20, bpgCoverDecoder,
                           @"bpg_15    yyimage", bpg_q20, bpgCoverDecoder,
                           @"bpg_ll    yyimage", bpg_lossless, bpgCoverDecoder,
                           ];
    
    
    printf("------------------------------------------\n");
    printf("First frame (cover) decode\n");
    count = 20;
    for (int i = 0; i < coverSrcs.count / 3; i++) {
        NSString *name = coverSrcs[i * 3];
        id src = coverSrcs[i * 3 + 1];
        CoverDecodeBlock block = coverSrcs[i * 3 + 2];
        YYBenchmark(^{
            for (int r = 0; r < count; r++) {
                block(src);
            }
        }, ^(double ms) {
            printf("%s %8.3f\n",name.UTF8String, ms / count);
        });
    }
    printf("\n\n");
    
    
    
    
    
    
    
    
    /// Single: gif/apng
    SingleFrameDecodeBlock imagioSingleFrameDecoder = ^(id src, NSUInteger index) {
        CGImageSourceRef source = (__bridge CGImageSourceRef)src;
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, index, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(NO)});
        CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
        CFRelease(decoded);
        CFRelease(image);
    };
    
    /// Single: gif/apng/webp
    SingleFrameDecodeBlock yySingleFrameDecoder = ^(YYImageDecoder *decoder, NSUInteger index) {
        @autoreleasepool {
            UIImage *img = [decoder frameAtIndex:index decodeForDisplay:YES].image;
            [img scale];
        }
    };
    
    
    NSArray *singleSrcs = @[@"gif       imageio", @"gif src", imagioSingleFrameDecoder,
                            @"gif     yydecoder", @"gif", yySingleFrameDecoder,
                            @"apng      imageio", @"apng src", imagioSingleFrameDecoder,
                            @"apng    yydecoder", @"apng", yySingleFrameDecoder,
                            @"webp_85 yydecocer", @"webp85", yySingleFrameDecoder,
                            @"webp_90 yydecocer", @"webp90", yySingleFrameDecoder,
                            @"webp_ll yydecoder", @"webpll", yySingleFrameDecoder,
                            ];

    
    
    printf("------------------------------------------\n");
    printf("Single frame decode\n");
    count = 5;
    for (int i = 0; i < singleSrcs.count / 3; i++) {
        NSString *name = singleSrcs[i * 3];
        NSString *srcStr = singleSrcs[i * 3 + 1];
        
        SingleFrameDecodeBlock block = singleSrcs[i * 3 + 2];
        
        printf("%s ",name.UTF8String);
        for (int f = 0; f < frame_num; f++) {
            YYBenchmark(^{
                for (int r = 0; r < count; r++) {
                    id src = NULL;
                    if ([srcStr isEqual:@"gif src"]) {
                        src = CFBridgingRelease(CGImageSourceCreateWithData((__bridge CFDataRef)gif, NULL));
                    } else if ([srcStr isEqual:@"gif"]) {
                        src = [YYImageDecoder decoderWithData:gif scale:1];
                    } else if ([srcStr isEqual:@"apng src"]) {
                        src = CFBridgingRelease(CGImageSourceCreateWithData((__bridge CFDataRef)apng, NULL));
                    } else if ([srcStr isEqual:@"apng"]) {
                        src = [YYImageDecoder decoderWithData:apng scale:1];
                    } else if ([srcStr isEqual:@"webp85"]) {
                        src = [YYImageDecoder decoderWithData:webp_q85 scale:1];
                    } else if ([srcStr isEqual:@"webp90"]) {
                        src = [YYImageDecoder decoderWithData:webp_q90 scale:1];
                    } else if ([srcStr isEqual:@"webpll"]) {
                        src = [YYImageDecoder decoderWithData:webp_lossless scale:1];
                    }
                    block(src, f);
                }
            }, ^(double ms) {
                printf("%8.3f ",ms / count);
            });
        }
        printf("\n");
    }
    printf("\n\n");
    

    
    /// All: gif/apng
    AllFrameDecodeBlock imageioAllFrameDecoder = ^(NSData *data, BOOL reverseOrder){
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)gif, NULL);
        if (reverseOrder) {
            for (int i = frame_num - 1; i >= 0; i--) {
                CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(NO)});
                CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
                CFRelease(decoded);
                CFRelease(image);
            }
        } else {
            for (int i = 0; i < frame_num; i++) {
                CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(NO)});
                CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
                CFRelease(decoded);
                CFRelease(image);
            }
        }
        CFRelease(source);
    };
    
    /// All: gif/apng/webp
    AllFrameDecodeBlock yyAllFrameDecoder = ^(NSData *data, BOOL reverseOrder){
        @autoreleasepool {
            YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:1];
            if (reverseOrder) {
                for (int i = frame_num - 1; i > 0; i--) {
                    [decoder frameAtIndex:i decodeForDisplay:YES];
                }
            } else {
                for (int i = 1; i < frame_num; i++) {
                    [decoder frameAtIndex:i decodeForDisplay:YES];
                }
            }
        }
    };
    
    /// All: bpg
    AllFrameDecodeBlock bpgAllFrameDecoder = ^(NSData *data, BOOL reverseOrder){
        @autoreleasepool {
            YYCGImageDecodeAllFrameInBPGData((__bridge CFDataRef)data, YES);
        }
    };
    
    NSArray *allSrcs = @[@"gif       imageio", gif, imageioAllFrameDecoder,
                         @"gif     yydecoder", gif, yyAllFrameDecoder,
                         @"apng      imageio", apng, imageioAllFrameDecoder,
                         @"apng    yydecoder", apng, yyAllFrameDecoder,
                         @"webp_85 yydecocer", webp_q85, yyAllFrameDecoder,
                         @"webp_90 yydecocer", webp_q90, yyAllFrameDecoder,
                         @"webp_ll yydecoder", webp_lossless, yyAllFrameDecoder,
                         @"bpg_20    yyimage", bpg_q20, bpgAllFrameDecoder,
                         @"bpg_15    yyimage", bpg_q20, bpgAllFrameDecoder,
                         @"bpg_ll    yyimage", bpg_lossless, bpgAllFrameDecoder,
                         ];
    
    
    
    printf("------------------------------------------\n");
    printf("All frame decode\n");
    printf("type      decoder      asc     desc\n");
    count = 5;
    for (int i = 0; i < allSrcs.count / 3; i++) {
        NSString *name = allSrcs[i * 3];
        id src = allSrcs[i * 3 + 1];
        AllFrameDecodeBlock block = allSrcs[i * 3 + 2];
        
        printf("%s ",name.UTF8String);
        for (NSNumber *rev in @[@NO, @YES]) {
            if ([name hasPrefix:@"bpg"] && rev.boolValue) continue;
            YYBenchmark(^{
                for (int r = 0; r < count; r++) {
                    block(src, rev.boolValue);
                }
            }, ^(double ms) {
                printf("%8.3f ",ms / count);
            });
        }
        printf("\n");
    }
    printf("\n\n");

}

@end
