//
//  URPlayer.h
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

@import MultipeerConnectivity;

@interface URPlayer : NSObject

@property (strong, nonatomic, readonly) MCPeerID *peerID;
@property (nonatomic, getter = isUndercover) BOOL undercover;

- (instancetype)initWithPeerID:(MCPeerID *)peerID;

@end
