//
//  ONKReciever.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/7/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//
#import "ONKReceiver_Private.h"
#import "ONKReceiverSession.h"
#import "ONKService_Private.h"
#import "ONKCharacteristic_Private.h"

@implementation ONKReceiver

- (instancetype)initWithModel:(NSString *)model
             uniqueIdentifier:(NSString *)uniqueIdentifier
                      address:(NSString *)address
                         port:(UInt16)port
{
    self = [super init];
    if (self && model && uniqueIdentifier && address && port > 0) {
        _model = [model copy];
        _uniqueIdentifier = [uniqueIdentifier copy];
        _address = address;
        _port = port;
        _session = [[ONKReceiverSession alloc] initWithReceiver:self];
        [self _registerServices];
    } else {
        self = nil;
    }
    return self;
}

- (void)handleMessage:(ISCPMessage *)message
{
    ONKCharacteristic *characteristic = self.codeMap[message.code];
    if (characteristic) {
        [characteristic handleMessage:message];
    } else {
        NSLog(@"unrecognized message: %@", message);
    }
    
}

- (void)_registerServices
{
    // load service definitions from property list
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.jeffhutchison.OnkyoKit"];
    NSURL *url = [bundle URLForResource:@"TX-NR616" withExtension:@"plist"];
    NSArray *serviceDefinitions = [NSArray arrayWithContentsOfURL:url];
    NSMutableArray *tempServices = [NSMutableArray array];
    for (NSDictionary *serviceDict in serviceDefinitions) {
        [tempServices addObject:[[ONKService alloc] initWithReceiver:self serviceDictionary:serviceDict]];
    }
    _services = [tempServices copy];
    
    // create map from receiver command code to characteristic
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    for (ONKService *service in _services) {
        for (ONKCharacteristic *characteristic in service.characteristics) {
            tempDict[characteristic.code] = characteristic;
        }
    }
    _codeMap = [tempDict copy];
}

- (void)resume
{
    [((ONKReceiver *)self).session resume];
}

- (void)suspend
{
    [((ONKReceiver *)self).session suspend];
}

- (void)sendCommand:(NSString *)command
{
    [((ONKReceiver *)self).session sendCommand:command];

}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ONKReciever: %@ (%@)", self.model, self.uniqueIdentifier];
}

@end
