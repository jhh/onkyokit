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
@class ONKReceiver;
@class ONKReceiverBrowser;

@protocol ONKDelegate <NSObject>

- (void) controller:(ONKController *)controller didReceiveEvent:(ONKEvent *)event;

@end

@interface ONKController : NSObject

@property (nonatomic, weak, readwrite) id<ONKDelegate> delegate;
@property (nonatomic, readwrite) dispatch_queue_t      delegateQueue;
@property (nonatomic, readwrite) dispatch_queue_t      socketQueue;

- (id) initWithDelegate:(id<ONKDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

// use default port 60128
- (BOOL) connectToHost:(NSString *)host error:(NSError **)error;

- (BOOL) connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)error;

// sends command after 200ms delay
- (void) sendCommand:(NSString *)command;

// interval in seconds, calling multiple time currently cancels previous timer
- (void) sendCommand:(NSString *)command withInterval:(NSUInteger)interval;

@end
