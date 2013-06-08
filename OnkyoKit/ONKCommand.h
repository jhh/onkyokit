//
//  ONKMessage.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONKCommand : NSObject

+ (NSData *)dataForCommand:(NSString*)command;

@end
