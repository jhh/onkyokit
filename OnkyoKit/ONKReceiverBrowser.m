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
#import "ONKReceiver_Private.h"

#define RECV_BUF_LENGTH 100
#define TIMEOUT 2

@interface ONKReceiverBrowser ()

@property (weak, nonatomic) id<ONKReceiverBrowserDelegate> delegate;
@property (nonatomic) NSOperationQueue *delegateQueue;

@end

// TODO: implement error reporting
@implementation ONKReceiverBrowser
{
    int _sock;
    NSOperationQueue *_workQueue, *_delegateQueue;
    NSBlockOperation *_operation;
    NSMutableDictionary *_discoveredReceiversMap;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _workQueue = [[NSOperationQueue alloc] init];
        _workQueue.name = @"ONKRecieverBrowser Work Queue";
        _discoveredReceiversMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (instancetype)browserWithDelegate:(id<ONKReceiverBrowserDelegate>)delegate delegateQueue:(NSOperationQueue *)queue
{
    ONKReceiverBrowser *browser = [[ONKReceiverBrowser alloc] init];
    browser.delegate = delegate;
    browser.delegateQueue = queue ? queue : [[NSOperationQueue alloc] init];
    return browser;
}

- (NSArray *)discoveredReceivers
{
    return [_discoveredReceiversMap allValues];
}


- (void)startSearchingForNewReceivers
{
    _operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = _operation;
    __weak ONKReceiverBrowser *weakSelf = self;
    [_operation addExecutionBlock:^{
        NSBlockOperation *op = weakOp;
        ONKReceiverBrowser *browser = weakSelf;
        [browser setupSocket];
        for (;;) {
            if ([op isCancelled]) break;
            [browser broadcastDiscoveryPacket];
            [browser listenForDevices];
        }
        [browser closeSocket];
    }];
    [_workQueue addOperation:_operation];
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
        NSLog(@"ERROR: %s socket: %s", __PRETTY_FUNCTION__, strerror(errno));
    }

    // bind sock to any address and any port
    bzero(&my_addr, sizeof my_addr);
    my_addr.sin_family = AF_INET;
    my_addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(_sock, (struct sockaddr *)&my_addr, sizeof my_addr) == -1) {
        NSLog(@"ERROR: %s bind: %s", __PRETTY_FUNCTION__, strerror(errno));
    }

    // will broadcast on sock
    if (setsockopt(_sock, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof broadcast) == -1) {
        NSLog(@"ERROR: %s setsockopt: %s", __PRETTY_FUNCTION__, strerror(errno));
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
    numbytes = sendto(_sock, [magic.data bytes], [magic.data length], 0, (struct sockaddr *)&dest_addr, sizeof dest_addr);
    if (numbytes == -1) {
        NSLog(@"ERROR: %s sendto: %s", __PRETTY_FUNCTION__, strerror(errno));
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

    // loop through the number of receivers found on the network
    for (;;) {
        // use select to check _sock with timeout
        do {
            FD_ZERO(&read_fds);
            FD_SET(_sock, &read_fds);
            timeout.tv_sec = TIMEOUT;
            timeout.tv_usec = 0;
            ready = select(_sock+1, &read_fds, NULL, NULL, &timeout);
        } while (ready == -1 && errno == EINTR);

        // break on _sock timeout or error
        if (ready == 0) {
            NSLog(@"TIMEOUT: %s", __PRETTY_FUNCTION__);
            break;
        } else if (!ready) {
            NSLog(@"ERROR: %s select: %s", __PRETTY_FUNCTION__, strerror(errno));
            break;
        }

        // read from ready _sock
        if (FD_ISSET(_sock, &read_fds)) {
            socklen_t addr_len = sizeof dest_addr;
            numbytes = recvfrom(_sock, recv_buf, RECV_BUF_LENGTH, 0, (struct sockaddr *)&dest_addr, &addr_len);
            if (numbytes == -1) {
                NSLog(@"ERROR: %s recvfrom: %s", __PRETTY_FUNCTION__, strerror(errno));
                break;
            }

            // use data in recv_buf to initialize ONKReceiver object
            NSString *address = @(inet_ntoa(dest_addr.sin_addr));
            ONKReceiver *receiver = [self receiverFromDiscoveryData:[NSData dataWithBytes:recv_buf length:numbytes]
                                                          atAddress:address];

            // call delegate if this is first response from this receiver
            if (!_discoveredReceiversMap[receiver.uniqueIdentifier]) {
                _discoveredReceiversMap[receiver.uniqueIdentifier] = receiver;
                // block captures strong reference to delegate
                id<ONKReceiverBrowserDelegate> cachedDelegate = self.delegate;
                [self.delegateQueue addOperationWithBlock:^{
                    [cachedDelegate receiverBrowser:self didFindNewReceiver:receiver];
                }];
            }
        }
    }
}

- (ONKReceiver *)receiverFromDiscoveryData:(NSData *)message atAddress:(NSString *)address
{
    EISCPPacket *event = [[EISCPPacket alloc] initWithData:message];
    NSArray *components = [event.message.message componentsSeparatedByString:@"/"];
    NSString *mac = components[3];

    ONKReceiver *receiver = [[ONKReceiver alloc] initWithModel:[components[0] substringFromIndex:3] // trim leading 'ECN'
                                              uniqueIdentifier:[mac substringToIndex:MIN(12ul, [mac length])]
                                                       address:address
                                                          port:(UInt16)[components[1] integerValue]];
    return receiver;
}

- (void)closeSocket
{
    // all done
    if (close(_sock) == -1) {
        NSLog(@"ERROR: %s close: %s", __PRETTY_FUNCTION__, strerror(errno));
    }
}

@end
