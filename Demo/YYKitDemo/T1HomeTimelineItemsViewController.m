//
//  T1HomeTimelineItemsViewController.m
//  YYKitExample
//
//  Created by ibireme on 15/10/9.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "T1HomeTimelineItemsViewController.h"
#import "T1StatusLayout.h"
#import "T1StatusCell.h"
#import "YYTableView.h"
#import "YYFPSLabel.h"
#import "YYPhotoGroupView.h"
#import "YYSimpleWebViewController.h"

@interface T1HomeTimelineItemsViewController() <UITableViewDelegate, UITableViewDataSource, T1StatusCellDelegate>
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation T1HomeTimelineItemsViewController

- (instancetype)init {
    self = [super init];
    _tableView = [YYTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.919];
    
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - kT1CellPadding;
    _fpsLabel.left = kT1CellPadding;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];
    
    if (kSystemVersion < 7) {
        _fpsLabel.top -= 44;
        _tableView.top -= 64;
        _tableView.height += 20;
    }
    
    
    
    
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *layouts = [NSMutableArray new];
        for (int i = 0; i <= 3; i++) {
            NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"twitter_%d.json",i]];
            T1APIRespose *response = [T1APIRespose modelWithJSON:data];
            for (id item in response.timelineItmes) {
                if ([item isKindOfClass:[T1Tweet class]]) {
                    T1Tweet *tweet = item;
                    T1StatusLayout *layout = [T1StatusLayout new];
                    layout.tweet = tweet;
                    [layouts addObject:layout];
                } else if ([item isKindOfClass:[T1Conversation class]]) {
                    T1Conversation *conv = item;
                    NSMutableArray *convLayouts = [NSMutableArray new];
                    for (T1Tweet *tweet in conv.tweets) {
                        T1StatusLayout *layout = [T1StatusLayout new];
                        layout.conversation = conv;
                        layout.tweet = tweet;
                        [convLayouts addObject:layout];
                    }
                    if (conv.targetCount > 0 && convLayouts.count >= 2) {
                        T1StatusLayout *split = [T1StatusLayout new];
                        split.conversation = conv;
                        [split layout];
                        [convLayouts insertObject:split atIndex:1];
                    }
                    [layouts addObjectsFromArray:convLayouts];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"Twitter (loaded:%d)", (int)layouts.count];
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            self.layouts = layouts;
            [_tableView reloadData];
        });
    });
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    T1StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[T1StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((T1StatusLayout *)_layouts[indexPath.row]).height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - T1StatusCellDelegate

- (void)cell:(T1StatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    YYTextHighlight *highlight = [label.textLayout.text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    NSURL *link = nil;
    NSString *linkTitle = nil;
    if (info[@"T1URL"]) {
        T1URL *url = info[@"T1URL"];
        if (url.expandedURL.length) {
            link = [NSURL URLWithString:url.expandedURL];
            linkTitle = url.displayURL;
        }
    } else if (info[@"T1Media"]) {
        T1Media *media = info[@"T1Media"];
        if (media.expandedURL.length) {
            link = [NSURL URLWithString:media.expandedURL];
            linkTitle = media.displayURL;
        }
    }
    if (link) {
        YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:link];
        vc.title = linkTitle;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)cell:(T1StatusCell *)cell didClickImageAtIndex:(NSUInteger)index withLongPress:(BOOL)longPress {
    if (longPress) {
        // show alert
        return;
    }
    UIImageView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    NSArray<T1Media *> *images = cell.layout.images;
    
    for (NSUInteger i = 0, max = images.count; i < max; i++) {
        UIImageView *imgView = cell.statusView.mediaView.imageViews[i];
        T1Media *img = images[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = img.mediaLarge.url;
        item.largeImageSize = img.mediaLarge.size;
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

- (void)cell:(T1StatusCell *)cell didClickQuoteWithLongPress:(BOOL)longPress {
    
}

- (void)cell:(T1StatusCell *)cell didClickAvatarWithLongPress:(BOOL)longPress {
    
}

- (void)cell:(T1StatusCell *)cell didClickContentWithLongPress:(BOOL)longPress {
    
}

- (void)cellDidClickReply:(T1StatusCell *)cell {
    
}

- (void)cellDidClickRetweet:(T1StatusCell *)cell {
    T1StatusLayout *layout = cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    if (tweet.retweeted) {
        tweet.retweeted = NO;
        if (tweet.retweetCount > 0) tweet.retweetCount--;
        layout.retweetCountTextLayout = [layout retweetCountTextLayoutForTweet:tweet];
    } else {
        tweet.retweeted = YES;
        tweet.retweetCount++;
        layout.retweetCountTextLayout = [layout retweetCountTextLayoutForTweet:tweet];
    }
    [cell.statusView.inlineActionsView updateRetweetWithAnimation];
}

- (void)cellDidClickFavorite:(T1StatusCell *)cell {
    T1StatusLayout *layout = cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    if (tweet.favorited) {
        tweet.favorited = NO;
        if (tweet.favoriteCount > 0) tweet.favoriteCount--;
        layout.favoriteCountTextLayout = [layout favoriteCountTextLayoutForTweet:tweet];
    } else {
        tweet.favorited = YES;
        tweet.favoriteCount++;
        layout.favoriteCountTextLayout = [layout favoriteCountTextLayoutForTweet:tweet];
    }
    [cell.statusView.inlineActionsView updateFavouriteWithAnimation];
}

- (void)cellDidClickFollow:(T1StatusCell *)cell {
    T1StatusLayout *layout = cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    tweet.user.following = !tweet.user.following;
    [cell.statusView.inlineActionsView updateFollowWithAnimation];
}

@end
