//
//  URConnectViewController.m
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
