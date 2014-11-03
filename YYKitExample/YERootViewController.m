//
//  YERootViewController.m
//  YYKitExample
//
//  Created by ibireme on 14-10-13.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YERootViewController.h"

@interface YERootViewController ()
@property (nonatomic, strong) NSArray *classNames;
@end

@implementation YERootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YYKit Example";
    self.classNames = @[
                        @"NSObject",
                        @"NSData",
                        @"NSString",
                        @"NSArray",
                        @"NSDictionary",
                        @"NSData",
                        @"NSNumber",
                        @"NSNotificationCenter",
                        @"NSKeyedUnarchive",
                        @"NSTimer",
                        @"NSError",
                        @"UIDevice",
                        @"YYLabel",
                        ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@+YYAdd", self.classNames[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    className = [NSString stringWithFormat:@"YE%@Controller", className];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = [NSString stringWithFormat:@"%@+YYAdd", self.classNames[indexPath.row]];
        [self.navigationController pushViewController:ctrl animated:YES];
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
