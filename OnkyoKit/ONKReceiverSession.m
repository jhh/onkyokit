//
//  ONKReceiverSession.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/14/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//
@import Darwin;
#import "ONKReceiverSession.h"
#import "ONKReceiver_Private.h"
#import "EISCPPacket.h"
#import "ISCPMessage.h"

@implementation ONKReceiverSession
{
    /** GCD IO channel. */
    dispatch_io_t _channel;

    /** A GCD queue created to handle network traffic. */
    dispatch_queue_t _socketQueue;

}

#pragma mark Public Methods

- (instancetype)initWithReceiver:(ONKReceiver *)receiver
{
    NSParameterAssert(receiver);
    self = [super init];
	if (self) {
        _receiver = receiver;
        _socketQueue = dispatch_queue_create("com.jeffhutchison.OnkyoKit.socket", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)resume
{
    ONKReceiver *receiver = self.receiver; // make strong
    dispatch_fd_t fd = [self fileDescriptorForAddress:receiver.address port:receiver.port];
    if (fd  == -1) {
        id<ONKReceiverDelegate> cachedDelegate = receiver.delegate; // make strong for clang
        [receiver.delegateQueue addOperationWithBlock:^{
            [cachedDelegate receiver:receiver didFailWithError:self.error];
        }];
        [cachedDelegate receiver:receiver didFailWithError:self.error];
        return;
    }
    _channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, _socketQueue, NULL);
    dispatch_io_set_low_water(_channel, 1);

    __weak ONKReceiverSession *weakSelf = self; // avoid strong reference cycle while capturing self
    dispatch_io_read(_channel, 0, SIZE_MAX, _socketQueue, ^(bool done, dispatch_data_t data, int error) {
        ONKReceiverSession *cachedSelf = weakSelf; // make strong for clang
        NSAssert(cachedSelf, @"ASSERT: cachedSelf cannot be nil");
        if(error == 0) {
            [cachedSelf processData:data];
        } else {
            [cachedSelf setErrorWithDescription:@"ERROR: network read" code:error];
            [receiver.delegateQueue addOperationWithBlock:^{
                id<ONKReceiverDelegate> cachedDelegate = receiver.delegate; // make strong for clang
                [cachedDelegate receiver:cachedSelf.receiver didFailWithError:cachedSelf.error];
            }];
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
    EISCPPacket *packet = [[EISCPPacket alloc] initWithMessage:[[ISCPMessage alloc] initWithMessage:command]];
    dispatch_data_t message = dispatch_data_create([packet.data bytes], [packet.data length],
                                                   dispatch_get_global_queue(0, 0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 2000ull*NSEC_PER_USEC); // 200 ms
    dispatch_after(delay, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_io_write(self->_channel, 0, message, self->_socketQueue, ^(bool done, dispatch_data_t data, int error) {
            if(error) NSLog(@"WRITE ERROR!!!");
        });
    });
}

#pragma mark Private Methods

- (dispatch_fd_t)fileDescriptorForAddress:(NSString *)address port:(uint16_t)port
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
    if (inet_pton(AF_INET, [address cStringUsingEncoding:NSASCIIStringEncoding], &sock_addr.sin_addr) < 1) {
        [self setErrorWithDescription:[NSString stringWithFormat:@"Address %@ error", address] code:errno];
        close(sock);
        return -1;
    }

    if (connect(sock, (struct sockaddr *) &sock_addr, sizeof sock_addr) == -1) {
        [self setErrorWithDescription:[NSString stringWithFormat:@"Connect error to %@", address] code:errno];
        close(sock);
        return -1;
    }
    NSLog(@"Connected to %@", address);
    return sock;
}

- (void)processData:(dispatch_data_t)data
{
    // capture strong reference to receiver in block, avoid reference cycle to self
    ONKReceiver *cachedReceiver = self.receiver;
    [cachedReceiver.delegateQueue addOperationWithBlock:^{
        const void *buffer;
        size_t length;
        __unused dispatch_data_t tmpData = dispatch_data_create_map(data, &buffer, &length);
        NSData *response = [NSData dataWithBytes:buffer length:length];
        EISCPPacket *packet = [[EISCPPacket alloc] initWithData:response];
        [cachedReceiver handleMessage:packet.message];
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
