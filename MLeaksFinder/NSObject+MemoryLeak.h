/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>

#define MLCheck(TARGET) [self willReleaseObject:(TARGET) relationship:@#TARGET];

@interface NSObject (MemoryLeak)

- (BOOL)willDealloc;
- (void)willReleaseObject:(id)object relationship:(NSString *)relationship;

- (void)willReleaseChild:(id)child;
- (void)willReleaseChildren:(NSArray *)children;

- (NSArray *)viewStack;

+ (void)addClassNamesToWhitelist:(NSArray *)classNames;

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL;

@end
