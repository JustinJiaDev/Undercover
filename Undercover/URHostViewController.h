//
//  URRoomViewController.h
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "URConnectViewController.h"

@import MultipeerConnectivity;

@interface URHostViewController : URConnectViewController <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

- (IBAction)startButtonTapped:(id)sender;

@end