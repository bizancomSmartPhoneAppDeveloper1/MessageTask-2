//
//  ViewController.h
//  ring
//
//  Created by bizan.com.mac12 on 2014/05/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController < MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, NSStreamDelegate,MCBrowserViewControllerDelegate >
{
    MCPeerID *myPeerID;
    NSString *serviceType;
    NSTimer *time;
    MCSession *session;
}

@property (strong, nonatomic) MCPeerID *myPeerID;
@property (strong, nonatomic) NSString *serviceType;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *nearbyServiceAdvertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *nearbyServiceBrowser;
@property (strong, nonatomic) MCSession *session;
@property id stepDelegate;
@property (assign,nonatomic)id<UIPageViewControllerDelegate>delegate;




@property (weak, nonatomic) IBOutlet UIImageView *startView;


- (IBAction)connect:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *myself;
@property (weak, nonatomic) IBOutlet UILabel *companion;
@property (weak, nonatomic) IBOutlet UILabel *companion1;
@property (weak, nonatomic) IBOutlet UILabel *companion2;
@property (weak, nonatomic) IBOutlet UILabel *companion3;





//-----------------------------------------------------






/*

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error;


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;


- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID;



- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error;


- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler;



- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;


- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress;


- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error;

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID;


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;


- (BOOL)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler;
*/

@end
