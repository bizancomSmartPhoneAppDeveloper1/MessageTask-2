//
//  ViewController.m
//  ring
//
//  Created by bizan.com.mac12 on 2014/05/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//
#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    MCBrowserViewController *_browserViewController;
    
}

@end
@implementation ViewController


@synthesize myPeerID;
@synthesize serviceType;
@synthesize nearbyServiceAdvertiser;
@synthesize nearbyServiceBrowser;
@synthesize session;

@synthesize myself;
@synthesize companion;


- (BOOL)isPhone
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //タイトル（tano）
    //5/20   time = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(task) userInfo:nil repeats:YES];
    
    //起動と同時にNSUUIDでuuid作成
    NSUUID *uuid = [NSUUID UUID];
    //MCPeerID は，デバイス毎に一意です、myPeerIDに入れる
    myPeerID = [[MCPeerID alloc] initWithDisplayName:[uuid UUIDString]];
    //任意の NSStringクラスの namePeerIDクラスの中にmyPeerIDのdisplayNameプロパティを入れる
    NSString *namePeerID = myPeerID.displayName;
    //namePeerIDの中身をNSLogをつかって表示
    NSLog(@"[peerID.displayName] %@", namePeerID);
    
    if([self isPhone]){
        myself.text = myPeerID.displayName;
    }else{
        myself.text = myPeerID.displayName;
    }
    //任意の NSString で serviceType を作成します
    serviceType = @"p2ptest";//自分のアプリ名（定数にして方がいい。）
    
    session = [[MCSession alloc] initWithPeer:myPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    session.delegate = self;
    
    nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:myPeerID serviceType:serviceType];
    nearbyServiceBrowser.delegate = self;
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



/*--------下記に変更ーーーーーーーーーーーーーーーーーーーーーーーーーーーー
 
 - (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
 {
 // BLog();
 NSLog(@"found Peer : %@", peerID.displayName);
 [self showAlert:@"found Peer" message:peerID.displayName];
 if([self isPhone]){
 _companion.text = peerID.displayName;
 }else{
 _companion.text = peerID.displayName;
 }
 [nearbyServiceBrowser invitePeer:peerID toSession:session withContext:[@"Welcome" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
 }
 ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー*/
// 接続要求が来たとき
- (void)advertiserAssitantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant;
{
    NSLog(@"-advertiserAssitantWillPresentInvitation:%@", advertiserAssistant);
}

// 接続要求が完了した
- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant;
{
    NSLog(@"-advertiserAssistantDidDismissInvitation:%@", advertiserAssistant);
}


// 接続相手の状態が変わったとき
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;
{
    NSLog(@"-session:peer: %@ didChangeState: %@", peerID.displayName, (state == 0 ? @"NotConnected" : (state == 1 ? @"Connecting" : @"Connected")));
    switch (state) {
        case MCSessionStateNotConnected:// 切断した
            NSLog(@"111111111111111111111111111111111111111111111111");
            break;
        case MCSessionStateConnecting:		// 接続中
            break;
        case MCSessionStateConnected:		// 接続できた
            break;
        default:
            break;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
{
    NSLog(@"-session: didReceiveData: fromPeer:%@", peerID.displayName);
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
}
// 相手からストリームデータを受けた
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID;
{
    NSLog(@"-session: didReceiveStream: withName:%@ fromPeer:%@", streamName, peerID.displayName);
    // Stream をdelegateで処理するように設定
    [stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    stream.delegate = self;
    [stream open];
}
// リソースの受信が始まった
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress;
{
    NSLog(@"-session: didStartReceivingResourceWithName:%@ fromPeer:%@ withProgress:", resourceName, peerID.displayName);
    // progress に進捗が入る
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}

// リソースの受信を完了した
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error;
{
    NSLog(@"-session: didFinishReceivingResourceWithName:%@ fromPeer:%@ atURL: withError:", resourceName, peerID.displayName);
    // localURLにファイルがある
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}
// 接続先の証明書を確認して接続可否を判断する-(void)か(bool)・・・５/２２「bool」

- (BOOL)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler;
{
    NSLog(@"-session: didReceiveCertificate:%@ fromPeer:%@ certificateHandler:", certificate, peerID.displayName);
    certificateHandler(YES);
    
    return YES;
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

/*
 
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
 
 */

// Multipeer Connectivityで接続先を見つけるUIを表示する
- (IBAction)connect:(UIButton *)sender;
{
    NSLog(@"-connectAction:");
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _browserViewController = [[MCBrowserViewController alloc] initWithServiceType:appDelegate.serviceType session:appDelegate.session];
	_browserViewController.delegate = self;
    _browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers;
    _browserViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers;
    [self presentViewController:_browserViewController animated:YES completion:NULL];
    
    NSLog(@"kokohatottayo-------------------");
}
//キャンセルでviewを隠す
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [_browserViewController dismissViewControllerAnimated:YES completion:NULL];
}
//完了でviewをかくす
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController;
{
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}
// デバイスの表示可否
- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;
{
    NSLog(@"browserViewController:%@ shouldPresentNearbyPeer:%@ withDiscoveryInfo:%@", browserViewController, peerID, info);
    NSString *version = [info objectForKey:@"version"];
    if ([@"1.0" isEqualToString:version]) {
        return YES;
    };
    return NO;
}
// 辞書データを送る
-(BOOL)sendDictionary:(NSDictionary*)dic;
{
    NSLog(@"-sendDictionary: %@", dic);
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //辞書を訂正する為にMutableにする
    NSMutableDictionary *muteDic = [dic mutableCopy];
    //送信元デバイス名を追加
    [muteDic setObject:appDelegate.session.myPeerID.displayName forKey:@"peerName"];
    //UIColorはjson化出来ないので色コードを書く
    UIColor *color = [muteDic objectForKey:@"color"];
    if (color) {
        [muteDic removeObjectForKey:@"color"];
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        [muteDic setObject:[NSNumber numberWithFloat:red] forKey:@"R"];
        [muteDic setObject:[NSNumber numberWithFloat:green] forKey:@"G"];
        [muteDic setObject:[NSNumber numberWithFloat:blue] forKey:@"B"];
        [muteDic setObject:[NSNumber numberWithFloat:alpha] forKey:@"A"];
    }
    if([NSJSONSerialization isValidJSONObject:muteDic]){
        // 辞書をJSONデータに変換
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:muteDic options:NSJSONWritingPrettyPrinted error:&error];
        
        [appDelegate.session sendData:data toPeers:appDelegate.session.connectedPeers
                             withMode:NULL error:&error];
        
    }else{
        NSLog(@"non valid data: %@", dic);
        
    }
    return NO;
    
    // 画面に表示
    /*    dispatch_async(dispatch_get_main_queue(), ^{
     [self.myView addDictionary:dic];
     });
     }
     */
}

/*
 
 - (IBAction)btnStartAdvertisingIPHONE:(id)sender {
 // BLog();
 //[self showAlert:@"iPhone" message:@"startAdvertisingPeer"];
 [self startAdvertising];
 }
 
 
 - (IBAction)btnStopAdvertisingIPHONE:(id)sender {
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
 */

@end
