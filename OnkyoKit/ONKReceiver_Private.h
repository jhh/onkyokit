//
//  ONKReceiver_Private.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import <OnkyoKit/OnkyoKit.h>
@class ONKReceiverSession;

@interface ONKReceiver ()

/** The hostname or IP address of the receiver. */
@property (readonly, nonatomic) NSString *address;

/** The IP port of the receiver. */
@property (readonly, nonatomic) UInt16 port;

/** The session object used to communicate with the receiver. */
@property (nonatomic) ONKReceiverSession *session;

/**
 Initialize a receiver object.

 @param address  The hostname or IP address of the remote device.
 @param port The port used by the remote device.
 */
- (instancetype)initWithAddress:(NSString *)address port:(UInt16)port;

@end
