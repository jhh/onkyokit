//
//  ONKController.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#import "ONKController.h"
#import "ONKEvent.h"
#import "ONKCommand.h"

NSString const *commandHeader = @"!1";

@interface ONKController ()

@property (nonatomic, readwrite) dispatch_io_t     channel;
@property (nonatomic, readwrite) dispatch_source_t timer;

@end

@implementation ONKController

- (id) initWithDelegate:(id<ONKDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue {
    NSParameterAssert(delegate != nil);
    NSParameterAssert(delegateQueue != NULL);

    self = [super init];
	if (self == nil) return nil;
    _delegate = delegate;
    _delegateQueue = delegateQueue;
    _socketQueue = dispatch_queue_create("OnkyoKitSocket", DISPATCH_QUEUE_SERIAL);
    return self;
}

- (BOOL) connectToHost:(NSString *)host error:(NSError **)error {
    return [self connectToHost:host onPort:60128 error:error];
}

- (BOOL) connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)error {
    // TODO: error handling
    dispatch_fd_t fd = [self fileDescriptorForHost:host onPort:port];
    _channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, _socketQueue, 0);
    dispatch_io_set_low_water(_channel, 5);
    
    dispatch_io_read(_channel, 0, SIZE_MAX, _delegateQueue, ^(bool done, dispatch_data_t data, int error) {
        if(data) {
            [self processData:data];
        }
        if(error) NSLog(@"READ ERROR!!!");
        if(done) NSLog(@"READ DONE!!!");
    });
    return TRUE;
}

- (void) sendCommand:(NSString *)command {
    NSData *packet = [ONKCommand dataForCommand:[commandHeader stringByAppendingString:command]];
    dispatch_data_t message = dispatch_data_create([packet bytes], [packet length], dispatch_get_global_queue(0, 0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 2000ull*NSEC_PER_USEC);
    dispatch_after(delay, dispatch_get_global_queue(0, 0), ^{
        dispatch_io_write(_channel, 0, message, _socketQueue, ^(bool done, dispatch_data_t data, int error) {
            if(error) NSLog(@"WRITE ERROR!!!");
            if(done) NSLog(@"WRITE DONE!!!");
        });
    });    
}

- (void) sendCommand:(NSString *)command withInterval:(NSUInteger)interval {
    
}

#pragma mark Private Methods

- (dispatch_fd_t) fileDescriptorForHost:(NSString *)host onPort:(uint16_t)port {
    
    struct sockaddr_in sock_addr;
    
    int sock = socket(PF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        NSLog(@"Socket error: %s (%d)", strerror(errno), errno);
    }
    
    bzero(&sock_addr, sizeof(sock_addr));
    sock_addr.sin_family = PF_INET;
    sock_addr.sin_port = htons(port);
    inet_pton(AF_INET, [host cStringUsingEncoding:NSASCIIStringEncoding], &sock_addr.sin_addr);
    
    if (connect(sock, (struct sockaddr *) &sock_addr, sizeof(sock_addr)) == -1) {
        NSLog(@"Connect error to %@: %s (%d)", host, strerror(errno), errno);
    }
    NSLog(@"Connected to %@", host);
    return sock;
}

- (void) processData:(dispatch_data_t)data {
    const void *buffer;
    size_t length;
    dispatch_data_t tmpData = dispatch_data_create_map(data, &buffer, &length);
    NSData *response = [NSData dataWithBytes:buffer length:length];
    tmpData = dispatch_data_empty;
    [self.delegate controller:self didReceiveEvent:[[ONKEvent alloc] initWithData:response]];
}

@end
