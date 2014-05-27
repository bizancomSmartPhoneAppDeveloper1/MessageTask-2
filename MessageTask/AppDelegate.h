//
//  AppDelegate.h
//  ring
//
//  Created by bizan.com.mac12 on 2014/05/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ViewController.h"

@import MultipeerConnectivity;


#define SERVICE_TYPE @"MCStepper"

@protocol MultiPeerStepperDelegate<NSObject>
-(void)sendDictionary:(NSDictionary*)dic;
-(void)recvDictionary:(NSDictionary*)dic;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property MCSession *session;
@property NSString *serviceType;
@property id<MultiPeerStepperDelegate> stepDelegate;

@end
