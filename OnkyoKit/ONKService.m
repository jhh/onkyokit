//
//  ONKService.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKService.h"
#import "ONKCharacteristic_Private.h"

NSString * const ONKServiceDefinitionName = @"onkyo.service.name";


@implementation ONKService

- (instancetype)initWithReceiver:(ONKReceiver *)receiver serviceDictionary:(NSDictionary *)serviceDictionary
{
    self = [super init];
    if (self && receiver && serviceDictionary) {
        _receiver = receiver;
        _name = serviceDictionary[ONKServiceDefinitionName];
        _characteristics = @[ [[ONKCharacteristic alloc] initWithService:self] ];
    } else {
        self = nil;
    }
    return self;
}

@end
