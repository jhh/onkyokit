//
//  ONKService.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKService.h"
#import "ONKCharacteristic_Private.h"

NSString * const ONKServiceDefinitionName = @"service.name";
NSString * const ONKServiceDefinitionCharacteristics = @"service.characteristics";


@implementation ONKService

- (instancetype)initWithReceiver:(ONKReceiver *)receiver serviceDictionary:(NSDictionary *)serviceDictionary
{
    self = [super init];
    if (self && receiver && serviceDictionary) {
        _receiver = receiver;
        _name = serviceDictionary[ONKServiceDefinitionName];
        NSMutableArray *tempCharacteristics = [NSMutableArray array];
        for (NSDictionary *characteristicDictionary in serviceDictionary[ONKServiceDefinitionCharacteristics]) {
            [tempCharacteristics addObject:[[ONKCharacteristic alloc] initWithService:self
                                                             characteristicDictionary:characteristicDictionary]];
        }
        _characteristics = [tempCharacteristics copy];
    } else {
        self = nil;
    }
    return self;
}

- (ONKCharacteristic *)findCharacteristicWithType:(NSString *)characteristicType
{
    for (ONKCharacteristic *c in self.characteristics) {
        if ([c.characteristicType isEqualToString:characteristicType]) {
            return c;
        }
    }
    NSLog(@"%s: did not find characteristic for %@", __PRETTY_FUNCTION__, characteristicType);
    return nil;
}


@end
