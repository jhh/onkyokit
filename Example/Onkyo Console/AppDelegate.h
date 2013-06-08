//
//  AppDelegate.h
//  Onkyo Console
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OnkyoKit/OnkyoKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, ONKDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
