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
#import "ONKCharacteristic_Private.h"
#import <OCMock/OCMock.h>

@interface ONKReceiverTests : XCTestCase

@end

@implementation ONKReceiverTests
{
    ONKReceiver *receiver;
    ONKService *service;
}

- (void)setUp
{
    [super setUp];
    NSString *name = @"Test Receiver A", *uniqueID = @"hVaUtiBeQHh2w", *addr = @"127.0.0.1";
    receiver = [[ONKReceiver alloc] initWithModel:name uniqueIdentifier:uniqueID address:addr port:60128];
    service = receiver.services[0];
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

}

- (void)testServiceProperties
{
    XCTAssertEqualObjects(service.name, @"Main Zone");
    ONKReceiver *cachedReceiver = service.receiver;
    XCTAssertEqual(cachedReceiver, receiver);
}

- (void)testCharacteristicProperties
{
    ONKCharacteristic *characteristic = service.characteristics[0];
    XCTAssertEqualObjects(characteristic.name, @"System Power");
    XCTAssertEqualObjects(characteristic.characteristicType, @"onkyo.pwr");
    XCTAssertEqualObjects(characteristic.code, @"PWR");
    ONKService *cachedService = characteristic.service;
    XCTAssertEqual(cachedService, service);
}

@end
