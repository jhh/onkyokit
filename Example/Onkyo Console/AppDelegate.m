//
//  AppDelegate.m
//  Onkyo Console
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) ONKReceiver *onkyoReceiver;
@property (nonatomic, strong, readwrite) NSDictionary *eventAttrs;
@property (nonatomic, strong, readwrite) NSDateFormatter *dateFormatter;

@end

@implementation AppDelegate

- (void)receiverBrowser:(ReceiverBrowser *)browser didSelectReceiver:(ONKReceiver *)receiver
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.onkyoReceiver) {
        NSLog(@"Disconnecting from %@", self.onkyoReceiver);
        [self.onkyoReceiver suspend];
    }
    self.onkyoReceiver = receiver;
    self.onkyoReceiver.delegate = self;
    self.onkyoReceiver.delegateQueue = [NSOperationQueue mainQueue];
    [self.onkyoReceiver resume];
    [self.onkyoReceiver sendCommand:@"PWRQSTN"];
}

- (void)setUpTextView
{
    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    self.eventAttrs = @{ NSFontAttributeName : font };
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
}

- (void)showReceiverBrowser
{
    if (!self.receiverBrowser) {
        self.receiverBrowser = [[ReceiverBrowser alloc] initWithParentWindow:self.window delegate:self];
    }
    [self.receiverBrowser show];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setUpTextView];

    [self showReceiverBrowser];
}

// this is called on delegateQueue
- (void) receiver:(ONKReceiver *)controller didSendEvent:(EISCPPacket *)event
{
    NSString *message = [NSString stringWithFormat:@"%@: %@\n", [self.dateFormatter stringFromDate:[NSDate date]], [event description]];
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:message attributes:self.eventAttrs];
    NSTextStorage *text = self.consoleTextView.textStorage;
    [text beginEditing];
    [text appendAttributedString:as];
    [text endEditing];
    [self.consoleTextView scrollRangeToVisible:NSMakeRange(text.length, 0)];
}

// this is called on delegateQueue
- (void)receiver:(ONKReceiver *)receiver didFailWithError:(NSError *)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    [self.window presentError:error];
}

- (IBAction)sendCommand:(NSTextField *)sender
{
    NSString *command = [sender stringValue];
    if ([[command lowercaseString] isEqualToString:@"browse"]) {
        [self showReceiverBrowser];
    } else {
        [self.onkyoReceiver sendCommand:command];
    }
}


@end
