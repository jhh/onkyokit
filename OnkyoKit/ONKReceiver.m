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

// TODO: implement error reporting
@implementation ONKReceiver
{
    NSString *_host;
    NSUInteger _port;

    /** GCD IO channel. */
    dispatch_io_t _channel;

    /** A GCD queue created to handle network traffic. */
    dispatch_queue_t _socketQueue;

}


#pragma mark Instance Methods
- (instancetype)initWithHost:(NSString *)host onPort:(NSUInteger)port
{
    NSParameterAssert(host != nil);
    NSParameterAssert(port > 0 && port < 65535);

    self = [super init];
	if (self == nil) return nil;
    _socketQueue = dispatch_queue_create("com.jeffhutchison.OnkyoKit.socket", DISPATCH_QUEUE_SERIAL);
    _host = [host copy];
    _address = _host; // TODO: replace host with address
    _port = port;
    return self;
}

- (void)resume
{
    NSAssert(self.delegateQueue != nil, @"delegateQueue parameter not set");
    dispatch_fd_t fd = [self fileDescriptorForHost:_host onPort:_port];
    if (fd  == -1) {
        id<ONKDelegate> strongDelegate = self.delegate;
        [strongDelegate receiver:self didFailWithError:self.error];
        return;
    }
    _channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, _socketQueue, NULL);
    dispatch_io_set_low_water(_channel, 1);

    __weak ONKReceiver *weakSelf = self;
    dispatch_io_read(_channel, 0, SIZE_MAX, _socketQueue, ^(bool done, dispatch_data_t data, int error) {
        ONKReceiver *strongSelf = weakSelf;
        if(strongSelf && error == 0) {
            [strongSelf processData:data];
        } else if (strongSelf) {
            [strongSelf setErrorWithDescription:@"Network read error" code:error];
            [strongSelf.delegateQueue addOperationWithBlock:^{
                id<ONKDelegate> strongDelegate = self.delegate;
                [strongDelegate receiver:strongSelf didFailWithError:strongSelf.error];
            }];
        } else {
            NSLog(@"strongSelf was nil");
        }
        if(done) NSLog(@"READ DONE!!!");
    });
}

- (void)suspend
{
    if (_channel) {
        dispatch_io_close(_channel, 0);
        _channel = NULL;
    }
}

- (void)sendCommand:(NSString *)command
{
    ONKCommand *packet = [ONKCommand commandWithMessage:[[ISCPMessage alloc] initWithMessage:command]];
    dispatch_data_t message = dispatch_data_create([packet.data bytes], [packet.data length], dispatch_get_global_queue(0, 0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 2000ull*NSEC_PER_USEC); // 200 ms
    dispatch_after(delay, dispatch_get_global_queue(0, 0), ^{
        dispatch_io_write(self->_channel, 0, message, self->_socketQueue, ^(bool done, dispatch_data_t data, int error) {
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
        [self setErrorWithDescription:@"Socket error" code:errno];
        return -1;
    }

    bzero(&sock_addr, sizeof sock_addr);
    sock_addr.sin_family = PF_INET;
    sock_addr.sin_port = htons(port);
    if (inet_pton(AF_INET, [host cStringUsingEncoding:NSASCIIStringEncoding], &sock_addr.sin_addr) < 1) {
        [self setErrorWithDescription:[NSString stringWithFormat:@"Address %@ error", host] code:errno];
        close(sock);
        return -1;
    }

    if (connect(sock, (struct sockaddr *) &sock_addr, sizeof sock_addr) == -1) {
        [self setErrorWithDescription:[NSString stringWithFormat:@"Connect error to %@", host] code:errno];
        close(sock);
        return -1;
    }
    NSLog(@"Connected to %@", host);
    return sock;
}

- (void)processData:(dispatch_data_t)data
{
    [self.delegateQueue addOperationWithBlock:^{
        const void *buffer;
        size_t length;
        __unused dispatch_data_t tmpData = dispatch_data_create_map(data, &buffer, &length);
        NSData *response = [NSData dataWithBytes:buffer length:length];
        id<ONKDelegate> strongDelegate = self.delegate;
        [strongDelegate receiver:self didSendEvent:[[ONKEvent alloc] initWithData:response]];
    }];
}

- (void)setErrorWithDescription:(NSString*)description code:(int)errorNumber
{
    NSString *localizedDescription = [NSString stringWithFormat:@"%@: %s", description, strerror(errorNumber)];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription};
    self.error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errorNumber userInfo:userInfo];
    NSLog(@"Error: %@", self.error);
}

@end
