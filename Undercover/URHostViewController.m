//
//  URHostViewController.m
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

#import "URHostViewController.h"

#define IS_UNDERCOVER_STRING NSLocalizedString(@"You are the undercover!", @"Display this message after user tapped \"I am Dead\".")
#define IS_NOT_UNDERCOVER_STRING NSLocalizedString(@"You are the good guy!", @"Display this message after user tapped \"I am Dead\".")

static NSString * const normalWordKey = @"normal-word";
static NSString * const undercoverWordKey = @"undercover-word";
static NSString * const WordsDictionaryFilename = @"WordsDictionary";
static NSString * const WordsDictionaryExtension = @"plist";

static NSString * const firstUnplayedWordIndexKey = @"first-unplayed-word-index-key";

@interface URHostViewController ()

@property (strong, nonatomic) NSArray *wordsDictionary;
@property (strong, nonatomic) NSMutableArray *allPlayers;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *advertiser;

@end

@implementation URHostViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.allPlayers addObject:[[URPlayer alloc] initWithPeerID:self.peerID]];
    
    [self.advertiser startAdvertisingPeer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.advertiser stopAdvertisingPeer];
    [self.session disconnect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.wordsDictionary = nil;
}

#pragma mark Connect View Controller Methods

- (void)deadButtonTapped:(id)sender
{
    [super deadButtonTapped:sender];
    
    [self.allPlayers enumerateObjectsUsingBlock:^(URPlayer *player, NSUInteger idx, BOOL *stop) {
        if ([player.peerID isEqual:self.peerID]) {
            self.label.text = player.isUndercover ? IS_UNDERCOVER_STRING : IS_NOT_UNDERCOVER_STRING;
            
            *stop = YES;
        }
    }];
}

- (void)peerDeadMessageRecieved:(MCPeerID *)peerID
{
    [self.allPlayers enumerateObjectsUsingBlock:^(URPlayer *player, NSUInteger idx, BOOL *stop) {
        if ([player.peerID isEqual:peerID]) {
            [self.session sendData:[player.isUndercover ? IS_UNDERCOVER_STRING : IS_NOT_UNDERCOVER_STRING dataUsingEncoding:NSUTF8StringEncoding] toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
            
            *stop = YES;
        }
    }];
}

#pragma mark - View Methods

- (void)startButtonTapped:(id)sender
{
    //Init words.
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:firstUnplayedWordIndexKey];
    if (index >= self.wordsDictionary.count) {
        index = 0;
    }
    
    NSDictionary *words = self.wordsDictionary[index];
    NSString *word = words[normalWordKey];
    NSString *undercoverWord = words[undercoverWordKey];
    
    //Clean up.
    for (URPlayer *player in self.allPlayers) {
        player.undercover = NO;
    }

    //Randomly generate the undercover.
    URPlayer *undercoverPlayer = (URPlayer *)self.allPlayers[arc4random() % self.allPlayers.count];
    undercoverPlayer.undercover = YES;
    
    //find all peers.
    NSMutableArray *connectedNormalPeers = [NSMutableArray arrayWithArray:self.session.connectedPeers];
    NSMutableArray *connectedUndercoverPeers = [NSMutableArray array];
    for (MCPeerID *peerID in self.session.connectedPeers) {
        if ([peerID isEqual:undercoverPlayer.peerID]) {
            [connectedNormalPeers removeObject:peerID];
            [connectedUndercoverPeers addObject:peerID];
        }
    }
    
    //Send generate words to peers.
    [self.session sendData:[word dataUsingEncoding:NSUTF8StringEncoding] toPeers:connectedNormalPeers withMode:MCSessionSendDataReliable error:nil];
    [self.session sendData:[undercoverWord dataUsingEncoding:NSUTF8StringEncoding] toPeers:@[undercoverPlayer.peerID] withMode:MCSessionSendDataReliable error:nil];
    
    //Update host's words.
    [self.allPlayers enumerateObjectsUsingBlock:^(URPlayer *player, NSUInteger idx, BOOL *stop) {
        if ([player.peerID isEqual:self.peerID]) {
            self.label.text = player.isUndercover ? undercoverWord : word;
            *stop = YES;
        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setInteger:index + 1 forKey:firstUnplayedWordIndexKey];
}

#pragma mark - Nearby Service Advertiser Delegate Methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    invitationHandler(YES, self.session);
    
    [self.allPlayers addObject:[[URPlayer alloc] initWithPeerID:peerID]];
}

#pragma mark - Setter & Getter Methods

-(NSArray *)wordsDictionary
{
    if (!_wordsDictionary) {
        _wordsDictionary = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:WordsDictionaryFilename withExtension:WordsDictionaryExtension]];
    }
    
    return _wordsDictionary;
}

- (NSMutableArray *)allPlayers
{
    if (!_allPlayers) {
        _allPlayers = [NSMutableArray array];
    }
    
    return _allPlayers;
}

- (MCNearbyServiceAdvertiser *)advertiser
{
    if (!_advertiser) {
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID discoveryInfo:nil serviceType:undercoverServiceType];
        _advertiser.delegate = self;
    }
    
    return _advertiser;
}

@end
