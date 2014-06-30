//
//  ONKCharacteristic.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/15/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKCharacteristic_Private.h"
#import "ONKService.h"

NSString * const ONKCharacteristicTypePowerState = @"onkyo.pwr";
NSString * const ONKCharacteristicTypeMuteState  = @"onkyo.amt";
NSString * const ONKCharacteristicTypeMainVolume = @"onkyo.mvl";


NSString * const ONKCharacteristicDefinitionName = @"characteristic.name";
NSString * const ONKCharacteristicDefinitionType = @"characteristic.type";

@implementation ONKCharacteristic

- (instancetype)initWithService:(ONKService *)service characteristicDictionary:(NSDictionary *)characteristicDictionary;
{
    self = [super init];
    if (self) {
        _service = service;
        _name = characteristicDictionary[ONKCharacteristicDefinitionName];
        _characteristicType = characteristicDictionary[ONKCharacteristicDefinitionType];
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
