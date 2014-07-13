//
//  ONKService_Private.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import "ONKService.h"

extern NSString * const ONKServiceDefinitionName;
extern NSString * const ONKServiceDefinitionCharacteristics;

@interface ONKService ()

@property(copy, nonatomic) NSString *name;

- (instancetype)initWithReceiver:(ONKReceiver *)receiver
               serviceDictionary:(NSDictionary *)serviceDictionary NS_DESIGNATED_INITIALIZER;
@end
