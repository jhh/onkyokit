//
//  ONKCharacteristic.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/15/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKService;

/**
 * @group Accessory Service Characteristic Types
 *
 * @brief These constants define the characteristic types supported by the
 *        Apple Accessory Profile for HomeKit based accessories.
 */
extern NSString * const ONKCharacteristicTypePowerState;
extern NSString * const ONKCharacteristicTypeMuteState;
extern NSString * const ONKCharacteristicTypeMainVolume;

@interface ONKCharacteristic : NSObject

/** The type of the characteristic. (read-only) */
@property (readonly, copy, nonatomic) NSString *characteristicType;

/** Service that has this characteristics. */
@property(readonly, weak, nonatomic) ONKService *service;


/**
 * Modifies the value of the characteristic.
 *
 * @param value The value to be written.
 *
 * @param completion Block that is invoked once the request is processed.
 *                   The NSError provides more information on the status of the request, error
 *                   will be nil on success.
 */
- (void)writeValue:(id)value completionHandler:(void (^)(NSError *error))completion;

/**
 * Reads the value of the characteristic. The updated value can be read from the 'value'
 * property of the characteristic.
 *
 * @param completion Block that is invoked once the request is processed.
 *                   The NSError provides more information on the status of the request, error
 *                   will be nil on success.
 */
- (void)readValueWithCompletionHandler:(void (^)(NSError *error))completion;


@end
