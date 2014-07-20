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

- (BOOL)resumeWithError:(NSError * __autoreleasing *)error
{
    ONKReceiver *receiver = self.receiver; // make strong
    dispatch_fd_t fd = [self _fileDescriptorForAddress:receiver.address port:receiver.port error:error];
    if (fd  == -1) {
        if (error) NSLog(@"FD ERROR: %@", *error);
        return NO;
    }
    _channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, _socketQueue, NULL);
    dispatch_io_set_low_water(_channel, 1);

    ONKReceiverSession * __weak weakSelf = self; // avoid strong reference cycle while capturing self
    dispatch_io_read(_channel, 0, SIZE_MAX, _socketQueue, ^(bool done, dispatch_data_t data, int err) {
        ONKReceiverSession *cachedSelf = weakSelf; // make strong for clang
        if(err == 0) {
            [cachedSelf _processData:data];
        } else {
            NSError *readError = [cachedSelf _errorWithDescription:@"ERROR: network read" code:err];
            NSLog(@"%@", readError);
            [cachedSelf suspend];
        }
        if(done) NSLog(@"READ DONE!!!");
    });
    return YES;
}

- (void)suspend
{
    NSLog(@"Suspending session");
    if (_channel) {
        dispatch_io_close(_channel, 0);
        _channel = NULL;
    }
}

- (void)sendCommand:(NSString *)command withCompletionHandler:(void (^)(NSError *error))completion
{
    NSError * __autoreleasing channelError;
    if (!_channel) {
        if (![self resumeWithError:&channelError]) {
            if (completion) {
                completion(channelError);
                return;
            }
        }
    }
    EISCPPacket *packet = [[EISCPPacket alloc] initWithMessage:[[ISCPMessage alloc] initWithMessage:command]];
    dispatch_data_t message = dispatch_data_create([packet.data bytes], [packet.data length],
                                                   dispatch_get_global_queue(0, 0), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 2000ull*NSEC_PER_USEC); // 200 ms
    dispatch_after(delay, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_io_write(self->_channel, 0, message, self->_socketQueue, ^(bool done, dispatch_data_t data, int error) {
            if (error) {
                NSError *writeError = [self _errorWithDescription:@"Write error" code:error];
                completion(writeError);
            } else if (done) {
                completion(nil);
            }
        });
    });
}

#pragma mark Private Methods

- (dispatch_fd_t)_fileDescriptorForAddress:(NSString *)address port:(uint16_t)port error:(NSError * __autoreleasing *)error
{
    struct sockaddr_in sock_addr;

    dispatch_fd_t sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sock == -1) {
        if (error != NULL) {
            *error = [self _errorWithDescription:@"Socket error" code:errno];
        }
        return sock;
    }

    bzero(&sock_addr, sizeof sock_addr);
    sock_addr.sin_family = PF_INET;
    sock_addr.sin_port = htons(port);
    if (inet_pton(AF_INET, [address cStringUsingEncoding:NSASCIIStringEncoding], &sock_addr.sin_addr) < 1) {
        if (error != NULL) {
            *error = [self _errorWithDescription:[NSString stringWithFormat:@"Address %@ error", address] code:errno];
        }
        close(sock);
        return -1;
    }

    if (connect(sock, (struct sockaddr *) &sock_addr, sizeof sock_addr) == -1) {
        if (error != NULL) {
            *error = [self _errorWithDescription:[NSString stringWithFormat:@"Connect error to %@", address] code:errno];
        }
        close(sock);
        return -1;
    }
    NSLog(@"Connected to %@", address);
    return sock;
}

- (void)_processData:(dispatch_data_t)data
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

- (NSError *)_errorWithDescription:(NSString*)description code:(int)errorNumber
{
    NSString *localizedDescription = [NSString stringWithFormat:@"%@: %s", description, strerror(errorNumber)];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription};
    return [NSError errorWithDomain:NSPOSIXErrorDomain code:errorNumber userInfo:userInfo];
}

@end
