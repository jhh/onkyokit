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

@interface ONKReceiverTests : XCTestCase <ONKReceiverDelegate>

@property (nonatomic) ONKReceiver *receiver;
@property (nonatomic) ONKService *service;
@property ONKCharacteristic *characteristic;

@end

@implementation ONKReceiverTests
{
    
    XCTestExpectation *delegateCalledExpectation;
}

- (void)setUp
{
    [super setUp];
    NSString *name = @"Test Receiver A", *uniqueID = @"hVaUtiBeQHh2w", *addr = @"127.0.0.1";
    self.receiver = [[ONKReceiver alloc] initWithModel:name uniqueIdentifier:uniqueID address:addr port:60128];
    self.service = self.receiver.services[0];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReceiverProperties
{
    XCTAssertNotNil(self.receiver);
    XCTAssertEqualObjects(self.receiver.model, @"Test Receiver A");
    XCTAssertEqualObjects(self.receiver.uniqueIdentifier, @"hVaUtiBeQHh2w");
    XCTAssertEqualObjects(self.receiver.address, @"127.0.0.1");
    XCTAssertEqual(self.receiver.port, 60128);

}

- (void)testServiceProperties
{
    XCTAssertEqualObjects(self.service.name, @"Main Zone");
    ONKReceiver *cachedReceiver = self.service.receiver;
    XCTAssertEqual(cachedReceiver, self.receiver);
}

- (void)testCharacteristicProperties
{
    ONKCharacteristic *c = self.service.characteristics[0];
    XCTAssertEqualObjects(c.name, @"System Power");
    XCTAssertEqualObjects(c.characteristicType, @"onkyo.pwr");
    XCTAssertEqualObjects(c.code, @"PWR");
    ONKService *cachedService = c.service;
    XCTAssertEqual(cachedService, self.service);
}

- (void)testCharacteristicMetadataProperties
{
    ONKCharacteristic *c = self.service.characteristics[0];
    ONKCharacteristicMetadata *meta = c.metadata;
    XCTAssertEqual([meta.minimumValue integerValue], 0);
    XCTAssertEqual([meta.maximumValue integerValue], 1);
    XCTAssertEqual(meta.units, ONKCharacteristicUnitBoolean);

    c = self.service.characteristics[1];
    meta = c.metadata;
    XCTAssertEqual([meta.minimumValue integerValue], 0);
    XCTAssertEqual([meta.maximumValue integerValue], 1);
    XCTAssertEqual(meta.units, ONKCharacteristicUnitBoolean);

    c = self.service.characteristics[2];
    meta = c.metadata;
    XCTAssertEqual([meta.minimumValue integerValue], 0);
    XCTAssertEqual([meta.maximumValue integerValue], 100);
    XCTAssertEqual(meta.units, ONKCharacteristicUnitNumeric);
}

- (void)testHandleBoolMessage
{
    ONKCharacteristic *c = self.service.characteristics[0];
    XCTAssertEqualObjects(c.characteristicType, ONKCharacteristicTypePowerState);
    XCTAssertEqual([c.value boolValue], NO);
    ISCPMessage *message = [[ISCPMessage alloc] initWithMessage:@"PWR01"];
    [self.receiver handleMessage:message];
    XCTAssertEqual([c.value boolValue], YES);

    c = self.service.characteristics[1];
    XCTAssertEqualObjects(c.characteristicType, ONKCharacteristicTypeMuteState);
    XCTAssertEqual([c.value boolValue], NO);
    message = [[ISCPMessage alloc] initWithMessage:@"AMT01"];
    [self.receiver handleMessage:message];
    XCTAssertEqual([c.value boolValue], YES);
}

- (void)testHandleNumericMessage
{
    ONKCharacteristic *c = self.service.characteristics[2];
    XCTAssertEqualObjects(c.characteristicType, ONKCharacteristicTypeMasterVolume);
    XCTAssertEqual([c.value integerValue], 0);
    ISCPMessage *message = [[ISCPMessage alloc] initWithMessage:@"MVL08"];
    [self.receiver handleMessage:message];
    XCTAssertEqual([c.value integerValue], 8);

    message = [[ISCPMessage alloc] initWithMessage:@"MVL0A"];
    [self.receiver handleMessage:message];
    XCTAssertEqual([c.value integerValue], 10);

    message = [[ISCPMessage alloc] initWithMessage:@"MVL64"];
    [self.receiver handleMessage:message];
    XCTAssertEqual([c.value integerValue], 100);

    message = [[ISCPMessage alloc] initWithMessage:@"MVLXX"];
    [self.receiver handleMessage:message];
    XCTAssertEqualObjects(c.value, [NSDecimalNumber notANumber]);
}

- (void)testDescription
{
    ISCPMessage *message = [[ISCPMessage alloc] initWithMessage:@"MVL2C"];
    ONKCharacteristic *c = self.service.characteristics[2];
    [c handleMessage:message];
    NSLog(@"DESCRIPTION: %@", c.description);

    message = [[ISCPMessage alloc] initWithMessage:@"AMT01"];
    c = self.service.characteristics[1];
    [c handleMessage:message];
    NSLog(@"DESCRIPTION: %@", c.description);
}

- (void)testCallingDelegate
{
    delegateCalledExpectation = [self expectationWithDescription:@"delegate called"];
    self.receiver.delegate = self;
    self.receiver.delegateQueue = [[NSOperationQueue alloc] init];

    ISCPMessage *message = [[ISCPMessage alloc] initWithMessage:@"MVL08"];
    [self.receiver handleMessage:message];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

// ONKReceiverDelegate
- (void)receiver:(ONKReceiver *)receiver service:(ONKService *)service didUpdateValueForCharacteristic:(ONKCharacteristic *)characteristic
{
    self.characteristic = characteristic;
    ONKCharacteristic *c = self.service.characteristics[2];
    XCTAssertEqualObjects(c, self.characteristic);
    XCTAssertEqual([self.characteristic.value integerValue], 8);
    [delegateCalledExpectation fulfill];
}

@end
