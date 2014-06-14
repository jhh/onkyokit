//
//  ONKDeviceBrowserTest.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/1/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OnkyoKit/OnkyoKit.h>

@interface ONKDeviceBrowserTest : XCTestCase <ONKReceiverBrowserDelegate>

@property NSMutableArray *receivers;
@property NSCondition *condition;
@property NSInteger notificationCount;

@end

// Tests device discovery protocol.
//
// These tests is run as part of the "OnkyoKit Mac Network Tests" scheme. This test
// requires an Onkyo AV receiver to be on the local network or the Onkyo Simulator
// ( https://github.com/jhh/onkyo-simulator/ ) to be running.
//
// We utilize NSCondition to synchronize since discovery is asynchronous.
@implementation ONKDeviceBrowserTest

- (void)setUp
{
    [super setUp];
    self.notificationCount = 0;
    self.condition = [NSCondition new];
}

- (void)tearDown
{
    self.condition = nil;
    [super tearDown];
}

- (void)receiverBrowser:(ONKDeviceBrowser *)browser didFindNewReceiver:(ONKReceiver *)receiver
{
    self.notificationCount++;
    XCTAssertEqual([browser.discoveredReceivers count], self.notificationCount);
}

- (void)testDiscover
{
    ONKDeviceBrowser *browser = [[ONKDeviceBrowser alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"ONKDeviceBrowserTest Queue";
    [browser setDelegate:self delegateQueue:queue];
    [self.condition lock];
    [browser startSearchingForNewReceivers];

    // wait for completion handler to signal condition
    [self.condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:4]];
    [self.condition unlock];

    XCTAssertTrue(self.notificationCount > 0, @"Did not receive any notifications.");
    XCTAssertEqual([browser.discoveredReceivers count], self.notificationCount);
}

@end
