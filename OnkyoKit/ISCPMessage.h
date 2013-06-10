//
//  EISCPMessage.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// Encapsulates ISCP message format used for commands and events.
//
// From the documentation: ISCP (Integra Serial Control Protocol) consists of
// three command characters and parameter character(s) of variable length.
//
// Message is prepended by "!1"
// End characters are "[EOF]" or "[EOF][CR]" or "[EOF][CR][LF]" depend on model
//
@interface ISCPMessage : NSObject

@property (nonatomic, strong, readonly) NSString *data;
@property (nonatomic, strong, readonly) NSString *message;

//
// Initialize the message with the contents of the eISCP data segment.
//
- (id) initWithData:(NSData *)data;

- (id) initWithMessage:(NSString *)message;

@end
