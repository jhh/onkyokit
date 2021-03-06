//
//  ONKService.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKReceiver;
@class ONKCharacteristic;

/**
 * @brief An ONKService represents a service provided by a receiver.
 *
 * A receiver provides multiple services, for example, zones. Services have
 * characteristics that can be queried to discover their state or modified to
 * cause the receiver to modify its behavior.
 */
@interface ONKService : NSObject

/** @brief The name of the service */
@property(readonly, copy, nonatomic) NSString *name;

/** @brief Receiver that provides this service. */
@property(readonly, weak, nonatomic) ONKReceiver *receiver;


/** @brief Array of characteristics of this receiver. (read-only) */
@property(readonly, copy, nonatomic) NSArray *characteristics;

/**
 * @brief Get the characteristic with the given characteristic type.
 *
 * See ONKCharacteristic.h for characteristic type constants.
 */
- (ONKCharacteristic *)findCharacteristicWithType:(NSString *)characteristicType;

@end
