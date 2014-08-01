//
//  ONKCharacteristicNetworkTests.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/26/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "ONKReceiver_Private.h"

@interface ONKCharacteristicNetworkTests : XCTestCase <ONKReceiverDelegate>

@property ONKCharacteristic *characteristic;
@property XCTestExpectation *delegateCalledExpectation;

@end

@implementation ONKCharacteristicNetworkTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testCharacteristicRead
{
    self.delegateCalledExpectation = [self expectationWithDescription:@"delegate called"];
    NSString *address = [[NSProcessInfo processInfo] environment][@"ONK_ADDRESS"];
    NSAssert(address != nil, @"ONK_ADDRESS environment variable must be set - see test comments");

    ONKReceiver *receiver = [[ONKReceiver alloc] initWithModel:@"Test" uniqueIdentifier:@"123" address:address port:60128];
    receiver.delegate = self;
    receiver.delegateQueue = [[NSOperationQueue alloc] init];
    ONKCharacteristic *c = [receiver.services[0] findCharacteristicWithType:ONKCharacteristicTypeMuteState];
    [c readValueWithCompletionHandler:nil];
    [self waitForExpectationsWithTimeout:1 handler:nil];
    XCTAssertNotNil(self.characteristic);
    XCTAssertEqualObjects(self.characteristic, c);
}

// ONKReceiverDelegate
- (void)receiver:(ONKReceiver *)receiver service:(ONKService *)service didUpdateValueForCharacteristic:(ONKCharacteristic *)characteristic
{
    self.characteristic = characteristic;
    [self.delegateCalledExpectation fulfill];
}

@end
