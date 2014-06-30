//
//  ONKCharacteristic_Private.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/17/14.
//  Copyright (c) 2014 Jeff Hutchison. All rights reserved.
//

#import <OnkyoKit/OnkyoKit.h>

extern NSString * const ONKCharacteristicDefinitionName;
extern NSString * const ONKCharacteristicDefinitionType;

@interface ONKCharacteristic ()

@property(copy, nonatomic) id value;

- (instancetype)initWithService:(ONKService *)service characteristicDictionary:(NSDictionary *)characteristicDictionary;


@end
