//
//  ONKCharacteristic.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/15/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKCharacteristic_Private.h"
#import "ONKService.h"

@implementation ONKCharacteristic

- (instancetype)initWithService:(ONKService *)service
{
    self = [super init];
    if (self) {
        _service = service;
        _characteristicType = @"com.jeffhutchison.Type";
    }
    return self;
}


- (void)writeValue:(id)value completionHandler:(void (^)(NSError *error))completion
{
    
}

- (void)readValueWithCompletionHandler:(void (^)(NSError *error))completion
{
    
}


@end
