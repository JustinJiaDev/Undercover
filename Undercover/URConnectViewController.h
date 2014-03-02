//
//  URConnectViewController.h
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "URPlayer.h"
#import "URConstants.h"

@class URConnectViewController;

@protocol URConnectViewControllerDelegate <NSObject>

@required - (void)connectViewControllerDidFinish:(URConnectViewController *)connectViewController;

@end

@import MultipeerConnectivity;

@interface URConnectViewController : UIViewController <MCSessionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic, readonly) MCSession *session;
@property (strong, nonatomic, readonly) MCPeerID *peerID;

@property (weak, nonatomic) id <URConnectViewControllerDelegate> delegate;

- (IBAction)exitButtonTapped:(id)sender;

@end
