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

#define RECV_BUF_LENGTH 100
#define TIMEOUT 2

// TODO: implement error reporting
@implementation ONKDeviceBrowser

- (instancetype)initWithCompletionHandler:(void (^)(void))completionHandler
{
    self = [super init];
	if (self == nil) return nil;
    _discoveryCompletionHandler = completionHandler;
    return self;
}

- (void)start
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setupSocket];
        [self broadcastDiscoveryPacket];
        [self discover];
        [self closeSocket];
        if (_discoveryCompletionHandler != NULL) {
            _discoveryCompletionHandler();
        }
    });
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

- (void)discover
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

            NSString *address = [NSString stringWithCString:inet_ntoa(dest_addr.sin_addr) encoding:NSASCIIStringEncoding];
            ONKReceiver *receiver = [self receiverFromDiscoveryData:[NSData dataWithBytes:recv_buf length:numbytes] atAddress:address];
            [[NSNotificationCenter defaultCenter] postNotificationName:ONKReceiverWasDiscoveredNotification object:receiver];
        }
    }
}

// TODO: set receiver model
- (ONKReceiver *)receiverFromDiscoveryData:(NSData *)message atAddress:(NSString *)address
{
    ONKEvent *event = [[ONKEvent alloc] initWithData:message];
    NSArray *components = [event.message.message componentsSeparatedByString:@"/"];
    ONKReceiver *receiver = [[ONKReceiver alloc] initWithHost:address onPort:[components[1] integerValue]];
    receiver.model = [components[0] substringFromIndex:3];
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
