//
//  AppDelegate.m
//  ring
//
//  Created by bizan.com.mac12 on 2014/05/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "AppDelegate.h"
@import CoreMotion;

@interface AppDelegate() <MCAdvertiserAssistantDelegate, MCSessionDelegate, NSStreamDelegate>
@property MCAdvertiserAssistant *assistant;
@end

@implementation AppDelegate
// アプリ起動→初期化
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    
    // Multipeer Connectivityの初期化→サービス提供
    self.serviceType = SERVICE_TYPE;
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    MCSession *session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionOptional];
    session.delegate = self;
    self.session = session;
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:10];
    [info setObject:@"1.0" forKey:@"version"];
    MCAdvertiserAssistant *assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:self.serviceType discoveryInfo:info session:session];
    assistant.delegate = self;
    [assistant start];
    self.assistant = assistant;
    
    return YES;
    
    
}

//// 非アクティブ化
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
//}
//
//// バックグラウンドに入った
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
//}
//
//// フォアグラウンドに復帰した
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
//}
//
//// アクティブになった
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
//}

#pragma mark - MCAdvertiserAssistantDelegate
// 接続要求が来た
- (void)advertiserAssitantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant;
{
    NSLog(@"-advertiserAssitantWillPresentInvitation:%@", advertiserAssistant);
}

// 接続要求が完了した
- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant;
{
    NSLog(@"-advertiserAssistantDidDismissInvitation:%@", advertiserAssistant);
}

#pragma mark - MCSessionDelegate
// 接続相手の状態が変わった
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;
{
    NSLog(@"-session:peer: %@ didChangeState: %@", peerID.displayName, (state == 0 ? @"NotConnected" : (state == 1 ? @"Connecting" : @"Connected")));
    switch (state) {
        case MCSessionStateNotConnected:	// 切断した
            break;
        case MCSessionStateConnecting:		// 接続中
            break;
        case MCSessionStateConnected:		// 接続できた
            break;
        default:
            break;
    }
}

// dataを受け取った
// サブスレッドで受けてる
// 送信元： - (BOOL)sendData:(NSData *)data toPeers:(NSArray *)peerIDs withMode:(MCSessionSendDataMode)mode error:(NSError **)error;
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
{
    NSLog(@"-session: didReceiveData: fromPeer:%@", peerID.displayName);
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (!error) {
        NSLog(@"data = %@", json);
        [self.stepDelegate recvDictionary:json];
    }
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

// 接続先の証明書を確認して接続可否を判断する
- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler;
{
    NSLog(@"-session: didReceiveCertificate:%@ fromPeer:%@ certificateHandler:", certificate, peerID.displayName);
    certificateHandler(YES);
}

#pragma mark - KVO
// KVOの通知を受ける
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    NSLog(@"%@ -observeValueForKeyPath:%@ ofObject:%@ change:%@ context:", NSStringFromClass(self.class), keyPath, object, change);
    if ([@"fractionCompleted" isEqualToString:keyPath]) {
        NSNumber *number = [change objectForKey:@"new"];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 進捗値を評価
            // number.doubleValue;
            NSLog(@"-> %@", number);
        });
    }
}

#pragma mark - NSStreamDelegate
// ストリームの状態が変化した
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;
{
    NSLog(@"-stream: handleEvent: %@%@%@%@%@%@",
          streamEvent & NSStreamEventNone ? @"NSStreamEventNone, " : @"",
          streamEvent & NSStreamEventOpenCompleted ? @"NSStreamEventOpenCompleted, " : @"",
          streamEvent & NSStreamEventHasBytesAvailable ? @"NSStreamEventHasBytesAvailable, " : @"",
          streamEvent & NSStreamEventHasSpaceAvailable ? @"NSStreamEventHasSpaceAvailable, " : @"",
          streamEvent & NSStreamEventErrorOccurred ? @"NSStreamEventErrorOccurred, " : @"",
          streamEvent & NSStreamEventEndEncountered ? @"NSStreamEventEndEncountered, " : @""
          );
    // データ受信
	if (streamEvent & NSStreamEventHasBytesAvailable) {
        int32_t steps;
        NSInputStream *input = (NSInputStream*)theStream;
        [input read:(uint8_t*)&steps maxLength:sizeof(int32_t)];
        // read
    }
    // 終了
    if (streamEvent & NSStreamEventEndEncountered) {
        [theStream close];
        [theStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

@end

