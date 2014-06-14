//
//  ONKReceiverImpl.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/14/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKConfiguredReceiver.h"
#import "ONKReceiverSession.h"

@implementation ONKConfiguredReceiver

- (instancetype)initWithAddress:(NSString *)address port:(NSUInteger)port
{
    NSParameterAssert(address != nil);
    NSParameterAssert(port > 0 && port < 65535);

    self = [super init];
    if (self) {
        _address = address;
        _port = port;
        _session = [[ONKReceiverSession alloc] initWithConfiguredReceiver:self];
    }
    return self;
}

@end
