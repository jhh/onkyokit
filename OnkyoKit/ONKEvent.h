//
//  ONKEvent.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONKEvent : NSObject

- (id) initWithString:(NSString *)rawEvent;

- (id) initWithData:(NSData *)rawEvent;

@end
