//
//  ISCPMessageTest.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/11/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ISCPMessageTest.h"
#import <OnkyoKit/ISCPMessage.h>

@implementation ISCPMessageTest

- (void)testInitWithNilData {
    ISCPMessage *message;
    XCTAssertThrowsSpecificNamed(message = [[ISCPMessage alloc] initWithData:nil], NSException,
                                NSInternalInconsistencyException, @"should through exception for nil paramter");
}

- (void)testInitWithNilMessage {
    ISCPMessage *message;
    XCTAssertThrowsSpecificNamed(message = [[ISCPMessage alloc] initWithMessage:nil], NSException,
                                NSInternalInconsistencyException, @"should through exception for nil paramter");
}

- (void)testConvertDataDelimitedByEOF {
    NSString *msg = @"PWR01";
    ISCPMessage *iscp = [[ISCPMessage alloc] initWithData:[[NSString stringWithFormat:@"!1%@\x1a", msg] dataUsingEncoding:NSASCIIStringEncoding]];
    XCTAssertEqualObjects(iscp.message, msg, @"should convert data delimeted by EOF");
}

- (void)testConvertDataDelimitedByEOF_CR {
    NSString *msg = @"PWR01";
    ISCPMessage *iscp = [[ISCPMessage alloc] initWithData:[[NSString stringWithFormat:@"!1%@\x1a\r", msg] dataUsingEncoding:NSASCIIStringEncoding]];
    XCTAssertEqualObjects(iscp.message, msg, @"should convert data delimeted by EOF");
}

- (void)testConvertDataDelimitedByEOF_CR_LF {
    NSString *msg = @"PWR01";
    ISCPMessage *iscp = [[ISCPMessage alloc] initWithData:[[NSString stringWithFormat:@"!1%@\x1a\r\x0a", msg] dataUsingEncoding:NSASCIIStringEncoding]];
    XCTAssertEqualObjects(iscp.message, msg, @"should convert data delimeted by EOF");
}

- (void)testConvertMessageToData {
    NSString *msg = @"NLTF300001100120000FFFF00NE";
    ISCPMessage *iscp = [[ISCPMessage alloc] initWithMessage:msg];
    XCTAssertEqualObjects(iscp.data, ([[NSString stringWithFormat:@"!1%@\r", msg] dataUsingEncoding:NSASCIIStringEncoding]), @"should convert message to data");
}

@end
