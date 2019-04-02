//
//  YYActiveObj.m
//  ywf
//
//  Created by Saylor on 2019/4/2.
//  Copyright © 2019 zang. All rights reserved.
//

#import "YYActiveObj.h"

static UIView *_viewActive;

@implementation YYActiveObj

+ (void)setViewActive:(UIView *)viewActive{
    _viewActive = viewActive;
}

+ (UIView *)viewActive{
    return _viewActive;
}

@end
