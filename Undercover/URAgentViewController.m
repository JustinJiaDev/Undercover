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
@property (nonatomic, getter = hasPresentedBrowserViewController) BOOL presentedBrowserViewController;

@end

@implementation URAgentViewController

#pragma mark - View Controller Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.presentedBrowserViewController = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.session.connectedPeers.count && !self.hasPresentedBrowserViewController) {
        [self presentViewController:self.browserViewController animated:YES completion:^{
            self.presentedBrowserViewController = YES;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.session disconnect];
}

#pragma mark - Connect View Controller Methods
- (void)deadButtonTapped:(id)sender
{
    [super deadButtonTapped:sender];
    
    [self.session sendData:[deadMessage dataUsingEncoding:NSUTF8StringEncoding] toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
}

#pragma mark - Browser View Controller Delegate Methods
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate connectViewControllerDidFinish:self];
    }];
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
