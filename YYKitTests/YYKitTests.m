//
//  YYKitTests.m
//  YYKitTests
//
//  Created by ibireme on 13-4-10.
//  Copyright 2013 ibireme.
//

#import "YYKitTests.h"
#import "YYKit.h"


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
    STAssertEqualObjects([@"123456" md2], @"d4541250b586296fcce5dea4463ae17f", @"md5 test");
    STAssertEqualObjects([@"123456" md4], @"585028aa0f794af812ee3be8804eb14a", @"md5 test");
    STAssertEqualObjects([@"123456" md5], @"e10adc3949ba59abbe56e057f20f883e", @"md5 test");
    STAssertEqualObjects([@"123456" sha1], @"7c4a8d09ca3762af61e59520943dc26494f8941b", @"sha1 test");
    STAssertEqualObjects([@"123456" sha224], @"f8cdb04495ded47615258f9dc6a3f4707fd2405434fefc3cbf4ef4e6", @"sha224 test");
    STAssertEqualObjects([@"123456" sha256], @"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92", @"sha256 test");
    STAssertEqualObjects([@"123456" sha384], @"0a989ebc4a77b56a6e2bb7b19d995d185ce44090c13e2984b7ecc6d446d4b61ea9991b76a4c2f04b1b4d244841449454", @"sha384 test");
    STAssertEqualObjects([@"123456" sha512], @"ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413", @"sha512 test");
    
}

@end
