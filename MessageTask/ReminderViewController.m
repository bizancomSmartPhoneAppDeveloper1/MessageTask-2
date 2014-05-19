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
    
    //アクセス許可を求めていない場合
    if (status ==  EKAuthorizationStatusNotDetermined)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"プライパシー状態"
                                                       message:@"ユーザーにまだアクセス許可を求めていない"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        [self showRemin];
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

-(void)showRemin
{
    //アクセス許可についてのステータスを取得する
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    
    //EKAuthorizationStatusの値に応じて処理する
    switch (status)
    {
        case EKAuthorizationStatusAuthorized:       //アクセスをユーザーが許可している場合
        {
            
        }
            break;
        case EKAuthorizationStatusNotDetermined:    //まだユーザにアクセス許可のアラートを出していない状態
        {
            // 「このアプリがリマインダーへのアクセスを求めています」といったアラートが表示される
            [event requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
             {
 //                __weak id weakSelf = self;
                 if (granted) {
                     // ユーザーがアクセスを許可した場合
                     //メインスレッドを止めないためにdispatch_asyncを使って処理をバックグラウンドで行う
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // 許可されたら、EKEntityTypeReminderへのアクセスを行う
            
                     });
                 } else {
                     // ユーザーがアクセス拒否した場合
                     // UIAlertViewの表示をメインスレッドで行う
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [[[UIAlertView alloc] initWithTitle:@"確認"
                                                     message:@"このアプリのリマインダーへのアクセスを許可するには、プライバシーから設定する必要があります。"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil]
                          show];
                     });
                 }
             }];
            
        }
            break;
        case EKAuthorizationStatusDenied:           //アクセスをユーザーから拒否されている場合
        case EKAuthorizationStatusRestricted:       //iPhoneの設定の「機能制限」でマインダーへのアクセスを制限している場合
        {
            //アラートを表示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                            message:@"リマインダーへのアクセスが許可されていません。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
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
    NSMutableArray *labels = [[NSMutableArray alloc]init];//配列にいれている『labels』

    
    [event fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         int i = 0;
         for(EKReminder *e in reminders)
         {
             NSLog(@"title=%@", e.title);
             NSLog(@"sample=%@", e.dueDateComponents);
             
             NSLog(@"title=%@", e.title);
             NSLog(@"sample=%@", e.dueDateComponents);
             //             NSLog(@"%@",e.location);
             NSLog(@"%@",e.notes);
             
             NSLog(@"event: %@, %@,in %@",e.startDateComponents,e.title,e.calendar.title);
             
             NSString *titles = [NSString stringWithFormat:@"%@ \n",e.title];
             NSString *noto = [NSString stringWithFormat:@"%@ \n",e.notes];
             
             
             
             
             
             UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50 , 100*i, 50, 30)];//１番目
             //UILabel *label = [[UILabel al]]
             UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(100,100*i,200,30)];//1番目は（画面位置の横幅）,2番目は（高さ）,３番目は（）,４番目は（）
             label.textColor = [UIColor blackColor];
             label.font = [UIFont systemFontOfSize:12];
             label.numberOfLines = 0;
             label.adjustsFontSizeToFitWidth = YES;
             
             label2.textColor = [UIColor blackColor];
             label2.font = [UIFont systemFontOfSize:15];
             label2.numberOfLines = 0;
             label2.adjustsFontSizeToFitWidth = YES;
             
             label.text = [NSString stringWithFormat:@"%@\n",titles];//@"%@",titles;
             label2.text = [NSString stringWithFormat:@" \n %@\n",noto];
             NSLog(@"noto=%@",noto);
             
             [self.view addSubview:label];
             [self.view addSubview:label2];
             [labels addObject:label];
             i++;
         }
         
         EKEventViewController *datailViewController =[[EKEventViewController alloc]initWithNibName:nil bundle:nil];
         //         datailViewController.event = [event objectAtindex:0];
         [self.navigationController pushViewController:datailViewController animated:YES];
         [datailViewController reloadInputViews];
  
         
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
