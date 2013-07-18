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

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName:ONKReceiverWasDiscoveredNotification
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *note){
                    [self.arrayController addObject:note.object];
                }];
    return self;
}

- (void)show
{
    [NSApp beginSheet: self.window
       modalForWindow: self.parentWindow
        modalDelegate: self
       didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
          contextInfo: nil];
    [ONKReceiver startReceiverDiscoveryWithCompletionHandler:NULL];

}

- (IBAction)acceptSelection:(id)sender
{
    [NSApp endSheet:self.window];
    [self.delegate receiverBrowser:self didSelectReceiver:self.receivers[self.arrayController.selectionIndex]];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
}



@end
