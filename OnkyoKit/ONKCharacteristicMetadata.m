//
//  ONKCharacteristicMetadata.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/13/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKCharacteristicMetadata_Private.h"

NSString * const ONKCharacteristicMetadataDefinitionMinValue = @"characteristic.metadata.minValue";
NSString * const ONKCharacteristicMetadataDefinitionMaxValue = @"characteristic.metadata.maxValue";
NSString * const ONKCharacteristicMetadataDefinitionUnits = @"characteristic.metadata.units";

@implementation ONKCharacteristicMetadata

- (instancetype)initWithCharacteristicMetadataDictionary:(NSDictionary *)characteristicMetadataDictionary
{
    self = [super init];
    if (self) {
        _minimumValue = characteristicMetadataDictionary[ONKCharacteristicMetadataDefinitionMinValue];
        _maximumValue = characteristicMetadataDictionary[ONKCharacteristicMetadataDefinitionMaxValue];
        NSNumber *units = characteristicMetadataDictionary[ONKCharacteristicMetadataDefinitionUnits];
        _units = [units integerValue];
    }
    return self;
}

@end
