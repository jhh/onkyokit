//
//  ONKReceiverSession.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/14/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

@import Foundation;
#import "ONKConfiguredReceiver.h"

@interface ONKReceiverSession : NSObject

/** The associated receiver. */
@property (weak, readonly, nonatomic) ONKConfiguredReceiver *receiver;

/** Contains any encountered error. */
@property (nonatomic) NSError *error;

#pragma mark Initializers

- (instancetype)initWithConfiguredReceiver:(ONKConfiguredReceiver *)receiver;

#pragma mark Instance Methods

/** Start or resume the connection to the remote device. */
- (void)resume;

/** Suspend the connection to the remote device. */
- (void)suspend;

/** Sends command after 200ms delay. */
- (void)sendCommand:(NSString *)command;

@end