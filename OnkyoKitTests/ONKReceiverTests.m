//
//  ONKReceiverTests.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/15/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

@import XCTest;
@import OnkyoKit;
#import "ONKReceiver_Private.h"
#import <OCMock/OCMock.h>

@interface ONKReceiverTests : XCTestCase

@end

@implementation ONKReceiverTests
{
    ONKReceiver *receiver;
}

- (void)setUp
{
    [super setUp];
    NSString *name = @"Test Receiver A", *uniqueID = @"hVaUtiBeQHh2w", *addr = @"127.0.0.1";
    receiver = [[ONKReceiver alloc] initWithModel:name uniqueIdentifier:uniqueID address:addr port:60128];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReceiverProperties
{
    XCTAssertNotNil(receiver);
    XCTAssertEqualObjects(receiver.model, @"Test Receiver A");
    XCTAssertEqualObjects(receiver.uniqueIdentifier, @"hVaUtiBeQHh2w");
    XCTAssertEqualObjects(receiver.address, @"127.0.0.1");
    XCTAssertEqual(receiver.port, 60128);

    NSArray *services = receiver.services;
    XCTAssertNotNil(services);
    XCTAssertTrue([services[0] isKindOfClass:[ONKService class]]);
}

- (void)testServiceProperties
{
}

- (void)testCharacteristicProperties
{
//    XCTAssertNotNil([characteristic characteristicType]);
}


@end
