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

    _magic = [[NSString alloc] initWithData:[packet subdataWithRange:NSMakeRange(0, 4)] encoding:NSASCIIStringEncoding];

    uint32_t buffer = 0;
    [packet getBytes:&buffer range:NSMakeRange(4, 4)];
    _headerLength = CFSwapInt32BigToHost(buffer);

    [packet getBytes:&buffer range:NSMakeRange(8, 4)];
    _dataLength = CFSwapInt32BigToHost(buffer);

    [packet getBytes:&_version range:NSMakeRange(12, 1)];

    _data = [packet subdataWithRange:NSMakeRange(_headerLength, _dataLength)];

    return self;
}

@end
