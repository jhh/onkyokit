//
//  ONKCharacteristicMetadata_Private.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/13/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//
#import "ONKCharacteristicMetadata.h"

extern NSString * const ONKCharacteristicMetadataDefinitionMinValue;
extern NSString * const ONKCharacteristicMetadataDefinitionMaxValue;
extern NSString * const ONKCharacteristicMetadataDefinitionUnits;
extern NSString * const ONKCharacteristicMetadataDefinitionEnumLabels;


@interface ONKCharacteristicMetadata ()

- (instancetype)initWithCharacteristicMetadataDictionary:(NSDictionary *)characteristicMetadataDictionary NS_DESIGNATED_INITIALIZER;

@end