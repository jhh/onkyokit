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

extern NSString *const ONKReceiverWasDiscoveredNotification;

/** Delegates implement this protocol to receive events from connected device implement this protocol.
 Messages delivered are sent on a non-main queue. The delegate is responsible for handling the messages
 on a different queue or thread if it is required.
*/
@protocol ONKDelegate <NSObject>

/** Sent when an event is recieved from the remote device.

@param receiver The receiver sending the message.
@param event An event object containing the details of the event.
*/
- (void)receiver:(ONKReceiver *)receiver didSendEvent:(ONKEvent *)event;

/** Sent when a connection fails to send or receive from the remote device. Once  the
 delegate receives this message, it will receive no more events from receiver object.

 @param receiver The receiver sending the message.
 @param error An error object containing details of why the connection failed.
 */
- (void)receiver:(ONKReceiver *)receiver didFailWithError:(NSError *)error;

@end

/** Represents a controller session with an Onkyo device.
*/
@interface ONKReceiver : NSObject
{
    @private
    NSString *_host;
    NSUInteger _port;
    dispatch_queue_t _delegateQueue;

    /** GCD IO channel. */
    dispatch_io_t _channel;

    /** GCD timer used to delay sending commands. */
    dispatch_source_t _timer;

    /** A GCD queue created to handle network traffic. */
    dispatch_queue_t _socketQueue;

}

#pragma mark Properties
/** Delegate that receives events from device this controller is connected to.  */
@property (weak, readwrite) id<ONKDelegate> delegate;
@property NSString *model;
@property (readonly) NSString *address;

#pragma mark Class Methods
/**
Start browsing for AV receivers on the local network.

The host searches asynchronously for discoverable AV receivers. Whenever a new receiver is discovered,
a ONKReceiverWasDiscoveredNotification notification is posted. When no more receivers can be found or
the discovery process times out, the completion handler is called.

If this method is called multiple times, only the block associated with the last invocation is called
when discovery times out.

@param completionHandler A block to call when browsing ends.
*/
+ (void)startReceiverDiscoveryWithCompletionHandler:(void (^)(void))completionHandler;

#pragma mark Instance Methods
/**
 Initialize a receiver object with delegate. The receiver is created in the suspended state, calling
 resume starts the connection.

@param host  The host name or IP address of the remote device.
@param port The port used by the remote device.
*/
- (instancetype)initWithHost:(NSString *)host onPort:(NSUInteger)port;

/** Start or resume the connection to the remote device. */
- (void)resume;

/** Suspend the connection to the remote device. */
- (void)suspend;

/** Sends command after 200ms delay. */
- (void)sendCommand:(NSString *)command;

/** Sends command with interval in seconds. Calling multiple time currently cancels previous timer.
*/
- (void)sendCommand:(NSString *)command withInterval:(NSUInteger)interval;

@end
