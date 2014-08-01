//
//  ONKReceiverSession.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/14/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKReceiver;

/**
 * @brief An ONKReceiverSession object represents a network session with a
 * receiver.
 */
@interface ONKReceiverSession : NSObject

/**
 * @brief The associated ONKReceiver instance.
 */
@property (weak, readonly, nonatomic) ONKReceiver *receiver;

/**
 * @brief Initialize with a configured ONKReceiver object.
 */
- (instancetype)initWithReceiver:(ONKReceiver *)receiver NS_DESIGNATED_INITIALIZER;

/**
 * @brief Start or resume the connection to the remote device.
 */
- (BOOL)resumeWithError:(NSError **)error;
/**
 * @brief Suspend the connection to the remote device.
 */
- (void)suspend;

/**
 * @brief Sends command after 200ms delay.
 *
 * @param command The command to send.
 * @param completion The handler to call when the request is done. This handler is
 *                   not guaranteed to be called on any particular thread.
 */
- (void)sendCommand:(NSString *)command withCompletionHandler:(void (^)(NSError *error))completion;

@end
