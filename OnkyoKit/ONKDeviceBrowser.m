//
//  ONKDeviceBrowser.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 7/1/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Darwin;
#import "OnkyoKit.h"
#import "ISCPMessage.h"
#import "ONKConfiguredReceiver.h"

#define RECV_BUF_LENGTH 100
#define TIMEOUT 2

// TODO: implement error reporting
@implementation ONKDeviceBrowser
{
    int _sock;
    NSOperationQueue *_queue, *_delegateQueue;
    NSBlockOperation *_operation;
    NSMutableDictionary *_discoveredReceiversMap;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = @"Device Browser Queue";
        _discoveredReceiversMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setDelegate:(id<ONKReceiverBrowserDelegate>)delegate delegateQueue:(NSOperationQueue *)delegateQueue
{
    _delegate = delegate;
    _delegateQueue = delegateQueue;
}

- (NSOperationQueue *)delegateQueue
{
    if (!_delegateQueue) {
        _delegateQueue = [[NSOperationQueue alloc] init];
    }
    return _delegateQueue;
}

- (NSArray *)discoveredReceivers
{
    return [_discoveredReceiversMap allValues];
}


- (void)startSearchingForNewReceivers
{
    _operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = _operation;
    __weak ONKDeviceBrowser *weakSelf = self;
    [_operation addExecutionBlock:^{
        NSBlockOperation *op = weakOp;
        ONKDeviceBrowser *browser = weakSelf;
        [browser setupSocket];
        for (;;) {
            if ([op isCancelled]) break;
            [browser broadcastDiscoveryPacket];
            [browser listenForDevices];
        }
        [browser closeSocket];
    }];
    [_queue addOperation:_operation];
}

- (void)stopSearchingForNewReceivers
{
    [_operation cancel];
}

#pragma mark Private Methods

- (void)setupSocket
{
    struct sockaddr_in my_addr;
    int broadcast = 1;

    // UDP socket
    if ((_sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1) {
        NSLog(@"%s socket: %s", __PRETTY_FUNCTION__, strerror(errno));
    }

    // bind sock to any address and any port
    bzero(&my_addr, sizeof my_addr);
    my_addr.sin_family = AF_INET;
    my_addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(_sock, (struct sockaddr *)&my_addr, sizeof my_addr) == -1) {
        NSLog(@"%s bind: %s", __PRETTY_FUNCTION__, strerror(errno));
    }

    // will broadcast on sock
    if (setsockopt(_sock, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof broadcast) == -1) {
        NSLog(@"%s setsockopt: %s", __PRETTY_FUNCTION__, strerror(errno));
    }
}

- (void)broadcastDiscoveryPacket
{
    struct sockaddr_in dest_addr;
    ssize_t numbytes;

    // broadcast destination port is specifed in Onkyo documentation
    bzero(&dest_addr, sizeof dest_addr);
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_addr.s_addr = inet_addr("255.255.255.255");
    dest_addr.sin_port = htons(60128);

    ONKCommand *magic = [[ONKCommand alloc] initWithMessage:[ISCPMessage deviceSearchMessage]];
    if ((numbytes = sendto(_sock, [magic.data bytes], [magic.data length], 0, (struct sockaddr *)&dest_addr, sizeof dest_addr)) == -1) {
        NSLog(@"%s sendto: %s", __PRETTY_FUNCTION__, strerror(errno));
    }
}

- (void)listenForDevices
{
    struct sockaddr_in dest_addr;
    ssize_t numbytes;
    char recv_buf[RECV_BUF_LENGTH];
    fd_set read_fds;
    struct timeval timeout;
    int ready;

    // use select(2) loop to look for recieved devices
    FD_ZERO(&read_fds);

    for (;;) {
        FD_SET(_sock, &read_fds);
        timeout.tv_sec = TIMEOUT;
        timeout.tv_usec = 0;
        if ((ready = select(_sock+1, &read_fds, NULL, NULL, &timeout)) == -1) {
            // TODO: check for EINTR
            NSLog(@"%s select: %s", __PRETTY_FUNCTION__, strerror(errno));
            break;
        }

        if (!ready) { // timeout, nothing to receive
            break;
        }

        if (FD_ISSET(_sock, &read_fds)) {
            socklen_t addr_len = sizeof dest_addr;
            if ((numbytes = recvfrom(_sock, recv_buf, RECV_BUF_LENGTH, 0, (struct sockaddr *)&dest_addr, &addr_len)) == -1) {
                NSLog(@"%s recvfrom: %s", __PRETTY_FUNCTION__, strerror(errno));
            }

            NSString *address = @(inet_ntoa(dest_addr.sin_addr));
            ONKReceiver *receiver = [self receiverFromDiscoveryData:[NSData dataWithBytes:recv_buf length:numbytes] atAddress:address];
            if (![_discoveredReceiversMap objectForKey:receiver.uniqueIdentifier]) {
                [_discoveredReceiversMap setObject:receiver forKey:receiver.uniqueIdentifier];
                id<ONKReceiverBrowserDelegate> strongDelegate = self.delegate;
                [self.delegateQueue addOperationWithBlock:^{
                    [strongDelegate receiverBrowser:self didFindNewReceiver:receiver];
                }];
            }
        }
    }
}

- (ONKReceiver *)receiverFromDiscoveryData:(NSData *)message atAddress:(NSString *)address
{
    ONKEvent *event = [[ONKEvent alloc] initWithData:message];
    NSArray *components = [event.message.message componentsSeparatedByString:@"/"];
    ONKReceiver *receiver = [[ONKConfiguredReceiver alloc] initWithAddress:address port:[components[1] integerValue]];
    receiver.model = [components[0] substringFromIndex:3]; // trim leading 'ECN'
    NSString *mac = components[3]; // MAC address, max length 12 per onkyo docs
    receiver.uniqueIdentifier = [mac length] > 12 ? [mac substringToIndex:12] : mac;
    return receiver;
}

- (void)closeSocket
{
    // all done
    if (close(_sock) == -1) {
        NSLog(@"%s close: %s", __PRETTY_FUNCTION__, strerror(errno));
    }
}

@end
