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

+ (void)initialize
{
    if (self == [ISCPMessage class]) {
        // LF (\x0a), CR (\x0d), EOF (\x1a)
        endCharSet = [NSCharacterSet characterSetWithCharactersInString:@"\x0a\x0d\x1a"];
    }
}

+ (instancetype)deviceSearchMessage
{
    return [[self alloc] initDeviceSearchMessage];
}

- (instancetype)initWithData:(NSData *)data
{
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

- (instancetype)initWithMessage:(NSString *)message
{
    NSParameterAssert(message != nil);

    self = [super init];
	if (self == nil) return nil;

    _message = [message copy];
    _data = [[NSString stringWithFormat:@"!1%@\r", _message] dataUsingEncoding:NSASCIIStringEncoding];

    return self;
}

- (instancetype)initDeviceSearchMessage
{
    self = [super init];
	if (self == nil) return nil;

    _message = @"ECNQSTN";
    _data = [[NSString stringWithFormat:@"!x%@\r", _message] dataUsingEncoding:NSASCIIStringEncoding];

    return self;
}

@end
