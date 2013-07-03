//
//  ISCPMessage.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Foundation;

/**
ISCP message used for commands and events.

From the documentation: ISCP (Integra Serial Control Protocol) consists of
three command characters and parameter character(s) of variable length.

Message is prepended by "!1". End characters are "[EOF]" or "[EOF][CR]" or
"[EOF][CR][LF]" depend on model
*/
@interface ISCPMessage : NSObject

/**
The full message payload as sent or recieved from network, with ISCP delimeters.
*/
@property (readonly) NSData *data;

/**
The string contents of the message, without ISCP delimiters.
*/
@property (readonly) NSString *message;

/**
Returns a device search message.
*/
+ (instancetype)deviceSearchMessage;

/**
Initialize the message with the contents of the eISCP data segment.

@param data the full message payload as received from network.
*/
- (instancetype) initWithData:(NSData *)data;

/**
Initialize the message with an command or event string.

@param message the message, without delimeters, to be sent to device.
*/
- (instancetype) initWithMessage:(NSString *)message;

@end
