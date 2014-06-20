//
//  ONKCommand.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Foundation;
#import <OnkyoKit/EISCPPacket.h>

@class ISCPMessage;

/**
 * @brief Command to be sent over network to device.
 *
 * Sending commands to a device typically result in a ONKEvent being
 * returned by the device.
**/
@interface ONKCommand : EISCPPacket

/**
 * @brief Creates and returns a data object containing an eISCP packet with the
 * contents of \c command.
 *
 * @param command A ISCP message object.
 * @return A data object containing an eISCP packet with the contents of
 *         \c command. Returns \c nil if the command object could not be created.
 *
 * @bug Should not return NSData.
*/
+ (instancetype) commandWithMessage:(ISCPMessage *)command;

@end
