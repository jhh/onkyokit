//
//  ONKCharacteristicMetadata.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/13/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief The units of a characteristic.
 */
typedef NS_ENUM(NSInteger, ONKCharacteristicUnit) {
    ONKCharacteristicUnitNumeric = 1,
    ONKCharacteristicUnitBoolean = 2,
    ONKCharacteristicUnitEnum    = 3,
    ONKCharacteristicUnitTone    = 4,
};

@interface ONKCharacteristicMetadata : NSObject

/**
 * @brief The minimum value for the characteristic. (read-only)
 */
@property (readonly, nonatomic) NSNumber *minimumValue;

@property (readonly, nonatomic) NSNumber *maximumValue;

@property (readonly, nonatomic) ONKCharacteristicUnit units;

@end
