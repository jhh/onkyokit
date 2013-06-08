//
//  ONKEvent.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ONKEvent.h"

@interface ONKEvent ()

@property (nonatomic, strong, readonly) NSData *rawEvent;
@end

@implementation ONKEvent

+ (NSString *)commandForData:(NSData *)data {
    uint32_t sizeOfData = 0;
    [data getBytes:&sizeOfData range:NSMakeRange(8, 4)];
    sizeOfData = OSSwapInt32(sizeOfData);
    void *command = malloc(sizeOfData);
    [data getBytes:command range:NSMakeRange(16, sizeOfData)];
    NSString *response = [NSString stringWithCString:command encoding:NSASCIIStringEncoding];
    response = [response substringToIndex:[response rangeOfString:@"\r"].location-1];
    return response;
}

- (id) initWithString:(NSString *)rawEvent {
    NSParameterAssert(rawEvent != nil);
    
    self = [super init];
	if (self == nil) return nil;

//    _rawEvent = rawEvent;
    
    return self;
}

- (id) initWithData:(NSData *)rawEvent {
    NSParameterAssert(rawEvent != nil);
    
    self = [super init];
	if (self == nil) return nil;
    
    _rawEvent = rawEvent;
    
    return self;
}

- (NSString *) description {
    return [ONKEvent commandForData:self.rawEvent];
}


@end
