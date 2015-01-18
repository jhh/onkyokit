//
//  AppDelegate.m
//  OnkyoKit OS X Example
//
//  Created by Jeff Hutchison on 1/17/15.
//  Copyright (c) 2015 Jeff Hutchison. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
- (void)updateMuteButtonState;
@property (weak) IBOutlet NSWindow *window;
@property ONKReceiver *receiver;
@property ONKReceiverBrowser *browser;

@property ONKCharacteristic *powerCharacteristic;
@property NSString *powerButtonTitle;

@property ONKCharacteristic *muteCharacteristic;
@property NSString *muteButtonTitle;

@property ONKCharacteristic *volumeCharacteristic;
@property NSInteger volumeSliderValue;

@end

@implementation AppDelegate

- (void)receiverBrowser:(ONKReceiverBrowser *)browser didFindNewReceiver:(ONKReceiver *)receiver
{
    [self.browser stopSearchingForNewReceivers];
    self.receiver = receiver;
    self.receiver.delegate = self;
    self.receiver.delegateQueue = [NSOperationQueue mainQueue];
    NSLog(@"Connecting to receiver: %@", self.receiver);
    NSString *status = [NSString stringWithFormat:@"%@ at %@:%i", receiver, receiver.address, receiver.port];
    [self.statusLabel setStringValue:status];

    ONKService *mainService = receiver.services[0];
    self.powerCharacteristic = [mainService findCharacteristicWithType:ONKCharacteristicTypePowerState];
    [self.powerCharacteristic readValueWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@ readValue error: %@",self.powerCharacteristic, error);
        }
    }];
    self.muteCharacteristic = [mainService findCharacteristicWithType:ONKCharacteristicTypeMuteState];
    [self.muteCharacteristic readValueWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@ readValue error: %@",self.muteCharacteristic, error);
        }
    }];
    self.volumeCharacteristic = [mainService findCharacteristicWithType:ONKCharacteristicTypeMasterVolume];
    [self.volumeCharacteristic readValueWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@ readValue error: %@",self.volumeCharacteristic, error);
        }
    }];
}

- (void)receiver:(ONKReceiver *)receiver
         service:(ONKService *)service
didUpdateValueForCharacteristic:(ONKCharacteristic *)characteristic
{
    if (characteristic == self.muteCharacteristic) {
        [self updateMuteButtonState];
    } else if (characteristic == self.powerCharacteristic) {
        [self updatePowerButtonState];
    } else if (characteristic == self.volumeCharacteristic) {
        [self updateVolumeSliderValue];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.browser = [ONKReceiverBrowser browserWithDelegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [self.statusLabel setStringValue:@"Browsing for receivers on network..."];
    [self.browser startSearchingForNewReceivers];
    [self.muteButton bind:@"title" toObject:self withKeyPath:@"muteButtonTitle" options:nil];
    [self.powerButton bind:@"title" toObject:self withKeyPath:@"powerButtonTitle" options:nil];
    [self.volumeSlider bind:@"integerValue" toObject:self withKeyPath:@"volumeSliderValue" options:nil];
}

- (IBAction)togglePower:(NSButton *)sender
{
    [self.powerCharacteristic writeValue:[NSNumber numberWithBool:(!self.powerCharacteristic.boolValue)]
                      completionHandler:^(NSError *error) {
                          if (error) {
                              NSLog(@"%@ writeValue error: %@",self.powerCharacteristic, error);
                          }
                      }];
}

- (IBAction)toggleMute:(NSButton *)sender
{
    [self.muteCharacteristic writeValue:[NSNumber numberWithBool:(!self.muteCharacteristic.boolValue)]
                      completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@ writeValue error: %@",self.muteCharacteristic, error);
        }
    }];
}
- (IBAction)adjustVolume:(id)sender {
    NSLog(@"Volume slider adjusted to: %ld", self.volumeSlider.integerValue);
    [self.volumeCharacteristic writeValue:[NSNumber numberWithInteger:self.volumeSlider.integerValue]
                        completionHandler:^(NSError *error) {
                            NSLog(@"%@ writeValue error: %@",self.volumeCharacteristic, error);
                        }];
}

- (void)updatePowerButtonState
{
    NSLog(@"Updating power button state to value: %hhd", self.powerCharacteristic.boolValue);
    self.powerButtonTitle = self.powerCharacteristic.boolValue ? @"Power Standby" : @"Power On";
}

- (void)updateMuteButtonState
{
    NSLog(@"Updating mute button state to value: %hhd", self.muteCharacteristic.boolValue);
    self.muteButtonTitle = self.muteCharacteristic.boolValue ? @"Unmute" : @"Mute";
}

- (void)updateVolumeSliderValue
{
    NSLog(@"Updating mute button state to value: %ld", (long)self.volumeSliderValue);
    self.volumeSliderValue = self.volumeCharacteristic.integerValue;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
