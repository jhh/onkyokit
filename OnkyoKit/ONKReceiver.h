//
//  ONKController.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKReceiver;
@class ONKEvent;
@protocol ONKReceiverDelegate;


/**
 Represents an Onkyo AV receiver.
*/
@interface ONKReceiver : NSObject

/** The model name of the device. */
@property (copy) NSString *model;

/** The MAC address of the device. */
@property NSString *uniqueIdentifier;

/** Array of characteristics of this receiver. (read-only) */
@property(readonly, copy, nonatomic) NSArray *services;


/** Delegate that receives events from device this controller is connected to.  */
@property (weak, readwrite) id<ONKReceiverDelegate> delegate;

/** Operation queue that delegate messages are sent on.  */
@property (retain, readwrite) NSOperationQueue *delegateQueue;

///////////////////////////////////////////////////////////////////////////////////////
// FIXME: temporary methods for refactoring
///////////////////////////////////////////////////////////////////////////////////////

- (void)resume __attribute__((deprecated));
- (void)suspend __attribute__((deprecated));
- (void)sendCommand:(NSString *)command __attribute__((deprecated));

@end

/**
 Delegates implement this protocol to receive events from connected device implement this
 protocol. Messages delivered are sent on a queue you specify with the delegateQueue parameter.
 */
@protocol ONKReceiverDelegate <NSObject>

/** Sent when an event is recieved from the remote device.
 
 @param receiver The receiver sending the message.
 @param event An event object containing the details of the event.
 */
- (void)receiver:(ONKReceiver *)receiver didSendEvent:(ONKEvent *)event __attribute__((deprecated));

/** Sent when a connection fails to send or receive from the remote device. Once  the
 delegate receives this message, it will receive no more events from receiver object.
 
 @param receiver The receiver sending the message.
 @param error An error object containing details of why the connection failed.
 */
- (void)receiver:(ONKReceiver *)receiver didFailWithError:(NSError *)error __attribute__((deprecated));

@end

