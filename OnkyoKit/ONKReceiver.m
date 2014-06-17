//
//  ONKController.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//
#import "ONKReceiver.h"
#import "ONKReceiverSession.h"
#import "ONKConfiguredReceiver.h"
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

- (void)resume
{
    [((ONKConfiguredReceiver *)self).session resume];
}

- (void)suspend
{
    [((ONKConfiguredReceiver *)self).session suspend];
}

- (void)sendCommand:(NSString *)command
{
    [((ONKConfiguredReceiver *)self).session sendCommand:command];

}

@end
