//
//  ONKCharacteristicTests.m
//  OnkyoKit Tests
//
//  Created by Jeff Hutchison on 1/18/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "ISCPMessage.h"
#import "ONKCharacteristic_Private.h"
#import "ONKCharacteristicMetadata_Private.h"

#define EXP_SHORTHAND
#import "Expecta.h"

@interface ONKCharacteristicTests : XCTestCase

@end

@implementation ONKCharacteristicTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMuteCharacteristic
{
    ONKCharacteristic *c = [self muteCharacteristic];
    expect(c).to.beInstanceOf([ONKCharacteristic class]);
    expect(c.metadata.units).to.equal(@(ONKCharacteristicUnitBoolean));
    expect(c.metadata.minimumValue).to.equal(@(0));
    expect(c.metadata.maximumValue).to.equal(@(1));
}

- (void)testMasterVolumeCharacteristic
{
    ONKCharacteristic *c = [self masterVolumeCharacteristic];
    expect(c).to.beInstanceOf([ONKCharacteristic class]);
    expect(c.metadata.units).to.equal(@(ONKCharacteristicUnitNumeric));
    expect(c.metadata.minimumValue).to.equal(@(0));
    expect(c.metadata.maximumValue).to.equal(@(100));
}

- (void)testBoolValue {
    ONKCharacteristic *c = [self muteCharacteristic];
    [c handleMessage:[self iscpMessage:@"AMT00"]];
    expect(c.value).to.equal(@NO);
    expect(c.boolValue).to.equal(NO);
    [c handleMessage:[self iscpMessage:@"AMT01"]];
    expect(c.value).to.equal(@YES);
    expect(c.boolValue).to.equal(YES);
}

- (void)testBoolValueNumericCoercion
{
    ONKCharacteristic *c = [self masterVolumeCharacteristic];
    [c handleMessage:[self iscpMessage:@"MVL2F"]];
    expect(c.value).to.equal(@(47));
    expect(c.boolValue).to.equal(YES);
    [c handleMessage:[self iscpMessage:@"MVL00"]];
    expect(c.value).to.equal(@(0));
    expect(c.boolValue).to.equal(NO);
}

- (void)testIntegerValue
{
    ONKCharacteristic *c = [self masterVolumeCharacteristic];
    [c handleMessage:[self iscpMessage:@"MVL30"]];
    expect(c.integerValue).to.equal(48);
    [c handleMessage:[self iscpMessage:@"MVL00"]];
    expect(c.integerValue).to.equal(0);
}

- (void)testIntegerValueBooleanCoercion
{
    ONKCharacteristic *c = [self muteCharacteristic];
    [c handleMessage:[self iscpMessage:@"AMT00"]];
    expect(c.integerValue).to.equal(0);
    [c handleMessage:[self iscpMessage:@"AMT01"]];
    expect(c.integerValue).to.equal(1);
}

- (ONKCharacteristic *)muteCharacteristic
{
    NSDictionary *charDict = @{
                               ONKCharacteristicDefinitionName : @"Audio Muting",
                               ONKCharacteristicDefinitionType : @"onkyo.amt",
                               ONKCharacteristicDefinitionCode : @"AMT",
                               ONKCharacteristicDefinitionMetadata : @{
                                       ONKCharacteristicMetadataDefinitionMinValue : @(0),
                                       ONKCharacteristicMetadataDefinitionMaxValue : @(1),
                                       ONKCharacteristicMetadataDefinitionUnits : @(ONKCharacteristicUnitBoolean)
                                       }
                               };
    return [[ONKCharacteristic alloc] initWithService:nil characteristicDictionary:charDict];
}

- (ONKCharacteristic *)masterVolumeCharacteristic
{
    NSDictionary *charDict = @{
                               ONKCharacteristicDefinitionName : @"Master Volume",
                               ONKCharacteristicDefinitionType : @"onkyo.mvl",
                               ONKCharacteristicDefinitionCode : @"MVL",
                               ONKCharacteristicDefinitionMetadata : @{
                                       ONKCharacteristicMetadataDefinitionMinValue : @(0),
                                       ONKCharacteristicMetadataDefinitionMaxValue : @(100),
                                       ONKCharacteristicMetadataDefinitionUnits : @(ONKCharacteristicUnitNumeric)
                                       }
                               };
    return [[ONKCharacteristic alloc] initWithService:nil characteristicDictionary:charDict];
}

- (ISCPMessage*)iscpMessage:(NSString *)message
{
    return [[ISCPMessage alloc] initWithData:[[NSString stringWithFormat:@"!1%@\x1a", message]
                                              dataUsingEncoding:NSASCIIStringEncoding]];

}

@end
