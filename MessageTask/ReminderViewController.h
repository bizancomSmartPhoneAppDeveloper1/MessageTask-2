//
//  ReminderViewController.h
//  MessageTask
//
//  Created by bizan.com.mac04 on 2014/05/17.
//  Copyright (c) 2014年 com.bizan.kunren1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>




@interface ReminderViewController : UIViewController
@property (nonatomic,strong)EKReminder *rimainder;

- (IBAction)newButton:(UIButton *)sender;
- (IBAction)gobackButton:(UIButton *)sender;



@end


