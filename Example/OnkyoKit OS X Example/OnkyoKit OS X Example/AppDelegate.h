//
//  AppDelegate.h
//  OnkyoKit OS X Example
//
//  Created by Jeff Hutchison on 1/17/15.
//  Copyright (c) 2015 Jeff Hutchison. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OnkyoKit.h"
#import "ONKReceiver_Private.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ONKReceiverBrowserDelegate, ONKReceiverDelegate>

@property (weak) IBOutlet NSButton *powerButton;
@property (weak) IBOutlet NSButton *muteButton;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSSlider *volumeSlider;

- (void)receiverBrowser:(ONKReceiverBrowser *)browser didFindNewReceiver:(ONKReceiver *)receiver;

@end

