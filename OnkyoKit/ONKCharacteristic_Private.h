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
extern NSString * const ONKCharacteristicDefinitionCode;
extern NSString * const ONKCharacteristicDefinitionMetadata;

@interface ONKCharacteristic ()

@property(copy, nonatomic) id value;
@property(readonly, copy, nonatomic) NSString *code;

- (instancetype)initWithService:(ONKService *)service
       characteristicDictionary:(NSDictionary *)characteristicDictionary NS_DESIGNATED_INITIALIZER;

- (void)handleMessage:(ISCPMessage *)message;

@end
