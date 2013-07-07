//
//  AppDelegate.m
//  Onkyo Console
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "AppDelegate.h"

// This is set manually to allow testing for the time being
#define RECEIVER_ADDRESS @"192.168.1.69"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) ONKReceiver *onkyoReceiver;
@property (nonatomic, strong, readwrite) NSDictionary *eventAttrs;
@property (nonatomic, strong, readwrite) NSDateFormatter *dateFormatter;

@end

@implementation AppDelegate

- (void)receiverBrowser:(ReceiverBrowser *)browser didSelectReceiver:(ONKReceiver *)receiver
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.onkyoReceiver = receiver;
    self.onkyoReceiver.delegate = self;
    [self.onkyoReceiver resume];
    [_onkyoReceiver sendCommand:@"PWRQSTN"];
}

- (void)setUpTextView
{
    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    self.eventAttrs = @{ NSFontAttributeName : font };
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setUpTextView];

    if (!self.receiverBrowser) {
        self.receiverBrowser = [[ReceiverBrowser alloc] initWithParentWindow:self.window delegate:self];
    }
    [self.receiverBrowser show];
}

// this is called on a non-main serial queue
- (void) receiver:(ONKReceiver *)controller didSendEvent:(ONKEvent *)event
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = [NSString stringWithFormat:@"%@: %@\n", [self.dateFormatter stringFromDate:[NSDate date]], [event description]];
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:message attributes:self.eventAttrs];
        NSTextStorage *text = self.consoleTextView.textStorage;
        [text beginEditing];
        [text appendAttributedString:as];
        [text endEditing];
        [self.consoleTextView scrollRangeToVisible:NSMakeRange(text.length, 0)];
    });
}

// this is called on a non-main serial queue
- (void)receiver:(ONKReceiver *)receiver didFailWithError:(NSError *)error
{
    // TODO
}

- (IBAction)sendCommand:(NSTextField *)sender
{
    [_onkyoReceiver sendCommand:[sender stringValue]];
}


@end
