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




@interface ReminderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EKEventEditViewDelegate>
{
    NSArray *data1;
    NSArray *data2;
}


@property (nonatomic,strong)EKReminder *rimainder;
@property (retain,nonatomic)NSMutableArray *item;

@property (weak, nonatomic) IBOutlet UILabel *_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *_notoLabel;




- (IBAction)newButton:(UIButton *)sender;
- (IBAction)gobackButton:(UIButton *)sender;

-(IBAction)rimainder:(id)sender;

@end


