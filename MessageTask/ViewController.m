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

/*
@synthesize myPeerID;
@synthesize serviceType;
@synthesize nearbyServiceAdvertiser;
@synthesize nearbyServiceBrowser;
@synthesize session;

@synthesize myself;
@synthesize companion;
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //固定
    _myself.text = [UIDevice currentDevice].name;
//    NSLog(@"---------------%@",[UIDevice currentDevice].name);
 //   _companion.text = [didReceiveData: fromPeer:];
 //   NSLog(@"==========%@",streamName);

/*    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.stepDelegate = self;
*/    
    
        //return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone);
    }


-(BOOL)shouldAutorotate
    {
        return YES;
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
//        NSLog(@"[error localizedDescription] %@", [error localizedDescription]);
    }
    
}




 //多分これは重要！！！後で解読せよ！！
 - (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
 {
//     NSLog(@"found Peer : %@", peerID.displayName);
// [self showAlert:@"found Peer" message:peerID.displayName];
// if([self isPhone]){
// _companion.text = peerID.displayName;
// }else{
// _companion.text = peerID.displayName;
// }
// [nearbyServiceBrowser invitePeer:peerID toSession:session withContext:[@"Welcome" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
 }


- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    if(error){
//        NSLog(@"%@", [error localizedDescription]);
        [self showAlert:@"ERROR didNotStartAdvertisingPeer" message:[error localizedDescription]];
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{
    
    invitationHandler(TRUE, self.session);
    [self showAlert:@"didReceiveInvitationFromPeer" message:@"accept invitation!"];
}


// Multipeer Connectivityで接続先を見つけるUIを表示する
- (IBAction)connect:(UIButton *)sender;
{
//    NSLog(@"-connectAction:");
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _browserViewController = [[MCBrowserViewController alloc] initWithServiceType:appDelegate.serviceType session:appDelegate.session];
	_browserViewController.delegate = self;
    _browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers;
    _browserViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers;
    [self presentViewController:_browserViewController animated:YES completion:NULL];
    
//    NSLog(@"kokohatottayo-------------------");

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
//    NSLog(@"browserViewController:%@ shouldPresentNearbyPeer:%@ withDiscoveryInfo:%@", browserViewController, peerID, info);
    NSString *version = [info objectForKey:@"version"];
    if ([@"1.0" isEqualToString:version]) {
        return YES;
    };
    return NO;
}
// 辞書データを送る
-(void)sendDictionary:(NSDictionary*)dic;
{
//    NSLog(@"-sendDictionary: %@", dic);
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
        //データ送信
        [appDelegate.session sendData:data toPeers:appDelegate.session.connectedPeers
                             withMode:NULL error:&error];
        
    }else{
//        NSLog(@"***non valid data***: %@", dic);
        
    }
    
    /*
    // 画面に表示
        dispatch_async(dispatch_get_main_queue(), ^{
     [self.myView addDictionary:dic];
     });
     }
*/
}


@end
