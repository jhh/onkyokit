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
    ONKService *service;
    ONKCharacteristic *characteristic;
}

- (void)setUp
{
    [super setUp];
    // setup here
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReceiverProperties
{
    NSString *name = @"Test Receiver A", *uniqueID = @"hVaUtiBeQHh2w", *addr = @"127.0.0.1";
    receiver = [[ONKReceiver alloc] initWithModel:name uniqueIdentifier:uniqueID address:addr port:60128];
    XCTAssertNotNil(receiver);
    XCTAssertEqualObjects(receiver.model, name);
    XCTAssertEqualObjects(receiver.uniqueIdentifier, uniqueID);
    XCTAssertEqualObjects(receiver.address, addr);
    XCTAssertEqual(receiver.port, 60128);
}

- (void)testServiceProperties
{
//    XCTAssertNotNil(service.characteristics);
//    XCTAssertTrue([characteristic isKindOfClass:[ONKCharacteristic class]]);
}

- (void)testCharacteristicProperties
{
//    XCTAssertNotNil([characteristic characteristicType]);
}


@end
