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
@property (nonatomic, strong, readwrite) NSDictionary *eventAttrs;
@property (nonatomic, strong, readwrite) NSDateFormatter *dateFormatter;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    self.eventAttrs = @{ NSFontAttributeName : font };
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm:ss.SSS"];


    self.onkyoController = [[ONKController alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error;
    // TODO: hangs on refused connection
    [_onkyoController connectToHost:@"192.168.1.69" error:&error];
    [_onkyoController sendCommand:@"PWRQSTN"];
}

- (void) controller:(ONKController *)controller didReceiveEvent:(ONKEvent *)event {
    NSString *message = [NSString stringWithFormat:@"%@: %@\n", [self.dateFormatter stringFromDate:[NSDate date]], [event description]];
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:message attributes:self.eventAttrs];
    NSTextStorage *text = self.consoleTextView.textStorage;
    [text beginEditing];
    [text appendAttributedString:as];
    [text endEditing];
    [self.consoleTextView scrollRangeToVisible:NSMakeRange(text.length, 0)];
}

- (IBAction)sendCommand:(NSTextField *)sender {
    [_onkyoController sendCommand:[sender stringValue]];
}
@end
