//
//  ONKController.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//
@import Darwin;
#import "ONKReceiver.h"
#import "ONKDeviceBrowser.h"
#import "ONKEvent.h"
#import "ONKCommand.h"
#import "ISCPMessage.h"

NSString *const ONKReceiverWasDiscoveredNotification = @"ONKReceiverWasDiscoveredNotification";

// TODO: implement error reporting
@implementation ONKReceiver

#pragma mark Class Methods

+ (void)startReceiverDiscoveryWithCompletionHandler:(void (^)(void))completionHandler
{
    ONKDeviceBrowser *browser = [[ONKDeviceBrowser alloc] initWithCompletionHandler:completionHandler];
    [browser start];
}


#pragma mark Instance Methods
- (instancetype)initWithHost:(NSString *)host onPort:(NSUInteger)port
{
    NSParameterAssert(host != nil);
    NSParameterAssert(port > 0 && port < 65535);

    self = [super init];
	if (self == nil) return nil;
    _socketQueue = dispatch_queue_create("com.jeffhutchison.OnkyoKit.socket", DISPATCH_QUEUE_SERIAL);
    _delegateQueue = dispatch_queue_create("com.jeffhutchison.OnkyoKit.delegate", DISPATCH_QUEUE_SERIAL);
    _host = [host copy];
    _address = _host; // TODO: replace host with address
    _port = port;
    return self;
}

- (void)resume
{
    dispatch_fd_t fd = [self fileDescriptorForHost:_host onPort:_port];
    if (fd  == -1) {
        // TODO: send error to delegate
        return;
    }
    _channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, _socketQueue, NULL);
    dispatch_io_set_low_water(_channel, 5);

    dispatch_io_read(_channel, 0, SIZE_MAX, _delegateQueue, ^(bool done, dispatch_data_t data, int error) {
        if(data) {
            [self processData:data];
        }
        if(error) NSLog(@"READ ERROR!!!");
        if(done) NSLog(@"READ DONE!!!");
    });
}

- (void)suspend
{
    dispatch_io_close(_channel, 0);
    _channel = nil;
}

- (void)sendCommand:(NSString *)command
{
    ONKCommand *packet = [ONKCommand commandWithMessage:[[ISCPMessage alloc] initWithMessage:command]];
    dispatch_data_t message = dispatch_data_create([packet.data bytes], [packet.data length], dispatch_get_global_queue(0, 0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 2000ull*NSEC_PER_USEC); // 200 ms
    dispatch_after(delay, dispatch_get_global_queue(0, 0), ^{
        dispatch_io_write(_channel, 0, message, _socketQueue, ^(bool done, dispatch_data_t data, int error) {
            if(error) NSLog(@"WRITE ERROR!!!");
        });
    });
}

- (void)sendCommand:(NSString *)command withInterval:(NSUInteger)interval
{
    // TODO
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ at %@:%lu (unique identifier: %@)>",
            self.model, self.address, (unsigned long)_port, self.uniqueIdentifier];
}

#pragma mark Private Methods

- (dispatch_fd_t)fileDescriptorForHost:(NSString *)host onPort:(uint16_t)port
{
    struct sockaddr_in sock_addr;

    dispatch_fd_t sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sock == -1) {
        NSLog(@"Socket error: %s (%d)", strerror(errno), errno);
        return -1;
    }

    bzero(&sock_addr, sizeof sock_addr);
    sock_addr.sin_family = PF_INET;
    sock_addr.sin_port = htons(port);
    if (inet_pton(AF_INET, [host cStringUsingEncoding:NSASCIIStringEncoding], &sock_addr.sin_addr) < 1) {
        NSLog(@"Error parsing address: %s (%d)", strerror(errno), errno);
        close(sock);
        return -1;
    }

    if (connect(sock, (struct sockaddr *) &sock_addr, sizeof sock_addr) == -1) {
        NSLog(@"Connect error to %@: %s (%d)", host, strerror(errno), errno);
        close(sock);
        return -1;
    }
    NSLog(@"Connected to %@", host);
    return sock;
}

- (void)processData:(dispatch_data_t)data
{
    const void *buffer;
    size_t length;
    __unused dispatch_data_t tmpData = dispatch_data_create_map(data, &buffer, &length);
    NSData *response = [NSData dataWithBytes:buffer length:length];
    [self.delegate receiver:self didSendEvent:[[ONKEvent alloc] initWithData:response]];
}

@end
