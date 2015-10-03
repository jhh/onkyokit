//
//  ONKDeviceBrowser.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/1/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKReceiverBrowser;

/**
 * @brief A delegate conforming to ONKReceiverBrowserDelegate receives
 * notification of discovered receivers.
 */
@protocol ONKReceiverBrowserDelegate <NSObject>

/**
 * @brief Informs the delegate that a new receiver has been found.
 *
 * @param browser The browser that found the new receiver.
 * @param receiver The new receiver.
 */
- (void)receiverBrowser:(ONKReceiverBrowser *)browser didFindNewReceiver:(ONKReceiver *)receiver;

@end

/**
 * @brief An ONKReceiverBrowser is a service for browsing for AV receivers on
 * the local network.
 *
 * The host searches asynchronously for discoverable AV receivers. Whenever a
 * new receiver is discovered, it is added to discoveredReceivers. If the
 * delegate has been set, call
 * ONKReceiverBrowserDelegate#receiverBrowser:didFindNewReceiver: on the
 * delegate.
 */
@interface ONKReceiverBrowser : NSObject

#pragma mark Properties
/**
 * @brief Array of receivers discovered during a search. (read-only)
 *
 * Receivers are instances of ONKReceiver.
 */
@property (readonly, copy, nonatomic) NSArray *discoveredReceivers;

/**
 * @brief Delegate that receives updates on the discovered receivers.
 */
@property (weak, nonatomic) id<ONKReceiverBrowserDelegate> delegate;

/**
 * @brief The operation queue that the delegate is called on. Delegate method
 * calls are made on this queue.
 */
@property (nonatomic) NSOperationQueue *delegateQueue;

#pragma mark Methods
/**
 * @brief Create a session with the specified delegate and operation queue.
 *
 * @param delegate A browser delegate object that receives notification of
 *                 discovered receivers.
 * @param queue A queue for scheduling the delegate calls. If nil, the
 *              browser creates a serial operation queue for performing all
 *              delegate method calls.
 */
+ (instancetype)browserWithDelegate:(id<ONKReceiverBrowserDelegate>)delegate
                      delegateQueue:(NSOperationQueue *)queue;

/**
 * @brief Start searching for receivers. When receivers are discovered the
 * delegate is notified with
 * ReceiverBrowserDelegate#receiverBrowser:didFindNewReceiver:.
 */
- (void)startSearchingForNewReceivers;

/**
 * @brief Stops searching for new receivers.
 */
- (void)stopSearchingForNewReceivers;

@end
