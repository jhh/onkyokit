//
//  EISCPPacket.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "EISCPPacket.h"
#import "ISCPMessage.h"

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

    _message = [[ISCPMessage alloc] initWithData:[packet subdataWithRange:NSMakeRange(_headerLength, _dataLength)]];
    _data = [packet copy];

    return self;
}

- (id) initWithMessage:(ISCPMessage *)message {
    NSParameterAssert(message != nil);

    self = [super init];
	if (self == nil) return nil;

    _magic = @"ISCP";
    _headerLength = 16;
    _dataLength = [message.data length];
    _version = 1;
    _message = message;

    // create the data property containing packet header and payload
    NSMutableData *tmpData = [NSMutableData dataWithCapacity:30];
    [tmpData appendData:[_magic dataUsingEncoding:NSASCIIStringEncoding]];
    uint32_t swapped_int = CFSwapInt32HostToBig((uint32_t)_headerLength);
    [tmpData appendBytes:&swapped_int length:4];
    swapped_int = CFSwapInt32HostToBig((uint32_t)_dataLength);
    [tmpData appendBytes:&swapped_int length:4];
    swapped_int = CFSwapInt32HostToBig(0x01000000);
    [tmpData appendBytes:&swapped_int length:4];
    [tmpData appendData:message.data];
    _data = [tmpData copy];

    return self;
}

@end
