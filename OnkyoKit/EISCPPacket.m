//
//  EISCPPacket.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "EISCPPacket.h"

@implementation EISCPPacket

- (id) initWithData:(NSData *)packet {
    NSParameterAssert(packet != nil);
    
    self = [super init];
	if (self == nil) return nil;
    
    _header = [packet subdataWithRange:NSMakeRange(0, EISCP_HEADER_LENGTH)];

    uint32_t sizeOfData = 0;
    [packet getBytes:&sizeOfData range:NSMakeRange(8, 4)];
    sizeOfData = OSSwapInt32(sizeOfData);
    _data = [packet subdataWithRange:NSMakeRange(16, sizeOfData)];

    return self;
}

@end
