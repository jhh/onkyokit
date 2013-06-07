//
//  ONKReceiver.m
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/2/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ONKReceiver.h"

@implementation ONKReceiver

- (id)initWithAddress:(NSString *)address {
    return [self initWithAddress:address onPort:60128];
}

- (id)initWithAddress:(NSString *)address  onPort:(uint16_t)port {
    self = [super init];
	if (self == nil) return nil;

    return self;
}

- aMethod:(NSString *)anArgument {
    NSLog(@"%@", anArgument);
    return nil;
}


+ (NSArray *)discoverableReceivers {
    return [NSArray array];
}

+ (instancetype)firstDiscoverableReceiver {
    return nil;
}

@end
