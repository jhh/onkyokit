//
//  ONKControllerTest.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/12/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ONKControllerTest.h"
#import <OnkyoKit/ISCPMessage.h>

#define NO_EVENT 0
#define HAS_EVENT 1

// Tests sending command and receiving corresponding event.
//
// These tests is run as part of the "OnkyoKit Mac Network Tests" scheme. To run
// these tests you must set the ONK_ADDRESS environment variable to the address of
// a suitable Onkyo test device. The ONK_ADDRESS variable is set in the scheme
// definition.
//
// We utilize NSCondition to synchronize between GCD threads since this is
// asynchronous.
@implementation ONKControllerTest

- (void) controller:(ONKController *)controller didReceiveEvent:(ONKEvent *)event {
    NSLog(@"ONKControllerTest event received: %@", event);

    // sanity checks on recieved packets
    STAssertEqualObjects(@"ISCP", event.magic, @"Packet magic did not match.");
    STAssertEquals(1UL, event.version, @"Packet version did not match.");

    if ([[event description] hasPrefix:@"PWR"]) {
        [self.condition lock];
        self.passed = YES;
        [self.condition signal];
        [self.condition unlock];
    }
}

- (void)testSendCommand {
    self.controller = [[ONKController alloc] initWithDelegate:self
                                                delegateQueue:dispatch_queue_create("ONKControllerTest", DISPATCH_QUEUE_SERIAL)];
    XCTAssertNotNil(self.controller, @"Could not create test subject.");
    
    NSString *address = [[NSProcessInfo processInfo] environment][@"ONK_ADDRESS"];
    XCTAssertTrue([self.controller connectToHost:address error:nil], @"Could not connect to remote device");

    self.condition = [NSCondition new];

    [self.condition lock];
    self.passed = NO;
    [self.controller sendCommand:@"PWRQSTN"];
    
    // wait 1 sec for response to be sent.
    [self.condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

    XCTAssertTrue(self.hasPassed, @"Did not see event for command sent.");
    [self.condition unlock];
    
    [self.controller close];
}

@end
