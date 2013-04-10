//
//  UIImage+YYAdd.h
//  YYCore
//
//  Created by ibireme on 13-4-4.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>

@interface UIImage (YYAdd)

/**
 * similar to +[UIImage imageNamed:], but do not cache data;
 * pass nil to bundleName will use main bundle
 */
+ (UIImage *)imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName;

#warning  from ColorConvetor 
- (UIColor *)colorAtPoint:(CGPoint )point;

#warning  from sstoolkit 
- (UIImage *)imageCroppedToRect:(CGRect)rect;

- (UIImage *)squareImage;

- (BOOL)hasAlpha;

@end
