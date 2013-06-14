//
//  ONKController.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONKController;
@class ONKEvent;

// Delegates that receive events from connected device implement
// this protocol.
@protocol ONKDelegate <NSObject>

- (void) controller:(ONKController *)controller didReceiveEvent:(ONKEvent *)event;

@end

// Represents a controller session with an Onkyo device.
//
@interface ONKController : NSObject

@property (nonatomic, weak, readwrite) id<ONKDelegate> delegate;
@property (nonatomic, readwrite) dispatch_queue_t      delegateQueue;
@property (nonatomic, readonly) dispatch_queue_t       socketQueue;

// Initialized with a delegate (ONKDelegate) that receives events
// from the connected device and a queue to call back the delegate on
// (usually the main thread's queue, i.e. dispatch_get_main_queue() ).
// A network connection is not opened until -connectToHost:error: is called.
//
- (id) initWithDelegate:(id<ONKDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

// Connect to remote device using default port 60128
//
- (BOOL) connectToHost:(NSString *)host error:(NSError **)error;

// Designated initializer.
//
- (BOOL) connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)error;

// Disconnect from the remote device.
- (void) close;

// sends command after 200ms delay
//
- (void) sendCommand:(NSString *)command;

// interval in seconds, calling multiple time currently cancels previous timer
//
- (void) sendCommand:(NSString *)command withInterval:(NSUInteger)interval;

@end
