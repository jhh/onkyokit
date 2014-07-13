//
//  ONKCharacteristic.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/15/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKService;
@class ONKCharacteristicMetadata;

/**
 * @defgroup characteristicType Receiver Service Characteristic Types
 *
 * @brief These constants define the service types supported by Onkyo
 * receivers.
 * @{
 */
extern NSString * const ONKCharacteristicTypePowerState;
extern NSString * const ONKCharacteristicTypeMuteState;
extern NSString * const ONKCharacteristicTypeMasterVolume;
/**@}*/

/**
 * @brief An ONKCharacteristic object represents a specific characteristic of a
 * receiver—for example, if the power is on or off, or what volume it is set
 * to.
 */
@interface ONKCharacteristic : NSObject

/**
 * @brief The type of the characteristic. (read-only)
 *
 * @see @ref characteristicType "Receiver Service Characteristic Types"
 */
@property (readonly, copy, nonatomic) NSString *name;

/**
 * @brief The type of the characteristic. (read-only)
 *
 * @see @ref characteristicType "Receiver Service Characteristic Types"
 */
@property (readonly, copy, nonatomic) NSString *characteristicType;

/**
 * @brief Metadata about the units and other properties of the characteristic.
 *        (read-only)
 */
@property(readonly, strong, nonatomic) ONKCharacteristicMetadata *metadata;

/**
 * @brief Service that has this characteristics.
 */
@property(readonly, weak, nonatomic) ONKService *service;

/**
 * @brief The current value of the characteristic. (read-only)
 */
@property(readonly, copy, nonatomic) id value;

/**
 * @brief Modifies the value of the characteristic.
 *
 * @param value The value to be written.
 *
 * @param completion Block that is invoked once the request is processed.  The
 * NSError provides more information on the status of the request, error will
 * be nil on success.
 */
- (void)writeValue:(id)value completionHandler:(void (^)(NSError *error))completion;

/**
 * @brief Reads the value of the characteristic. The updated value can be read
 * from the value property of the characteristic.
 *
 * @param completion Block that is invoked once the request is processed.  The
 * NSError provides more information on the status of the request, error will
 * be nil on success.
 */
- (void)readValueWithCompletionHandler:(void (^)(NSError *error))completion;


@end
