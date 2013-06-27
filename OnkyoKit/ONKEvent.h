//
//  ONKEvent.h
//  OnkyoKit
//
//  Created by Jeff Hutchison on 6/8/13.
//  Copyright (c) 2013 Jeff Hutchison. All rights reserved.
//

@import Foundation;
#import <OnkyoKit/EISCPPacket.h>

/**
Event received over network from device.

Events may be generated as a result of sending a ONKCommand or by outside control of the receiver.
*/
@interface ONKEvent : EISCPPacket


@end
