//
//  ONKDeviceBrowser.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/1/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKDeviceBrowser;


/**
 Informs the delegate that a new receiver has been found.
 
 @param browser The browser that found the new receiver.
 @param receiver The new receiver.
 */
@protocol ONKReceiverBrowserDelegate <NSObject>

- (void)receiverBrowser:(ONKDeviceBrowser *)browser didFindNewReceiver:(ONKReceiver *)receiver;

@end

/**
 Browsing for AV receivers on the local network.
 
 The host searches asynchronously for discoverable AV receivers. Whenever a new receiver is discovered,
 it is added to discoveredReceivers. If the delegate has been set, call -receiverBrowser:didFindNewReceiver
 on it.
 */
@interface ONKDeviceBrowser : NSObject
{
    @private
    int _sock;
    NSOperationQueue *_queue, *_delegateQueue;
    NSBlockOperation *_operation;
    NSMutableDictionary *_discoveredReceiversMap;
}

#pragma mark Properties
/**
 Array of receivers discovered during a search. (read-only)
 
 Receivers are instances of ONKReceiver.
 */
@property (readonly, copy, nonatomic) NSArray *discoveredReceivers;

/** Delegate that receives updates on the discovered receivers.  */
@property (readonly, weak, nonatomic) id<ONKReceiverBrowserDelegate> delegate;

/**
 The operation queue that the delegate is called on. Delegate method calls are made on
 this queue.
 */
@property (readonly, nonatomic) NSOperationQueue *delegateQueue;

#pragma mark Methods
/**
 Set a delegate to receive updates on the discovered receivers. The delegate will be
 called on the supplied delegateQueue.
 
 @param delegate A browser delegate object that receives notification of discovered receivers.
 @param delegateQueue A queue for scheduling the delegate calls. If nil, the browser creates
 a serial operation queue for performing all delegate method calls.
 */
- (void)setDelegate:(id<ONKReceiverBrowserDelegate>)delegate delegateQueue:(NSOperationQueue *)delegateQueue;

/**
 Start searching for receivers. When receivers are discovered the delegate is
 notified with receiverBrowser:didFindNewReceiver:.
 */
- (void)startSearchingForNewReceivers;

/**
 Stops searching for new receivers.
 */
- (void)stopSearchingForNewReceivers;

@end
