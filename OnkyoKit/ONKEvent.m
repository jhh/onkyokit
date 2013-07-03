//
//  ONKEvent.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ONKEvent.h"
#import <OnkyoKit/ISCPMessage.h>


@implementation ONKEvent

- (NSString *)description
{
    return self.message.message;
}


@end
