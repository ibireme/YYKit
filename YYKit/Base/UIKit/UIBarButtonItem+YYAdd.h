//
//  UIBarButtonItem+YYAdd.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/10/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIBarButtonItem`.
 */
@interface UIBarButtonItem (YYAdd)

/**
 The block that invoked when the item is selected. The objects captured by block
 will retained by the ButtonItem.
 
 @discussion This param is conflict with `target` and `action` property.
 Set this will set `target` and `action` property to some internal objects.
 */
@property (nullable, nonatomic, copy) void (^actionBlock)(id);

@end

NS_ASSUME_NONNULL_END