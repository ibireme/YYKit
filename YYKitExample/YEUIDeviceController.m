//
//  YEUIDeviceController.m
//  YYKitExample
//
//  Created by ibireme on 14/10/25.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YEUIDeviceController.h"
#import <YYKit/YYKit.h>

@implementation YEUIDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextView *textView = [[UITextView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:textView];
    textView.editable = NO;
    
    NSMutableString *str = @"".mutableCopy;
    [str appendFormat:@"Memory:\n"];
    [str appendFormat:@"total:\t\t%llu MB\n", [UIDevice currentDevice].memoryTotal / 1024 / 1024];
    [str appendFormat:@"free:\t\t%llu MB\n", [UIDevice currentDevice].memoryFree / 1024 / 1024];
    [str appendFormat:@"active:\t%llu MB\n", [UIDevice currentDevice].memoryActive / 1024 / 1024];
    [str appendFormat:@"inactive:\t%llu MB\n", [UIDevice currentDevice].memoryInactive / 1024 / 1024];
    [str appendFormat:@"wired:\t%llu MB\n", [UIDevice currentDevice].memoryWired / 1024 / 1024];
    [str appendFormat:@"purgable:\t%llu MB\n", [UIDevice currentDevice].memoryPurgable / 1024 / 1024];
    
    textView.text = str;
}

@end
