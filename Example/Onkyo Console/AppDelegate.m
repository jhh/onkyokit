//
//  AppDelegate.m
//  Onkyo Console
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) ONKController *onkyoController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.onkyoController = [[ONKController alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error;
    // TODO: hangs on refused connection
    [_onkyoController connectToHost:@"192.168.1.69" error:&error];
    [_onkyoController sendCommand:@"!1PWRQSTN"];
}

- (void) controller:(ONKController *)controller didReceiveEvent:(ONKEvent *)event {
    NSLog(@"EVENT: %@", event);
}

@end
