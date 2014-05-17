//
//  ReminderViewController.m
//  MessageTask
//
//  Created by bizan.com.mac04 on 2014/05/17.
//  Copyright (c) 2014年 com.bizan.kunren1. All rights reserved.
//

#import "ReminderViewController.h"

@interface ReminderViewController ()
{
    UILabel *myLabel;
    EKEventStore *event;
    UIView *view;
    
}
@end

@implementation ReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)shouldAutorotate//i phone横に倒しても回転しないように
{
    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //----------------------初期化
    event = [[EKEventStore alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)lookRemainder
{
    //----------------アクセス許可についてのステータスを取得する
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    
    if (status ==  EKAuthorizationStatusNotDetermined)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"プライパシー状態"
                                                       message:@"ユーザーにまだアクセス許可を求めていない"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    //-----------------iPhone「機能制限」アクセス制限している
    else if (status == EKAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"プライパシー状態"
                                                       message:@"iPhoneの設定「機能制限」でリマインダーへアクセス制限している" delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    //---------------リマインダーへのアクセスをユーザーから拒否されてる
    else if (status == EKAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"プライパシー状態"
                                                       message:@"リマインダーへのアクセスをユーザーから拒否されている"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    //-------------リマインダーへのアクセス許可されてる
    else if (status ==EKAuthorizationStatusAuthorized)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"プライパシー状態"
                                                       message:@"リマインダーへのアクセスをユーザが許可してる"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        [self somethingReminder];
    }
}

//リマインダー操作
-(void)somethingReminder
{
    NSArray *lists = [event calendarsForEntityType:EKEntityTypeReminder];
    UILabel *label = [[UILabel alloc] init];
    
    
    NSDate *startDate = [NSDate distantPast];
    NSDate *endDate   = [NSDate distantFuture];
    
    NSPredicate *predicate = [event predicateForIncompleteRemindersWithDueDateStarting:startDate ending:endDate calendars:nil];
    
    [event fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         for(EKReminder *e in reminders)
         {
             NSLog(@"title=%@", e.title);
             NSLog(@"sample=%@", e.dueDateComponents);
             
         }
         
     }];
    
    [self.view addSubview:label];
    
}

- (IBAction)newButton:(UIButton *)sender
{
    [self lookRemainder];
}

- (IBAction)gobackButton:(UIButton *)sender
{

}
@end
