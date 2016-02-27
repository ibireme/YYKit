//
//  NSObject+YYAddForKVO.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/10/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Observer with block (KVO).
 */
@interface NSObject (YYAddForKVO)

/**
 Registers a block to receive KVO notifications for the specified key-path 
 relative to the receiver.
 
 @discussion The block and block captured objects are retained. Call
 `removeObserverBlocksForKeyPath:` or `removeObserverBlocks` to release.
 
 @param keyPath The key path, relative to the receiver, of the property to 
 observe. This value must not be nil.
 
 @param block   The block to register for KVO notifications.
 */
- (void)addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(__weak id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block;

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications for the property specified by a given key-path 
 relative to the receiver, and release these blocks.
 
 @param keyPath A key-path, relative to the receiver, for which blocks is 
 registered to receive KVO change notifications.
 */
- (void)removeObserverBlocksForKeyPath:(NSString*)keyPath;

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications, and release these blocks.
 */
- (void)removeObserverBlocks;

@end

NS_ASSUME_NONNULL_END
