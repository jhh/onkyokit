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

// TODO: implement error reporting
@implementation ONKReceiver

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"<%@ at %@:%lu (unique identifier: %@)>",
//            self.model, self.address, (unsigned long)_port, self.uniqueIdentifier];
//}

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
