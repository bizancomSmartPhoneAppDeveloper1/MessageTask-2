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
 

@synthesize myPeerID;
@synthesize serviceType;
@synthesize nearbyServiceAdvertiser;
@synthesize nearbyServiceBrowser;
@synthesize session;

@synthesize labelMyPeerIDIPHONE;
@synthesize labelYourPeerIDIPHONE;
@synthesize labelYourPeerIDIPAD;

- (BOOL)isPhone
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //起動と同時にNSUUIDでuuid作成
    NSUUID *uuid = [NSUUID UUID];
    //MCPeerID は，デバイス毎に一意です、myPeerIDに入れる
    myPeerID = [[MCPeerID alloc] initWithDisplayName:[uuid UUIDString]];
    //任意の NSStringクラスの namePeerIDクラスの中にmyPeerIDのdisplayNameプロパティを入れる
    NSString *namePeerID = myPeerID.displayName;
    //namePeerIDの中身をNSLogをつかって表示
    NSLog(@"[peerID.displayName] %@", namePeerID);
    
    if([self isPhone]){
        labelMyPeerIDIPHONE.text = myPeerID.displayName;
    }else{
        self.labelMyPeerIDIPAD.text = myPeerID.displayName;
    }
    //任意の NSString で serviceType を作成します
    serviceType = @"p2ptest";
    
    nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:myPeerID serviceType:serviceType];
    nearbyServiceBrowser.delegate = self;
    
    session = [[MCSession alloc] initWithPeer:myPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    session.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}





- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
  // BLog();
    if(error){
        NSLog(@"[error localizedDescription] %@", [error localizedDescription]);
    }
    
}


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    // BLog();
    NSLog(@"found Peer : %@", peerID.displayName);
    [self showAlert:@"found Peer" message:peerID.displayName];
    if([self isPhone]){
        labelYourPeerIDIPHONE.text = peerID.displayName;
    }else{
        labelYourPeerIDIPAD.text = peerID.displayName;
    }
    [nearbyServiceBrowser invitePeer:peerID toSession:session withContext:[@"Welcome" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
}


- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    // BLog();
}



- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    // BLog();
    if(error){
        NSLog(@"%@", [error localizedDescription]);
        [self showAlert:@"ERROR didNotStartAdvertisingPeer" message:[error localizedDescription]];
    }
}


- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{
    // BLog();
    invitationHandler(TRUE, self.session);
    [self showAlert:@"didReceiveInvitationFromPeer" message:@"accept invitation!"];
}



- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    // BLog();
    NSString *receivedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showAlert:@"didReceiveData" message:receivedData];
}


- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    // BLog();
}


- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    // BLog();
}


- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    // BLog();
}


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    // BLog();
    NSLog(@"[peerID] %@", peerID);
    NSLog(@"[state] %d", state);
   
    
    if(state == MCSessionStateConnected && self.session){
        NSLog(@"session sends data!");
        NSError *error;
        NSString *message = [NSString stringWithFormat:@"message from %@", myPeerID.displayName];
        [self.session sendData:[message dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataReliable error:&error];
        //[self showAlert:@"Send data" message:@"hello"];
    }
}


- (BOOL)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    // BLog();
    certificateHandler(TRUE);
    return TRUE;
}
- (void)startAdvertising
{
    NSDictionary *discoveryInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"foo", @"bar", @"bar", @"foo", nil];
    nearbyServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:myPeerID discoveryInfo:discoveryInfo serviceType:serviceType];
    nearbyServiceAdvertiser.delegate = self;
    [nearbyServiceAdvertiser startAdvertisingPeer];
}

- (IBAction)btnStartAdvertisingIPHONE:(id)sender {
    // BLog();
    //[self showAlert:@"iPhone" message:@"startAdvertisingPeer"];
    [self startAdvertising];
}

- (IBAction)btnStartAdvertisingIPAD:(id)sender {
    // BLog();
   
    [self startAdvertising];
}

- (IBAction)btnStopAdvertisingIPHONE:(id)sender {
    // BLog();
    
    [nearbyServiceAdvertiser stopAdvertisingPeer];
}

- (IBAction)btnStopAdvertisingIPAD:(id)sender {
    // BLog();
    
    [nearbyServiceAdvertiser stopAdvertisingPeer];
}



- (IBAction)btnStartBrowsingIPHONE:(id)sender {
    // BLog();
    
    [nearbyServiceBrowser startBrowsingForPeers];
}

- (IBAction)btnStopBrowsingIPHONE:(id)sender {
    // BLog();
   
    [nearbyServiceBrowser stopBrowsingForPeers];
}

- (IBAction)btnStartBrowsingIPAD:(id)sender {
    // BLog();
    
    [nearbyServiceBrowser startBrowsingForPeers];
}

- (IBAction)btnStopBrowsingIPAD:(id)sender {
    // BLog();
   
    [nearbyServiceBrowser stopBrowsingForPeers];
}
@end
