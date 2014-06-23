//
//  ONKReceiverTests.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/15/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ONKReceiver.h"
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
    receiver = [[ONKReceiver alloc] init];
    service = receiver.services[0];
    characteristic = service.characteristics[0];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testServicesArray
{
    XCTAssertNotNil(receiver.services);
    XCTAssertTrue([service isKindOfClass:[ONKService class]]);
}

- (void)testCharacteristicsArray
{
    XCTAssertNotNil(service.characteristics);
    XCTAssertTrue([characteristic isKindOfClass:[ONKCharacteristic class]]);
}

- (void)testCharacteristic
{
    XCTAssertNotNil([characteristic characteristicType]);
}

- (void)testMock
{
    id mock = OCMClassMock([ONKReceiver class]);
    OCMStub([mock services]).andReturn([NSArray array]);
    NSLog(@"%@", [mock services]);
}
@end
