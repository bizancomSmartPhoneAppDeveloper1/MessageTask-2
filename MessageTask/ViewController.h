//
//  ViewController.h
//  ring
//
//  Created by bizan.com.mac12 on 2014/05/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController : UIViewController <MCAdvertiserAssistantDelegate,MCSessionDelegate,MCNearbyServiceAdvertiserDelegate,MCNearbyServiceBrowserDelegate,MCBrowserViewControllerDelegate>
@property MCAdvertiserAssistant *assistant;
- (IBAction)botton:(UIButton *)sender;
    






@end
