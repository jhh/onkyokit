//
//  EISCPMessage.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ISCPMessage.h"

static NSCharacterSet *endCharSet;

@implementation ISCPMessage

+ (void) initialize {
    // LF (\x0a), CR (\x0d), EOF (\x1a)
    endCharSet = [NSCharacterSet characterSetWithCharactersInString:@"\x0a\x0d\x1a"];
}

- (id) initWithData:(NSData *)data {
    NSParameterAssert(data != nil);
    
    self = [super init];
	if (self == nil) return nil;

    _data = [data copy];
    NSString *rawMsg = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

    // "!1" + message + "end characters"
    NSRange range = NSMakeRange(2, [rawMsg rangeOfCharacterFromSet:endCharSet].location-2);
    _message = [rawMsg substringWithRange:range];
    return self;
}

- (id) initWithMessage:(NSString *)message {
    NSParameterAssert(message != nil);
    
    self = [super init];
	if (self == nil) return nil;

    _message = [message copy];
    _data = [[NSString stringWithFormat:@"!1%@\r", _message] dataUsingEncoding:NSASCIIStringEncoding];

    return self;
}


@end
