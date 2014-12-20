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
    self.onkyoReceiver = receiver;
    self.onkyoReceiver.delegate = self;
    self.onkyoReceiver.delegateQueue = [NSOperationQueue mainQueue];
    ONKService *main = self.onkyoReceiver.services[0];
    ONKCharacteristic *power = [main findCharacteristicWithType:ONKCharacteristicTypePowerState];
    [power readValueWithCompletionHandler:^(NSError *error){
        if (error) {
            NSLog(@"%@", error);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [NSApp presentError:error];
            }];
        }
    }];
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
    self.window.initialFirstResponder = self.commandTextField;
}

- (IBAction)sendCommand:(NSTextField *)sender
{
    os_activity_set_breadcrumb("send command to receiver");
    NSString *command = [sender stringValue];
    if ([[command lowercaseString] isEqualToString:@"browse"]) {
        [self showReceiverBrowser];
    } else {
        [self.onkyoReceiver sendCommand:command withCompletionHandler:^(NSError *error){
            if (error) {
                NSLog(@"%@", error);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [NSApp presentError:error];
                }];
            }
        }];
    }
}

// ONKReceiverDelegate
// this is called on delegateQueue
- (void)receiver:(ONKReceiver *)receiver service:(ONKService *)service didUpdateValueForCharacteristic:(ONKCharacteristic *)characteristic
{
    NSString *message = [NSString stringWithFormat:@"%@: %@\n",
                         [self.dateFormatter stringFromDate:[NSDate date]], characteristic];
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:message attributes:self.eventAttrs];
    NSTextStorage *text = self.consoleTextView.textStorage;
    [text beginEditing];
    [text appendAttributedString:as];
    [text endEditing];
    [self.consoleTextView scrollRangeToVisible:NSMakeRange(text.length, 0)];
}


@end
