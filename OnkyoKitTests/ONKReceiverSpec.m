//
//  ONKReceiverSpec.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/4/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

SpecBegin(ONKReceiver)

describe(@"ONKReceiver", ^{

    it(@"should do something", ^{
        expect(@"foo").to.equal(@"foo");
    });
    
    it(@"should mock", ^{
        id receiver = [OCMockObject mockForClass:[ONKReceiver class]];
        [[receiver expect] aMethod:@"foo"];
        [receiver aMethod:@"foo"];
        [receiver verify];
    });
    
});

SpecEnd