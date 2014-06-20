//
//  ONKReciever.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//
#import "ONKReceiver_Private.h"
#import "ONKReceiverSession.h"
#import "ONKService_Private.h"

@implementation ONKReceiver

- (instancetype)init
{
    self = [super init];
    if (self) {
        _services = @[ [[ONKService alloc] initWithReceiver:self] ];
    }
    return self;
}

- (instancetype)initWithAddress:(NSString *)address port:(NSUInteger)port
{
    NSParameterAssert(address != nil);
    NSParameterAssert(port > 0 && port < 65535);

    self = [super init];
    if (self) {
        _address = address;
        _port = port;
        _session = [[ONKReceiverSession alloc] initWithReceiver:self];
    }
    return self;
}

- (void)resume
{
    [((ONKReceiver *)self).session resume];
}

- (void)suspend
{
    [((ONKReceiver *)self).session suspend];
}

- (void)sendCommand:(NSString *)command
{
    [((ONKReceiver *)self).session sendCommand:command];

}

@end
