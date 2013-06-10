//
//  EISCPPacket.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EISCP_HEADER_LENGTH 16

@interface EISCPPacket : NSObject

@property (nonatomic, strong, readonly) NSData *header;
@property (nonatomic, strong, readonly) NSData *data;

- (id) initWithData:(NSData *)packet;

@end
