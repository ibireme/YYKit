//
//  YYTextExample.m
//  YYKitExample
//
//  Created by ibireme on 15/7/18.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTextExample.h"
#import "YYKit.h"
#import <time.h>

@interface YYTextExample()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation YYTextExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self addCell:@"Text Attributes 1" class:@"YYTextAttributeExample"];
    [self addCell:@"Text Attributes 2" class:@"YYTextTagExample"];
    [self addCell:@"Text Attachments" class:@"YYTextAttachmentExample"];
    [self addCell:@"Text Edit" class:@"YYTextEditExample"];
    [self addCell:@"Text Parser (Markdown)" class:@"YYTextMarkdownExample"];
    [self addCell:@"Text Parser (Emoticon)" class:@"YYTextEmoticonExample"];
    [self addCell:@"Text Binding" class:@"YYTextBindingExample"];
    [self addCell:@"Copy and Paste" class:@"YYTextCopyPasteExample"];
    [self addCell:@"Undo and Redo" class:@"YYTextUndoRedoExample"];
    [self addCell:@"Ruby Annotation" class:@"YYTextRubyExample"];
    [self addCell:@"Async Display" class:@"YYTextAsyncExample"];
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
