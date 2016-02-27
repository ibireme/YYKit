//
//  UITableView+YYAdd.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/5/12.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UITableView`.
 */
@interface UITableView (YYAdd)

/**
 Perform a series of method calls that insert, delete, or select rows and
 sections of the receiver.
 
 @discussion Perform a series of method calls that insert, delete, or select
             rows and sections of the table. Call this method if you want
             subsequent insertions, deletion, and selection operations (for
             example, cellForRowAtIndexPath: and indexPathsForVisibleRows)
             to be animated simultaneously.
 
 @discussion If you do not make the insertion, deletion, and selection calls
             inside this block, table attributes such as row count might become
             invalid. You should not call reloadData within the block; if you
             call this method within the group, you will need to perform any
             animations yourself.
 
 @param block  A block combine a series of method calls.
 */
- (void)updateWithBlock:(void (^)(UITableView *tableView))block;

/**
 Scrolls the receiver until a row or section location on the screen.
 
 @discussion            Invoking this method does not cause the delegate to 
                        receive a scrollViewDidScroll: message, as is normal for 
                        programmatically-invoked user interface operations.
 
 @param row             Row index in section. NSNotFound is a valid value for
                        scrolling to a section with zero rows.
 
 @param section         Section index in table.
 
 @param scrollPosition  A constant that identifies a relative position in the 
                        receiving table view (top, middle, bottom) for row when 
                        scrolling concludes.
 
 @param animated        YES if you want to animate the change in position,
                        NO if it should be immediate.
 */
- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

/**
 Inserts a row in the receiver with an option to animate the insertion.
 
 @param row        Row index in section.
 
 @param section    Section index in table.
 
 @param animation  A constant that either specifies the kind of animation to
                   perform when inserting the cell or requests no animation. 
 */
- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Reloads the specified row using a certain animation effect.
 
 @param row        Row index in section.
 
 @param section    Section index in table.
 
 @param animation  A constant that indicates how the reloading is to be animated,
                   for example, fade out or slide out from the bottom. The animation 
                   constant affects the direction in which both the old and the 
                   new rows slide. For example, if the animation constant is 
                   UITableViewRowAnimationRight, the old rows slide out to the 
                   right and the new cells slide in from the right.
 */
- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Deletes the row with an option to animate the deletion.
 
 @param row        Row index in section.
 
 @param section    Section index in table.
 
 @param animation  A constant that indicates how the deletion is to be animated, 
                   for example, fade out or slide out from the bottom.
 */
- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Inserts the row in the receiver at the locations identified by the indexPath, 
 with an option to animate the insertion.
 
 @param indexPath  An NSIndexPath object representing a row index and section 
                   index that together identify a row in the table view.
 
 @param animation  A constant that either specifies the kind of animation to
                   perform when inserting the cell or requests no animation.
 */
- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Reloads the specified row using a certain animation effect.
 
 @param indexPath  An NSIndexPath object representing a row index and section
                   index that together identify a row in the table view.
 
 @param animation A constant that indicates how the reloading is to be animated,
                  for example, fade out or slide out from the bottom. The animation
                  constant affects the direction in which both the old and the
                  new rows slide. For example, if the animation constant is
                  UITableViewRowAnimationRight, the old rows slide out to the
                  right and the new cells slide in from the right.
 */
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Deletes the row specified by an array of index paths, 
 with an option to animate the deletion.
 
 @param indexPath  An NSIndexPath object representing a row index and section
                   index that together identify a row in the table view.
 
 @param animation  A constant that indicates how the deletion is to be animated,
                   for example, fade out or slide out from the bottom.
 */
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Inserts a section in the receiver, with an option to animate the insertion.
 
 @param section    An index specifies the section to insert in the receiving
                   table view. If a section already exists at the specified 
                   index location, it is moved down one index location.
 
 @param animation  A constant that indicates how the insertion is to be animated, 
                   for example, fade in or slide in from the left.
 */
- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Deletes a section in the receiver, with an option to animate the deletion.
 
 @param section    An index that specifies the sections to delete from the 
                   receiving table view. If a section exists after the specified
                   index location, it is moved up one index location.
 
 @param animation  A constant that either specifies the kind of animation to 
                   perform when deleting the section or requests no animation.
 */
- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Reloads the specified section using a given animation effect.
 
 @param section    An index identifying the section to reload.
 
 @param animation  A constant that indicates how the reloading is to be animated, 
                   for example, fade out or slide out from the bottom. The 
                   animation constant affects the direction in which both the 
                   old and the new section rows slide. For example, if the 
                   animation constant is UITableViewRowAnimationRight, the old 
                   rows slide out to the right and the new cells slide in from the right.
 */
- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Unselect all rows in tableView.
 
 @param animated YES to animate the transition, NO to make the transition immediate.
 */
- (void)clearSelectedRowsAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
