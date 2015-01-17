//
//  EISCPPacketTest.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/22/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import XCTest;
#import "ISCPMessage.h"
#import "EISCPPacket.h"

@interface EISCPPacketTest : XCTestCase

@end

@implementation EISCPPacketTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHeader
{
    ISCPMessage *message = [[ISCPMessage alloc] initWithMessage:@"PWRQSTN"];
    EISCPPacket *packet = [[EISCPPacket alloc] initWithMessage:message];
    XCTAssertEqualObjects(packet.magic, @"ISCP");
    XCTAssertEqual(packet.headerLength, 16UL);
    XCTAssertEqual(packet.dataLength, 10UL);
    XCTAssertEqual(packet.version, 1UL);
}

@end
