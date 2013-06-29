//
//  ONKControllerTest.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/12/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OnkyoKit/ISCPMessage.h>

@interface ONKReceiverTest : XCTestCase <ONKDelegate>
@property ONKReceiver *receiver;
@property (getter = hasPassed) BOOL passed;
@property NSCondition *condition;
- (void) receiver:(ONKReceiver *)receiver didSendEvent:(ONKEvent *)event;
@end

// Tests sending command and receiving corresponding event.
//
// These tests is run as part of the "OnkyoKit Mac Network Tests" scheme. To run
// these tests you must set the ONK_ADDRESS environment variable to the address of
// a suitable Onkyo test device. The ONK_ADDRESS variable is set in the scheme
// definition.
//
// We utilize NSCondition to synchronize between GCD threads since this is
// asynchronous.
@implementation ONKReceiverTest

- (void) receiver:(ONKReceiver *)receiver didSendEvent:(ONKEvent *)event {
    NSLog(@"ONKControllerTest event received: %@", event);

    // sanity checks on recieved packets
    XCTAssertEqualObjects(@"ISCP", event.magic, @"Packet magic did not match.");
    XCTAssertEquals(1UL, event.version, @"Packet version did not match.");
    XCTAssertEquals(16UL, event.headerLength, @"Header length did not match.");

    if ([[event description] hasPrefix:@"PWR"]) {
        [self.condition lock];
        self.passed = YES;
        [self.condition signal];
        [self.condition unlock];
    }
}

- (void)setUp {
    [super setUp];
    self.condition = [NSCondition new];
}

- (void)tearDown {
    self.condition = nil;
    [super tearDown];
}

- (void)testSendCommand {
    self.receiver = [[ONKReceiver alloc] initWithDelegate:self
                                                delegateQueue:dispatch_queue_create("ONKControllerTest", DISPATCH_QUEUE_SERIAL)];
    XCTAssertNotNil(self.receiver, @"Could not create test subject.");
    
    NSString *address = [[NSProcessInfo processInfo] environment][@"ONK_ADDRESS"];
    NSAssert(address != nil, @"ONK_ADDRESS environment variable must be set - see test comments");
    XCTAssertTrue([self.receiver connectToHost:address error:nil], @"Could not connect to remote device");

    [self.condition lock];
    self.passed = NO;
    [self.receiver sendCommand:@"PWRQSTN"];
    
    // wait 1 sec for response to be sent.
    [self.condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

    XCTAssertTrue(self.hasPassed, @"Did not see event for command sent.");
    [self.condition unlock];
    
    [self.receiver close];
}

@end
