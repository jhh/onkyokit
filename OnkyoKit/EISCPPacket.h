//
//  EISCPPacket.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ISCPMessage;

@interface EISCPPacket : NSObject

@property (nonatomic, readonly) NSString       *magic;
@property (nonatomic, readonly) NSUInteger     headerLength;
@property (nonatomic, readonly) NSUInteger     dataLength;
@property (nonatomic, readonly) NSUInteger     version;
@property (nonatomic, readonly) ISCPMessage    *message;

/*!
 @brief Initialize with data packet from network.
 */
- (id) initWithData:(NSData *)packet;

/*!
 @brief Initialize with a ISCP message.
 */
- (id) initWithMessage:(ISCPMessage *)message;

@end
