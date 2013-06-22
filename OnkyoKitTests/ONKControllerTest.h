//
//  ONKControllerTest.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/12/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ONKControllerTest : XCTestCase <ONKDelegate>

@property ONKController *controller;
@property ONKEvent *event;
@property (getter = hasPassed) BOOL passed;
@property NSCondition *condition;


- (void) controller:(ONKController *)controller didReceiveEvent:(ONKEvent *)event;

@end
