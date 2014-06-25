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


- (instancetype)initWithModel:(NSString *)model
             uniqueIdentifier:(NSString *)uniqueIdentifier
                      address:(NSString *)address
                         port:(UInt16)port
{
    self = [super init];
    if (self && model && uniqueIdentifier && address && port > 0) {
        _model = [model copy];
        _uniqueIdentifier = [uniqueIdentifier copy];
        _address = address;
        _port = port;
        _session = [[ONKReceiverSession alloc] initWithReceiver:self];
    } else {
        self = nil;
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"ONKReciever: %@ (%@)", self.model, self.uniqueIdentifier];
}

@end
