//
//  ISCPMessageSpec.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <OnkyoKit/ISCPMessage.h>

SpecBegin(ISCPMessage)

describe(@"ISCPMessage", ^{

    it(@"should assert existence of data parameter in initWithData", ^{
        expect(^{
            ISCPMessage *message = [[ISCPMessage alloc] initWithData:nil];
            message = nil;
        }).to.raise(@"NSInternalInconsistencyException");
    });
    
    it(@"should assert existence of message parameter in initWithMessage", ^{
        expect(^{
            ISCPMessage *message = [[ISCPMessage alloc] initWithMessage:nil];
            message = nil;
        }).to.raise(@"NSInternalInconsistencyException");
    });
    
    it(@"should convert data delimited by EOF", ^{
        NSString *msg = @"PWR01";
        ISCPMessage *iscp = [[ISCPMessage alloc] initWithData:[[NSString stringWithFormat:@"!1%@\x1a", msg] dataUsingEncoding:NSASCIIStringEncoding]];
        expect(iscp.message).to.equal(msg);
    });
    
    it(@"should convert data delimited by EOF CR", ^{
        NSString *msg = @"NLSU0-My Favorites";
        ISCPMessage *iscp = [[ISCPMessage alloc] initWithData:[[NSString stringWithFormat:@"!1%@\x1a\r", msg] dataUsingEncoding:NSASCIIStringEncoding]];
        expect(iscp.message).to.equal(msg);
    });
    
    it(@"should convert data delimited by EOF CR LF", ^{
        NSString *msg = @"NLTF300001100120000FFFF00NE";
        ISCPMessage *iscp = [[ISCPMessage alloc] initWithData:[[NSString stringWithFormat:@"!1%@\x1a\r\x0a", msg] dataUsingEncoding:NSASCIIStringEncoding]];
        expect(iscp.message).to.equal(msg);
    });

    it(@"should convert message to data", ^{
        NSString *msg = @"NLTF300001100120000FFFF00NE";
        ISCPMessage *iscp = [[ISCPMessage alloc] initWithMessage:msg];
        expect(iscp.data).to.equal( ([NSString stringWithFormat:@"!1%@\r", msg]) );
    });
    
});

SpecEnd