//
//  ONKService.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKService.h"
#import "ONKCharacteristic_Private.h"

@implementation ONKService

- (instancetype)initWithReceiver:(ONKReceiver *)receiver
{
    self = [super init];
    if (self) {
        _receiver = receiver;
        _characteristics = @[ [[ONKCharacteristic alloc] initWithService:self] ];
    }
    return self;
}

@end
