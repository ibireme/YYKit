//
//  YYCGUtilities.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/28.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYCGUtilities.h"
#import <Accelerate/Accelerate.h>
#import "UIView+YYAdd.h"

CGContextRef YYCGContextCreateARGBBitmapContext(CGSize size, BOOL opaque, CGFloat scale) {
    size_t width = ceil(size.width * scale);
    size_t height = ceil(size.height * scale);
    if (width < 1 || height < 1) return NULL;
    
    //pre-multiplied ARGB, 8-bits per component
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGImageAlphaInfo alphaInfo = (opaque ? kCGImageAlphaNoneSkipFirst : kCGImageAlphaPremultipliedFirst);
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, kCGBitmapByteOrderDefault | alphaInfo);
    CGColorSpaceRelease(space);
    if (context) {
        CGContextTranslateCTM(context, 0, height);
        CGContextScaleCTM(context, scale, -scale);
    }
    return context;
}

CGContextRef YYCGContextCreateGrayBitmapContext(CGSize size, CGFloat scale) {
    size_t width = ceil(size.width * scale);
    size_t height = ceil(size.height * scale);
    if (width < 1 || height < 1) return NULL;
    
    //DeviceGray, 8-bits per component
    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    CGImageAlphaInfo alphaInfo = kCGImageAlphaNone;
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, kCGBitmapByteOrderDefault | alphaInfo);
    CGColorSpaceRelease(space);
    if (context) {
        CGContextTranslateCTM(context, 0, height);
        CGContextScaleCTM(context, scale, -scale);
    }
    return context;
}

CGFloat YYScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

CGSize YYScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

// return 0 when succeed
static int matrix_invert(__CLPK_integer N, double *matrix) {
    __CLPK_integer error = 0;
    __CLPK_integer pivot_tmp[6 * 6];
    __CLPK_integer *pivot = pivot_tmp;
    double workspace_tmp[6 * 6];
    double *workspace = workspace_tmp;
    bool need_free = false;
    
    if (N > 6) {
        need_free = true;
        pivot = malloc(N * N * sizeof(__CLPK_integer));
        if (!pivot) return -1;
        workspace = malloc(N * sizeof(double));
        if (!workspace) {
            free(pivot);
            return -1;
        }
    }
    
    dgetrf_(&N, &N, matrix, &N, pivot, &error);
    
    if (error == 0) {
        dgetri_(&N, matrix, &N, pivot, workspace, &N, &error);
    }
    
    if (need_free) {
        free(pivot);
        free(workspace);
    }
    return error;
}

CGAffineTransform YYCGAffineTransformGetFromPoints(CGPoint before[3], CGPoint after[3]) {
    if (before == NULL || after == NULL) return CGAffineTransformIdentity;
    
    CGPoint p1, p2, p3, q1, q2, q3;
    p1 = before[0]; p2 = before[1]; p3 = before[2];
    q1 =  after[0]; q2 =  after[1]; q3 =  after[2];
    
    double A[36];
    A[ 0] = p1.x; A[ 1] = p1.y; A[ 2] = 0; A[ 3] = 0; A[ 4] = 1; A[ 5] = 0;
    A[ 6] = 0; A[ 7] = 0; A[ 8] = p1.x; A[ 9] = p1.y; A[10] = 0; A[11] = 1;
    A[12] = p2.x; A[13] = p2.y; A[14] = 0; A[15] = 0; A[16] = 1; A[17] = 0;
    A[18] = 0; A[19] = 0; A[20] = p2.x; A[21] = p2.y; A[22] = 0; A[23] = 1;
    A[24] = p3.x; A[25] = p3.y; A[26] = 0; A[27] = 0; A[28] = 1; A[29] = 0;
    A[30] = 0; A[31] = 0; A[32] = p3.x; A[33] = p3.y; A[34] = 0; A[35] = 1;
    
    int error = matrix_invert(6, A);
    if (error) return CGAffineTransformIdentity;
    
    double B[6];
    B[0] = q1.x; B[1] = q1.y; B[2] = q2.x; B[3] = q2.y; B[4] = q3.x; B[5] = q3.y;
    
    double M[6];
    M[0] = A[ 0] * B[0] + A[ 1] * B[1] + A[ 2] * B[2] + A[ 3] * B[3] + A[ 4] * B[4] + A[ 5] * B[5];
    M[1] = A[ 6] * B[0] + A[ 7] * B[1] + A[ 8] * B[2] + A[ 9] * B[3] + A[10] * B[4] + A[11] * B[5];
    M[2] = A[12] * B[0] + A[13] * B[1] + A[14] * B[2] + A[15] * B[3] + A[16] * B[4] + A[17] * B[5];
    M[3] = A[18] * B[0] + A[19] * B[1] + A[20] * B[2] + A[21] * B[3] + A[22] * B[4] + A[23] * B[5];
    M[4] = A[24] * B[0] + A[25] * B[1] + A[26] * B[2] + A[27] * B[3] + A[28] * B[4] + A[29] * B[5];
    M[5] = A[30] * B[0] + A[31] * B[1] + A[32] * B[2] + A[33] * B[3] + A[34] * B[4] + A[35] * B[5];
    
    CGAffineTransform transform = CGAffineTransformMake(M[0], M[2], M[1], M[3], M[4], M[5]);
    return transform;
}

CGAffineTransform YYCGAffineTransformGetFromViews(UIView *from, UIView *to) {
    if (!from || !to) return CGAffineTransformIdentity;
    
    CGPoint before[3], after[3];
    before[0] = CGPointMake(0, 0);
    before[1] = CGPointMake(0, 1);
    before[2] = CGPointMake(1, 0);
    after[0] = [from convertPoint:before[0] toViewOrWindow:to];
    after[1] = [from convertPoint:before[1] toViewOrWindow:to];
    after[2] = [from convertPoint:before[2] toViewOrWindow:to];
    
    return YYCGAffineTransformGetFromPoints(before, after);
}

UIViewContentMode YYCAGravityToUIViewContentMode(NSString *gravity) {
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{ kCAGravityCenter:@(UIViewContentModeCenter),
                 kCAGravityTop:@(UIViewContentModeTop),
                 kCAGravityBottom:@(UIViewContentModeBottom),
                 kCAGravityLeft:@(UIViewContentModeLeft),
                 kCAGravityRight:@(UIViewContentModeRight),
                 kCAGravityTopLeft:@(UIViewContentModeTopLeft),
                 kCAGravityTopRight:@(UIViewContentModeTopRight),
                 kCAGravityBottomLeft:@(UIViewContentModeBottomLeft),
                 kCAGravityBottomRight:@(UIViewContentModeBottomRight),
                 kCAGravityResize:@(UIViewContentModeScaleToFill),
                 kCAGravityResizeAspect:@(UIViewContentModeScaleAspectFit),
                 kCAGravityResizeAspectFill:@(UIViewContentModeScaleAspectFill) };
    });
    if (!gravity) return UIViewContentModeScaleToFill;
    return (UIViewContentMode)((NSNumber *)dic[gravity]).integerValue;
}

NSString *YYUIViewContentModeToCAGravity(UIViewContentMode contentMode) {
    switch (contentMode) {
        case UIViewContentModeScaleToFill: return kCAGravityResize;
        case UIViewContentModeScaleAspectFit: return kCAGravityResizeAspect;
        case UIViewContentModeScaleAspectFill: return kCAGravityResizeAspectFill;
        case UIViewContentModeRedraw: return kCAGravityResize;
        case UIViewContentModeCenter: return kCAGravityCenter;
        case UIViewContentModeTop: return kCAGravityTop;
        case UIViewContentModeBottom: return kCAGravityBottom;
        case UIViewContentModeLeft: return kCAGravityLeft;
        case UIViewContentModeRight: return kCAGravityRight;
        case UIViewContentModeTopLeft: return kCAGravityTopLeft;
        case UIViewContentModeTopRight: return kCAGravityTopRight;
        case UIViewContentModeBottomLeft: return kCAGravityBottomLeft;
        case UIViewContentModeBottomRight: return kCAGravityBottomRight;
        default: return kCAGravityResize;
    }
}

CGRect YYCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode) {
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (mode) {
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (mode == UIViewContentModeScaleAspectFit) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        } break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        } break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        } break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
        default: {
            rect = rect;
        }
    }
    return rect;
}
