//
//  YYKeychainExample.m
//  YYKitDemo
//
//  Created by ibireme on 16/2/24.
//  Copyright  2016 ibireme. All rights reserved.
//

#import "YYKeychainExample.h"
#import "YYKit.h"

static NSString *const kServiceName = @"Facebook";
static NSString *const kAccountName = @"ibireme";
static NSString *const kPassword = @"123456";
static NSString *const kLabel = @"Example";


/*
 Some testcase copy from SSKeychain:
 https://github.com/soffes/sskeychain/blob/master/Tests/SSKeychainTests.m
 */
@implementation YYKeychainExample


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [UILabel new];
    label.text = @"see YYKeychainExample.m";
    [label sizeToFit];
    label.centerX = self.view.width / 2;
    label.centerY = self.view.height / 2;
    [self.view addSubview:label];
    [self test];
}

- (void)test {
    [self testNewItem];
    [self testPasswordObject];
    [self testMissingInformation];
    [self testDeleteWithMissingInformation];
    [self testKeychain];
}


- (void)testNewItem {
    // New item
    YYKeychainItem *item = [[YYKeychainItem alloc] init];
    item.password = kPassword;
    item.service = kServiceName;
    item.account = kAccountName;
    item.label = kLabel;
    
    NSError *error = nil;
    NSAssert([YYKeychain insertItem:item error:&error], @"Unable to save item: %@", error);
    
    // Look up
    item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    item.account = kAccountName;
    item.password = nil;
    
    NSAssert([YYKeychain selectOneItem:item error:&error], @"Unable to fetch keychain item: %@", error);
    NSAssert([[YYKeychain selectOneItem:item error:&error].password isEqualToString: kPassword], @"Passwords were not equal");
    
    // Search for all accounts
    item = [[YYKeychainItem alloc] init];
    NSArray *accounts = [YYKeychain selectItems:item error:&error];
    NSAssert(accounts, @"Unable to fetch accounts: %@", error);
    NSAssert([self _accounts:accounts containsAccountWithName:kAccountName], @"Matching account was not returned");
    
    // Check accounts for service
    item.service = kServiceName;
    accounts = [YYKeychain selectItems:item error:&error];
    NSAssert(accounts, @"Unable to fetch accounts: %@", error);
    NSAssert([self _accounts:accounts containsAccountWithName:kAccountName], @"Matching account was not returned");
    
    // Delete
    item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    item.account = kAccountName;
    NSAssert([YYKeychain deleteItem:item error:&error], @"Unable to delete password: %@", error);
}


- (void)testPasswordObject {
    YYKeychainItem *item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    item.account = kAccountName;
    
    NSDictionary *dictionary = @{@"number": @42, @"string": @"Hello World"};
    item.passwordObject = dictionary;
    
    __unused NSError *error = nil;
    NSAssert([YYKeychain insertItem:item error:&error], @"Unable to save item: %@", error);
    
    item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    item.account = kAccountName;
    item.passwordObject = nil;
    
    NSAssert([YYKeychain selectOneItem:item error:&error], @"Unable to fetch keychain item: %@", error);
    NSAssert([((NSObject *)[YYKeychain selectOneItem:item error:&error].passwordObject) isEqual:dictionary], @"Passwords were not equal");
}

- (void)testMissingInformation {
    YYKeychainItem *item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    item.account = kAccountName;
    
    __unused NSError *error = nil;
    NSAssert([YYKeychain insertItem:item error:&error] == NO, @"Function should return NO as not all needed information is provided: %@", error);
    
    item = [[YYKeychainItem alloc] init];
    item.password = kPassword;
    item.account = kAccountName;
    NSAssert([YYKeychain insertItem:item error:&error] == NO, @"Function should return NO as not all needed information is provided: %@", error);
    
    item = [[YYKeychainItem alloc] init];
    item.password = kPassword;
    item.service = kServiceName;
    NSAssert([YYKeychain insertItem:item error:&error] == NO, @"Function save should return NO if not all needed information is provided: %@", error);
}

- (void)testDeleteWithMissingInformation {
    YYKeychainItem *item = [[YYKeychainItem alloc] init];
    item.account = kAccountName;
    
    __unused NSError *error;
    NSAssert([YYKeychain deleteItem:item error:&error] == NO, @"Function deleteItem should return NO if not all needed information is provided: %@", error);
    
    item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    NSAssert([YYKeychain deleteItem:item error:&error] == NO, @"Function deleteItem should return NO if not all needed information is provided: %@", error);
    
    // check if fetch handels missing information correctly
    item = [[YYKeychainItem alloc] init];
    item.account = kAccountName;
    NSAssert([YYKeychain selectOneItem:item error:&error] == nil, @"Function fetch should return NO if not all needed information is provided: %@", error);
    
    item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    NSAssert([YYKeychain selectOneItem:item error:&error] == nil, @"Function fetch should return NO if not all needed information is provided: %@", error);
    
    item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    NSAssert([YYKeychain selectOneItem:item error:NULL] == nil, @"Function fetch should return NO if not all needed information is provided and error is NULL");
}


- (void)testSynchronizable {
    YYKeychainItem *item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    item.account = kAccountName;
    item.password = kPassword;
    item.synchronizable = YYKeychainQuerySynchronizationModeYes;
    
    __unused NSError *error;
    NSAssert([YYKeychain insertItem:item error:&error], @"Unable to save item: %@", error);
    
    item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    item.account = kAccountName;
    item.password = nil;
    item.synchronizable = YYKeychainQuerySynchronizationModeNo;
    NSAssert([YYKeychain selectOneItem:item error:&error] == nil, @"Fetch should fail when trying to fetch an unsynced password that was saved as synced: %@", error);
    NSAssert([YYKeychain selectOneItem:item error:NULL] == nil, @"Fetch should fail when trying to fetch an unsynced password that was saved as synced. error == NULL");
    
    NSAssert([item.password isEqualToString:kPassword] == NO, @"Passwords should not be equal when trying to fetch an unsynced password that was saved as synced.");
    
    item = [[YYKeychainItem alloc] init];
    item.service = kServiceName;
    item.account = kAccountName;
    item.password = nil;
    item.synchronizable = YYKeychainQuerySynchronizationModeAny;
    NSAssert([YYKeychain selectOneItem:item error:&error], @"Unable to fetch keychain item: %@", error);
    NSAssert([[YYKeychain selectOneItem:item error:&error].password isEqualToString:kPassword], @"Passwords were not equal");
    [YYKeychain deleteItem:item error:NULL];
}


- (void)testKeychain {
    __unused NSError *error = nil;
    
    // create a new keychain item
    NSAssert([YYKeychain setPassword:kPassword forService:kServiceName account:kAccountName error:&error], @"Unable to save item: %@", error);
    
    
    [[YYKeychain getPasswordForService:kServiceName account:kAccountName error:NULL] isEqualToString:kPassword];
    
    
    // check password
    NSAssert([[YYKeychain getPasswordForService:kServiceName account:kAccountName error:NULL] isEqualToString:kPassword], @"Passwords were not equal");
    
    // delete password
    NSAssert([YYKeychain deletePasswordForService:kServiceName account:kAccountName error:&error], @"Unable to delete password: %@", error);
}

- (BOOL)_accounts:(NSArray *)items containsAccountWithName:(NSString *)name {
    for (YYKeychainItem *item in items) {
        if ([item.account isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

@end
