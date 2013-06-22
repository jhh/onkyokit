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

+ (instancetype) commandWithMessage:(ISCPMessage *)command {
    return [[ONKCommand alloc] initWithMessage:command];
}

@end
