//
//  ONKController.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKReceiver;
@class ONKService;
@class ONKCharacteristic;
@class ONKEvent;
@protocol ONKReceiverDelegate;


/**
 * @brief AN ONKReceiver object represents an Onkyo receiver.
 *
 * A receiver provides one or more services, represented by instances
 * of ONKService.
 */
@interface ONKReceiver : NSObject

/** @brief The model name of the device. */
@property (readonly, copy, nonatomic) NSString *model;

/** @brief The MAC address of the device. */
@property(readonly, copy, nonatomic) NSString *uniqueIdentifier;

/** @brief Array of characteristics of this receiver. (read-only) */
@property(readonly, copy, nonatomic) NSArray *services;


/** @brief Delegate that receives events from device this controller is connected to.  */
@property(weak, nonatomic) id<ONKReceiverDelegate> delegate;

/** @brief Operation queue that delegate messages are sent on.  */
@property(nonatomic) NSOperationQueue *delegateQueue;

/**
 * @brief Resume the network connection to the receiver.
 * @todo This will be moved to another class.
*/
- (void)resume;
/**
 * @brief Suspend the network connection to the receiver.
 * @todo This will be moved to another class.
*/
- (void)suspend;
/**
 * @brief Send a command over the network connection to the receiver.
 * @todo This will be moved to another class.
*/
- (void)sendCommand:(NSString *)command;

@end

/**
 * @brief A delegate conforming to ONKReceiverDelegate receives status updates
 *        from the receiver.
 *
 * Delegates implement this protocol to receive events from connected device
 * implement this protocol. Messages delivered are sent on a queue you
 * specify with the delegateQueue parameter.
 */
@protocol ONKReceiverDelegate <NSObject>

@optional
/**
 * @brief Informs the delegate of a change in value of a characteristic as a
 *        result of a notification from the receiver.
 *
 * @param receiver The receiver.
 * @param service The service with a changed characteristic value
 * @param characteristic The characteristic whose value changed.
 */
- (void)receiver:(ONKReceiver *)receiver service:(ONKService *)service didUpdateValueForCharacteristic:(ONKCharacteristic *)characteristic;
/**
 * @brief Sent when an event is recieved from the remote device.
 *
 * @param receiver The receiver sending the message.
 * @param event An event object containing the details of the event.
 * @todo This method signature needs to change.
 */
- (void)receiver:(ONKReceiver *)receiver didSendEvent:(ONKEvent *)event;

/**
 * @brief Sent when a connection fails to send or receive from the remote device.
 *
 * Once the delegate receives this message, it will receive no more events
 * from receiver object.
 *
 * @param receiver The receiver sending the message.
 * @param error An error object containing details of why the connection failed.
 * @todo This method signature needs to change.
 */
- (void)receiver:(ONKReceiver *)receiver didFailWithError:(NSError *)error;

@end

