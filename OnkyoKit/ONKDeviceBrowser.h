//
//  ONKDeviceBrowser.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/1/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Discovers Onkyo devices on the local network. Discovery begins when the -start method is
 called. Use the NSNotificationCenter to listen for device discovery events via
 ONKReceiverWasDiscoveredNotification. Discovery of receivers will also be reflected in
 the receivers array of the ONKReceiver class.

 The 'object' property of the notification will contain the ONKReceiver that was discovered.
 For example:

 @code{.m}
 - (void)receiverWasDiscovered:(NSNotification *)note {
 ONKReceiver *receiver = note.object;
 ....
 }
 @endcode

 @see ONKReceiver.receivers
 */
@interface ONKDeviceBrowser : NSObject
{
    @private
    void(^_discoveryCompletionHandler)(void);
    int _sock;
}

/**
 Initialize the device browser.

 @param completionHandler A block to be called when browsing ends. This block has no return
 value and may be NULL.
 */
- (instancetype)initWithCompletionHandler:(void (^)(void))completionHandler;

/**
 Begins the device discovery asychronously and call completion handler block when finished.
 */
- (void)start;

@end
