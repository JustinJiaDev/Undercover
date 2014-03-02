//
//  URConnectViewController.h
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "URPlayer.h"
#import "URConstants.h"

@import MultipeerConnectivity;

@interface URConnectViewController : UIViewController <MCSessionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic, readonly) MCSession *session;
@property (strong, nonatomic, readonly) MCPeerID *peerID;

@end
