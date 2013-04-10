//
//  YYKitTests.m
//  YYKitTests
//
//  Created by ibireme on 13-4-10.
//  2013 ibireme.
//

#import "YYKitTests.h"
#import "YYCore.h"

@implementation YYKitTests

- (void)setUp {
    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testNSStringYYAdd {
    //STFail(@"Unit tests are not implemented yet in YYKitTests");
    STAssertEqualObjects([@"123456" md5], @"e10adc3949ba59abbe56e057f20f883e", @"md5 test");
    STAssertEqualObjects([@"123456" sha1], @"7c4a8d09ca3762af61e59520943dc26494f8941b", @"sha1 test");
    STAssertEqualObjects([@"123456" sha224], @"f8cdb04495ded47615258f9dc6a3f4707fd2405434fefc3cbf4ef4e6", @"sha224 test");
    STAssertEqualObjects([@"123456" sha256], @"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92", @"sha256 test");
    STAssertEqualObjects([@"123456" sha384], @"0a989ebc4a77b56a6e2bb7b19d995d185ce44090c13e2984b7ecc6d446d4b61ea9991b76a4c2f04b1b4d244841449454", @"sha384 test");
    STAssertEqualObjects([@"123456" sha512], @"ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413", @"sha512 test");
    
    for (int i=0; i<10; i++) {
        NSLog(@"%@",[@"123456" hmacWithKey:@"password"]);

    }
    
   // STAssertEqualObjects([@"123456" hmacWithKey:@"password"], @"5b5f3b669029c832f441444bb75e956f5887015d", @"hmac test");
    
    //hmac md5  49a15811ea47e8e9c6d8f3ef4d7bbc54
    //hmac sha1 5b5f3b669029c832f441444bb75e956f5887015d
    //hmac sha256 5c5a5361d3506a4f18d4c47a73da241668d41e3233626e8aafa3fdb2e4a50cea
    //hmac sha512 0c2957ba55be4a9424cab6c8995e57efb1662c21b4a5748c0d59e5ea9b739d215f48a9cbee860fdd82c4b6e938ad33aad1c5405d2adb579aae4c9e32666d3eb0
    
    //STAssertEqualObjects([@"123456!$%^の" stringByBase64Encoding], @"MTIzNDU2ISQlXuOBrg==", @"hmac test");
    //STAssertEqualObjects([@"MTIzNDU2ISQlXuOBrg==" string], @"", @"hmac test");
    

}

@end
