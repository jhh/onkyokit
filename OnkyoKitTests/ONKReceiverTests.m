//
//  ONKReceiverTests.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/15/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ONKReceiver_Private.h"
#import "ONKService.h"
#import "ONKCharacteristic.h"
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
    receiver = [[ONKReceiver alloc] initWithModel:@"Test Model" uniqueIdentifier:@"123ABC" address:@"127.0.0.1" port:60128];
    XCTAssertNotNil(receiver);
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
