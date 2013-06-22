//
//  EISCPPacket.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ISCPMessage;

/**
ISCP over Ethernet (eISCP) packet.
*/
@interface EISCPPacket : NSObject

/**
Packet magic is four bytes, "ISCP".
*/
@property (nonatomic, readonly) NSString       *magic;

/**
Size of the eISCP header.
*/
@property (nonatomic, readonly) NSUInteger     headerLength;

/**
Size of the eISCP payload.
*/
@property (nonatomic, readonly) NSUInteger     dataLength;

/**
Version of the eISCP packet.
*/
@property (nonatomic, readonly) NSUInteger     version;

/**
The packet payload.
*/
@property (nonatomic, readonly) ISCPMessage    *message;

/**
Initialize with data packet from network.
*/
- (id) initWithData:(NSData *)packet;

/**
Initialize with a ISCP message.
*/
- (id) initWithMessage:(ISCPMessage *)message;

@end
