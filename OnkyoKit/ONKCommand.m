//
//  ONKMessage.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ONKCommand.h"
#import "ISCPMessage.h"

@implementation ONKCommand

+ (NSData *) dataForCommand:(ISCPMessage *)command {
    NSMutableData *data = [NSMutableData data];
    const char prequel[4] = "ISCP";
    uint32_t headerSize =  OSSwapInt32(16);
    uint32_t commandSize = OSSwapInt32(command.data.length);
    uint32_t iscpVersion = OSSwapInt32(0x01000000);
    
    [data appendBytes:&prequel length:sizeof(prequel)];
    [data appendBytes:&headerSize length:sizeof(int32_t)];
    [data appendBytes:&commandSize length:sizeof(int32_t)];
    [data appendBytes:&iscpVersion length:sizeof(int32_t)];
    // TODO: return ASCII encoded
    [data appendData:[command.data dataUsingEncoding:NSASCIIStringEncoding]];
    
    return data;
}

@end
