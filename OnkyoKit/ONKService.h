//
//  ONKService.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

@import Foundation;
@class ONKReceiver;

@interface ONKService : NSObject

/** Receiver that provides this service. */
@property(readonly, weak, nonatomic) ONKReceiver *receiver;


/** Array of characteristics of this receiver. (read-only) */
@property(readonly, copy, nonatomic) NSArray *characteristics;

@end
