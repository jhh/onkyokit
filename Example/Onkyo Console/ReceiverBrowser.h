//
//  ReceiverBrowser.h
//  Onkyo Console
//
//  Created by Jeff Hutchison on 7/5/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Foundation;
#import <OnkyoKit/OnkyoKit.h>

@class ReceiverBrowser;

@protocol ReceiverBrowserDelegate <NSObject>

- (void)receiverBrowser:(ReceiverBrowser *)browser didSelectReceiver:(ONKReceiver *)receiver;

@end

@interface ReceiverBrowser : NSObject <ONKReceiverBrowserDelegate>
{
    @private
    ONKReceiverBrowser *_browser;
}

@property (strong) IBOutlet NSWindow *window;

@property (weak) NSWindow *parentWindow;
@property (weak) id<ReceiverBrowserDelegate> delegate;

@property (strong) NSMutableArray *receivers;

@property (strong) IBOutlet NSArrayController *arrayController;

- (IBAction)acceptSelection:(id)sender;

- (id)initWithParentWindow:(NSWindow *)window delegate:(id <ReceiverBrowserDelegate>)delegate;
- (void)show;

@end
