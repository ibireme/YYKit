//
//  YYTextAsyncExample.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTextAsyncExample.h"
#import "YYKit.h"
#import "YYFPSLabel.h"

#define kCellHeight 34

@interface YYTextAsyncExampleCell : UITableViewCell
@property (nonatomic, assign) BOOL async;
- (void)setAyncText:(NSAttributedString *)text;
@end


@implementation YYTextAsyncExampleCell {
    UILabel *_uiLabel;
    YYLabel *_yyLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _uiLabel = [UILabel new];
    _uiLabel.font = [UIFont systemFontOfSize:8];
    _uiLabel.numberOfLines = 0;
    _uiLabel.size = CGSizeMake(kScreenWidth, kCellHeight);
    
    _yyLabel = [YYLabel new];
    _yyLabel.font = _uiLabel.font;
    _yyLabel.numberOfLines = _uiLabel.numberOfLines;
    _yyLabel.size = _uiLabel.size;
    _yyLabel.displaysAsynchronously = YES; /// enable async display
    _yyLabel.hidden = YES;
    
    [self.contentView addSubview:_uiLabel];
    [self.contentView addSubview:_yyLabel];
    return self;
}

- (void)setAsync:(BOOL)async {
    if (_async == async) return;
    _async = async;
    _uiLabel.hidden = async;
    _yyLabel.hidden = !async;
}

- (void)setAyncText:(id)text {
    if (_async) {
        _yyLabel.layer.contents = nil;
        _yyLabel.textLayout = text;
    } else {
        _uiLabel.attributedText = text;
    }
}

@end


@interface YYTextAsyncExample () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL async;
@property (nonatomic, strong) NSArray *strings;
@property (nonatomic, strong) NSArray *layouts;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YYTextAsyncExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [UITableView new];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[YYTextAsyncExampleCell class] forCellReuseIdentifier:@"id"];
    [self.view addSubview:self.tableView];
    
    
    
    NSMutableArray *strings = [NSMutableArray new];
    NSMutableArray *layouts = [NSMutableArray new];
    for (int i = 0; i < 300; i++) {
        NSString *str = [NSString stringWithFormat:@"%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫",i];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        text.font = [UIFont systemFontOfSize:10];
        text.lineSpacing = 0;
        text.strokeWidth = @(-3);
        text.strokeColor = [UIColor redColor];
        text.lineHeightMultiple = 1;
        text.maximumLineHeight = 12;
        text.minimumLineHeight = 12;
        
        NSShadow *shadow = [NSShadow new];
        shadow.shadowBlurRadius = 1;
        shadow.shadowColor = [UIColor redColor];
        shadow.shadowOffset = CGSizeMake(0, 1);
        [strings addObject:text];
        
        // it better to do layout in background queue...
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kCellHeight)];
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        [layouts addObject:layout];
    }
    self.strings = strings;
    self.layouts = layouts;
    
    
    
    UIView *toolbar;
    if ([UIVisualEffectView class]) {
        toolbar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    } else {
        toolbar = [UIToolbar new];
    }
    toolbar.size = CGSizeMake(kScreenWidth, 40);
    toolbar.top = kiOS7Later ? 64 : 0;
    [self.view addSubview:toolbar];
    
    
    YYFPSLabel *fps = [YYFPSLabel new];
    fps.centerY = toolbar.height / 2;
    fps.left = 5;
    [toolbar addSubview:fps];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"UILabel/YYLabel(Async): ";
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.centerY = toolbar.height / 2;
    label.left = fps.right + 10;
    [toolbar addSubview:label];
    
    UISwitch *switcher = [UISwitch new];
    [switcher sizeToFit];
    switcher.centerY = toolbar.height / 2;
    switcher.left = label.right + (kiOS7Later ? 10 : -10);
    switcher.layer.transformScale = 0.7;
    @weakify(self);
    [switcher addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch *switcher) {
        @strongify(self);
        if (!self) return;
        [self setAsync:switcher.isOn];
    }];
    [toolbar addSubview:switcher];
}

- (void)setAsync:(BOOL)async {
    _async = async;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(YYTextAsyncExampleCell *cell, NSUInteger idx, BOOL *stop) {
        cell.async = async;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (_async) {
            [cell setAyncText:_layouts[indexPath.row]];
        } else {
            [cell setAyncText:_strings[indexPath.row]];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _strings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYTextAsyncExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
    
    cell.async = _async;
    if (_async) {
        [cell setAyncText:_layouts[indexPath.row]];
    } else {
        [cell setAyncText:_strings[indexPath.row]];
    }
    
    return cell;
}

@end
