//
//  URPlayer.m
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "URPlayer.h"
#import "URConstants.h"

@interface URPlayer ()

@property (strong, nonatomic) MCPeerID *peerID;

@end

@implementation URPlayer

#pragma mark - Init Methods

- (instancetype)initWithPeerID:(MCPeerID *)peerID
{
    self = [super init];
    if (self) {
        self.peerID = peerID;
        self.undercover = NO;
    }
    return self;
}

@end
