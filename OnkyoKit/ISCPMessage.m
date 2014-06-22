//
//  EISCPMessage.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/9/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ISCPMessage.h"

static NSCharacterSet *endCharSet;

@interface ISCPMessage ()
@property (copy, nonatomic) NSData *data;
@property (copy, nonatomic) NSString *message;
@end

@implementation ISCPMessage

+ (void)initialize
{
    if (self == [ISCPMessage class]) {
        // LF (\x0a), CR (\x0d), EOF (\x1a)
        endCharSet = [NSCharacterSet characterSetWithCharactersInString:@"\x0a\x0d\x1a"];
    }
}

- (instancetype)initWithData:(NSData *)data
{
    NSParameterAssert(data != nil);

    self = [super init];
    if (self) {
        _data = [data copy];
        NSString *rawMsg = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

        // "!1" + message + "end characters"
        NSRange range = NSMakeRange(2, [rawMsg rangeOfCharacterFromSet:endCharSet].location-2);
        _message = [rawMsg substringWithRange:range];
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message
{
    NSParameterAssert(message != nil);

    NSData *data = [[NSString stringWithFormat:@"!1%@\r", message] dataUsingEncoding:NSASCIIStringEncoding];
    return [self initWithData:data];
}

+ (instancetype)deviceSearchMessage
{
    NSData *data = [@"!xECNQSTN\r" dataUsingEncoding:NSASCIIStringEncoding];
    return [[ISCPMessage alloc] initWithData:data];
}

@end
