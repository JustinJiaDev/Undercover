//
//  URConnectViewController.m
//  Undercover
//
//  Created by Justin Jia on 3/1/14.
//  Copyright (c) 2014 Jacinth. All rights reserved.
//

#import "URConnectViewController.h"

@interface URConnectViewController ()

@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCPeerID *peerID;

@end

@implementation URConnectViewController

#pragma mark - Session Delegate Methods

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString *recievedMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (![recievedMessage isEqualToString:deadMessage]) {
            self.label.text = recievedMessage;
        } else {
            [self peerDeadMessageRecieved:peerID];
        }
    });
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID { }

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress { }

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error { }

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state { }

#pragma mark - View Methods

- (void)exitButtonTapped:(id)sender
{
    [self.delegate connectViewControllerDidFinish:self];
}

- (void)deadButtonTapped:(id)sender { }

- (void)peerDeadMessageRecieved:(MCPeerID *)peerID { }

#pragma mark - Status Bar Methods

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Setter & Getter Methods

- (MCSession *)session
{
    if (!_session) {
        _session = [[MCSession alloc] initWithPeer:self.peerID];
        _session.delegate = self;
    }
    
    return _session;
}

- (MCPeerID *)peerID
{
    if (!_peerID) {
        _peerID = [[MCPeerID alloc] initWithDisplayName:[[NSUserDefaults standardUserDefaults] objectForKey:nameKey] ?: [UIDevice currentDevice].name];
    }
    
    return _peerID;
}

@end
