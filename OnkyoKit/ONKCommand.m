//
//  ONKMessage.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ONKCommand.h"

@implementation ONKCommand

+ (NSData *)dataForCommand:(NSString*)command {
    NSMutableData *data = [NSMutableData data];
    const char prequel[4] = "ISCP";
    uint32_t headerSize =  OSSwapInt32(16);
    uint32_t commandSize = OSSwapInt32(command.length);
    uint32_t iscpVersion = OSSwapInt32(0x01000000);
    char endCommand = {0x0D};
    
    [data appendBytes:&prequel length:sizeof(prequel)];
    [data appendBytes:&headerSize length:sizeof(int32_t)];
    [data appendBytes:&commandSize length:sizeof(int32_t)];
    [data appendBytes:&iscpVersion length:sizeof(int32_t)];
    [data appendData:[command dataUsingEncoding:NSASCIIStringEncoding]];
    [data appendBytes:&endCommand length:sizeof(char)];
    
    return data;
}

@end
