//
//  ONKReceiverErrorTest.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/21/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import XCTest;
@import OnkyoKit;
#import "ONKReceiver_Private.h"

@interface ONKReceiverErrorTest : XCTestCase <ONKReceiverDelegate>
@property (getter = hasPassed) BOOL passed;
@end

@implementation ONKReceiverErrorTest

- (void)receiver:(ONKReceiver *)receiver didSendEvent:(EISCPPacket *)event
{

}

- (void)receiver:(ONKReceiver *)receiver didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    self.passed = YES;
}

- (void)setUp
{
    [super setUp];
    self.passed = NO;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInitializer
{
    ONKReceiver *receiver = [[ONKReceiver alloc] initWithModel:nil uniqueIdentifier:@"a" address:@"b" port:1];
    XCTAssertNil(receiver);
    receiver = [[ONKReceiver alloc] initWithModel:@"a" uniqueIdentifier:nil address:@"b" port:1];
    XCTAssertNil(receiver);
    receiver = [[ONKReceiver alloc] initWithModel:@"a" uniqueIdentifier:@"b" address:nil port:1];
    XCTAssertNil(receiver);
    receiver = [[ONKReceiver alloc] initWithModel:@"a" uniqueIdentifier:@"b" address:@"c" port:0];
    XCTAssertNil(receiver);
}

- (void)testAddressParseError
{
    ONKReceiver *receiver = [[ONKReceiver alloc] initWithModel:@"Model A" uniqueIdentifier:@"1234" address:@"-1.-1.-1.-1" port:1];
    receiver.delegate = self;
    receiver.delegateQueue = [NSOperationQueue currentQueue];
    ONKReceiverSession *session = [[ONKReceiverSession alloc] initWithReceiver:receiver];
    [session resume];
    XCTAssert(self.hasPassed, @"Did not see didFailWithError called");
}

// assumes this machine is not listening on port 1: Routing Table Maintenance Protocol
- (void)testConnectError
{
    ONKReceiver *receiver = [[ONKReceiver alloc] initWithModel:@"Model A" uniqueIdentifier:@"1234" address:@"127.0.0.1" port:1];
    receiver.delegate = self;
    receiver.delegateQueue = [NSOperationQueue currentQueue];
    ONKReceiverSession *session = [[ONKReceiverSession alloc] initWithReceiver:receiver];
    [session resume];
    XCTAssert(self.hasPassed, @"Did not see didFailWithError called");
}
@end
