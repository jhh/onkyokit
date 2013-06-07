//
//  ONKReceiver.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/2/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONKReceiver : NSObject

- (id)initWithAddress:(NSString *)address;

// designated initializer
- (id)initWithAddress:(NSString *)address  onPort:(uint16_t)port;

- aMethod:(NSString *)anArgument;

+ (NSArray *)discoverableReceivers;

+ (instancetype)firstDiscoverableReceiver;

@end
