//
//  ONKDeviceBrowserTest.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/1/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OnkyoKit/OnkyoKit.h>

@interface ONKDeviceBrowserTest : XCTestCase

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
    self.receivers = [NSMutableArray array];
    self.notificationCount = 0;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName:ONKReceiverWasDiscoveredNotification
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *note){
                    [self.receivers addObject:note.object];
                    XCTAssertEqualObjects(ONKReceiverWasDiscoveredNotification, note.name, @"Did not receive correct notification.");
                    self.notificationCount++;
                }];
    self.condition = [NSCondition new];
}

- (void)tearDown
{
    self.condition = nil;
    [super tearDown];
}

- (void)testDiscover
{
    ONKDeviceBrowser *browser = [[ONKDeviceBrowser alloc] initWithCompletionHandler:^{
        [self.condition lock];
        for (ONKReceiver *r in self.receivers) {
            XCTAssertNotNil(r);
            XCTAssertTrue([r isKindOfClass:[ONKReceiver class]]);
            NSLog(@"%@", r);
        }
        [self.condition signal];
        [self.condition unlock];
    }];

    [self.condition lock];
    [browser start];

    // wait for completion handler to signal condition
    [self.condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    [self.condition unlock];

    XCTAssertTrue(self.notificationCount > 0, @"Did not receive any notifications.");
}

@end
