//
//  URAgentViewController.m
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "URAgentViewController.h"

@interface URAgentViewController ()

@property (strong, nonatomic) MCBrowserViewController *browserViewController;

@end

@implementation URAgentViewController

#pragma mark - View Controller Methods
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.session.connectedPeers.count) {
        [self presentViewController:self.browserViewController animated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.session disconnect];
}

#pragma mark - Browser View Controller Delegate Methods
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter & Getter Methods
- (MCBrowserViewController *)browserViewController
{
    if (!_browserViewController) {
        _browserViewController = [[MCBrowserViewController alloc] initWithBrowser:[[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID serviceType:undercoverServiceType] session:self.session];
        _browserViewController.delegate = self;
    }
    
    return _browserViewController;
}

@end
