//
//  ViewController.m
//  ring
//
//  Created by bizan.com.mac12 on 2014/05/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
@implementation ViewController
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    MCSession *session = [[MCSession alloc]initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    session.delegate = self;
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"test-service" discoveryInfo:nil session:session];
    self.assistant.delegate = self;
    [self.assistant start];
	    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)botton:(UIButton *)sender {
    MCBrowserViewController *browseViewController = [[MCBrowserViewController alloc] initWithServiceType:@"test-service" session:self.assistant.session];
    browseViewController.delegate = self;
    browseViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers;
    browseViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers;
    [self presentViewController:browseViewController animated:YES completion:NULL];

}
- (void)advertiserAssitantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant;{
    //接続要求きた
    NSLog(@"kita");
}
#pragma mark - MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController;{
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController;{
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}
- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;{
    return YES;
}
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;{
    
}
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
}
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler;{
    
}
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;{
    //ピアの接続状態が変化するとMCSessionのデリゲートメッソドが呼ばれる
    NSLog(@"jiji");
}


//送信

@end
