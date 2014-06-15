//
//  ReceiverBrowser.m
//  Onkyo Console
//
//  Created by Jeff Hutchison on 7/5/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

#import "ReceiverBrowser.h"
#import <OnkyoKit/OnkyoKit.h>

@implementation ReceiverBrowser

- (id)initWithParentWindow:(NSWindow *)window delegate:(id<ReceiverBrowserDelegate>)delegate
{
    self = [super init];
    if (self == nil) return nil;
    _receivers = [NSMutableArray arrayWithCapacity:5];
    _parentWindow = window;
    _delegate = delegate;

    NSArray *topLevelObjects;
    [[NSBundle mainBundle] loadNibNamed:@"ReceiverSheet" owner:self topLevelObjects:&topLevelObjects];

    _browser = [[ONKReceiverBrowser alloc] init];
    [_browser setDelegate:self delegateQueue:[NSOperationQueue mainQueue]];

    return self;
}

- (void)show
{
    [self.receivers removeAllObjects];
    [NSApp beginSheet: self.window
       modalForWindow: self.parentWindow
        modalDelegate: self
       didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
          contextInfo: nil];
    [_browser startSearchingForNewReceivers];
}

- (IBAction)acceptSelection:(id)sender
{
    [_browser stopSearchingForNewReceivers];
    [NSApp endSheet:self.window];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
    [self.delegate receiverBrowser:self didSelectReceiver:self.receivers[self.arrayController.selectionIndex]];
}

// Protocol ONKReceiverBrowserDelegate
- (void)receiverBrowser:(ONKReceiverBrowser *)browser didFindNewReceiver:(ONKReceiver *)receiver
{
    [self.arrayController addObject:receiver];
}

@end
