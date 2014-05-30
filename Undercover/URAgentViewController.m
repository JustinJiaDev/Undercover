//
//  URAgentViewController.m
//
//  Copyright (C) 2014 by Bowei Jia (Justin).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
