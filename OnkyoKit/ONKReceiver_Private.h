//
//  ONKReceiver_Private.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKReceiver.h"
@class ONKReceiverSession;

@interface ONKReceiver ()

/** @brief The hostname or IP address of the receiver. */
@property (readonly, nonatomic) NSString *address;

/** @brief The IP port of the receiver. */
@property (readonly, nonatomic) UInt16 port;

/** @brief The session object used to communicate with the receiver. */
@property (nonatomic) ONKReceiverSession *session;

/**
 * @brief Initialize a receiver object at address for the specified model with
 *        its associated services and characteristics.
 *
 * @param model The receiver model identifier.
 * @param uniqueIdentifier The network MAC address of the receiver.
 * @param address  The hostname or IP address of the remote device.
 * @param port The port used by the remote device.
 *
 * @returns A receiver configured for the specified model and address. Returns
 *          nil if the model services and characteristics can not be parsed.
 */
- (instancetype)initWithModel:(NSString *)model
             uniqueIdentifier:(NSString *)uniqueIdentifier
                      address:(NSString *)address
                         port:(UInt16)port NS_DESIGNATED_INITIALIZER;

@end
