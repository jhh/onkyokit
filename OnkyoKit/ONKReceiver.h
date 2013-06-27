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

/** Delegates implement this protocol to receive events from connected device implement this protocol.
*/
@protocol ONKDelegate <NSObject>

/** Implemented by delegates to receive events.

@param controller The controller receiving the event.
@param event The received event.
*/
- (void) receiver:(ONKReceiver *)receiver didSendEvent:(ONKEvent *)event;

@end

/** Represents a controller session with an Onkyo device.
*/
@interface ONKReceiver : NSObject

/** Delegate that receives events from device this controller is connected to.  */
@property (nonatomic, weak, readwrite) id<ONKDelegate> delegate;

/** The GCD queue that the delegate receives events on. */
@property (nonatomic, readwrite) dispatch_queue_t      delegateQueue;

/**
Initialize a controller object with delegate. A network connection is not opened until -connectToHost:error: is called.

@param delegate  Receives events from the connected device.
@param delegateQueue queue to call back the delegate on (usually the main thread's queue, i.e. dispatch_get_main_queue()).
@return A controller object with delegate.
*/
- (instancetype) initWithDelegate:(id<ONKDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/** Connect to remote device using default port 60128. */
- (BOOL) connectToHost:(NSString *)host error:(NSError **)error;

/** Designated initializer. */
- (BOOL) connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)error;

/** Disconnect from the remote device. */
- (void) close;

/** Sends command after 200ms delay. */
- (void) sendCommand:(NSString *)command;

/** Sends command with interval in seconds. Calling multiple time currently cancels previous timer.
*/
- (void) sendCommand:(NSString *)command withInterval:(NSUInteger)interval;

@end
