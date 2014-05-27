//
//  ReminderViewController.m
//  MessageTask
//
//  Created by bizan.com.mac04 on 2014/05/17.
//  Copyright (c) 2014年 com.bizan.kunren1. All rights reserved.
//

#import "ReminderViewController.h"



@interface ReminderViewController ()



@end

@implementation ReminderViewController

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    //----------------------初期化

    event = [[EKEventStore alloc]init];
    
    //手直し必要！！！！！！！！！！！！
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:2013];
    [dateComponents setMonth:12];
    [dateComponents setDay:18];
    [dateComponents setHour:20];
    
    [self saveToRemider:@"test Title" saveTextNote:@"test本文の入力１" startDate:dateComponents dueDate:dateComponents];
}

//先読み
-(void)viewWillAppear:(BOOL)animated
{
    [self lookRemainder];
    
    [super viewWillAppear:animated];
    
    [self updateVisibleCells];

}

- (void)viewDidAppear:(BOOL)animated{
    
    [_reminderTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _item.count;//配列に入れてカウントさせてる
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"forIndexPath:indexPath];

//配列に入れたものを１行１行の書き出し・タイトル・メモ
    EKReminder *elements = [_item objectAtIndex:indexPath.row];
    NSString *titles = [NSString stringWithFormat:@"%@",elements.title];
    NSString *noto = [NSString stringWithFormat:@"%@",elements.notes];

//ラベルに書き出す（１・２）
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%@",titles];
         
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%@",noto];

    //セルにかえす
     return cell;
}



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

- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

//ここの中身をチエックした方が良い*******
-(void)saveToRemider:(NSString *)title saveTextNote:(NSString *)note startDate:(NSDateComponents *)startDate dueDate:(NSDateComponents *)dueDate {
    //イベントストアに接続ーーーーーリマインダーへ登録
    
    EKReminder *post = [EKReminder reminderWithEventStore:event];
    
    [event requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
     {
         calendar = [event defaultCalendarForNewReminders];
         
         
         post.title = title;
         
         post.notes = note;
         
         post.calendar = [event defaultCalendarForNewReminders];
         

     }];
    
    //開始時間、期限にぶち込む
    [post setStartDateComponents: startDate];
    [post setDueDateComponents:dueDate];
    
    NSCalendar *newCalendar = [NSCalendar currentCalendar];
    
    //Alarmを設定する。これをしていないと通知がこない。
    NSDate *alarmDate = [newCalendar dateFromComponents:startDate];
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:alarmDate];
    [post addAlarm:alarm];
    
//    NSError *error;
//    if(![event saveReminder:post commit:YES error:&error])
//        NSLog(@"%@", error);
}


-(void)lookRemainder
{
    //----------------アクセス許可についてのステータスを取得する
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];

    //アクセス許可を求めていない場合
    
    if (status == EKAuthorizationStatusNotDetermined)
        
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
    
    else if (status == EKAuthorizationStatusAuthorized)
    {
        //Mutable配列初期化
        _item = [NSMutableArray new];
        
        NSDate *startDate = [NSDate distantPast];
        
        NSDate *endDate   = [NSDate distantFuture];
        
        NSPredicate *predicate = [event predicateForIncompleteRemindersWithDueDateStarting:startDate ending:endDate calendars:nil];
        
        //手直し必要！！！！！！！！！！！！
  
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setYear:2013];
        [dateComponents setMonth:12];
        [dateComponents setDay:18];
        [dateComponents setHour:20];
  
        
        
        //取り出し-----------------------
        [event fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
         {
             _item = [reminders mutableCopy];
         }];
        
        [self saveToRemider:@"test Title" saveTextNote:@"test本文の入力１" startDate:dateComponents dueDate:dateComponents];

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

//テーブルビューの表示更新
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Update Cells
}
- (UITableViewCell *)reminderTableView:(UITableView *)reminderTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [reminderTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Update Cell
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Cell Operation
- (void)updateVisibleCells {
    // 見えているセルの表示更新
    for (UITableViewCell *cell in [self.reminderTableView visibleCells]){
        [self updateCell:cell atIndexPath:[self.reminderTableView indexPathForCell:cell]];
    }
}

//リマインダー操作
/*karidome 5/21
-(void)somethingReminder

{
    
    NSArray *lists = [event calendarsForEntityType:EKEntityTypeReminder];
    
    UILabel *label = [[UILabel alloc] init];
    
    NSDate *startDate = [NSDate distantPast];
    
    NSDate *endDate   = [NSDate distantFuture];
    
//--------------------週間---------------------------------------
    
    NSDateComponents *comps;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    comps = [calendar components:NSYearCalendarUnit|
             NSMonthCalendarUnit|
             NSDayCalendarUnit|
             NSWeekdayCalendarUnit fromDate:startDate];
    [comps setDay:1];
    
    NSDate *d = [calendar dateFromComponents:comps];
    comps = [calendar components:NSYearCalendarUnit|
             NSMonthCalendarUnit|
             NSDayCalendarUnit|
             NSWeekdayCalendarUnit
                        fromDate:d];
    
    int week_day = [comps weekday];

    
    
    
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
             
             // NSLog(@"%@",e.location);
             
             NSLog(@"%@",e.notes);
             
             
             
             NSLog(@"event: %@, %@,in %@",e.startDateComponents,e.title,e.calendar.title);
             
             
             
             NSString *titles = [NSString stringWithFormat:@"%@ \n",e.title];
             
             NSString *noto = [NSString stringWithFormat:@"%@ \n",e.notes];
             
  
             //ラベル生成　label
            
             UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50 , 30*i, 50, 30)];//１番目
             
             //UILabel *label = [[UILabel al]]
             
             //ラベル生成　labe2
             UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(100,50*i,200,30)];//1番目は（画面位置の横幅）,2番目は（高さ）,３番目は（）,４番目は（）
             //「label（コードで作成）」から「_titleLabel（プロパティある方）」へ
             
             label.textColor = [UIColor blackColor];
             
             label.font = [UIFont systemFontOfSize:12];
             
             label.numberOfLines = 0;
             
             label.adjustsFontSizeToFitWidth = YES;
             
            //「　label2（コードで作成）　」から「　_notoLabel（プロパティある方）　」へ
             
             label2.textColor = [UIColor blackColor];
             
             label2.font = [UIFont systemFontOfSize:15];
             
             label2.numberOfLines = 0;
             
             label2.adjustsFontSizeToFitWidth = YES;
             
             
             //_titleLabel 5/21
             label.text = [NSString stringWithFormat:@"%@\n",titles];//@"%@",titles;
             
             //_notoLabel 5/21
             label2.text = [NSString stringWithFormat:@" \n %@\n",noto];
             
             NSLog(@"noto=%@",noto);
             
             
             
             [self.view addSubview:label];
// 5/21            [self.view addSubview:_titleLabel];
             
             [self.view addSubview:label2];
//5/21             [self.view addSubview:_notoLabel];
             
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
*/

- (IBAction)newButton:(UIButton *)sender
{
    
}

- (IBAction)gobackButton:(UIButton *)sender
{

}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    
}

//karidome 5/21
-(void)labelReminder
{
//    {
//        
//        NSArray *lists = [event calendarsForEntityType:EKEntityTypeReminder];
//        
//        UILabel *label = [[UILabel alloc] init];
//        
//        NSDate *startDate = [NSDate distantPast];
//        
//        NSDate *endDate   = [NSDate distantFuture];
//        
//      
//        
//        
//        NSPredicate *predicate = [event predicateForIncompleteRemindersWithDueDateStarting:startDate ending:endDate calendars:nil];
//        
//        NSMutableArray *labels = [[NSMutableArray alloc]init];//配列にいれている『labels』
//        
//        [event fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
//         
//         {
//             
//             int i = 0;
//             
//             for(EKReminder *e in reminders)
//                 
//             {
//                 
//                 NSLog(@"title=%@", e.title);
//                 
//                 NSLog(@"sample=%@", e.dueDateComponents);
//                
//                 NSLog(@"*****alam=%@",e.alarms);
//                 
//                  NSLog(@"%@",e.location);
//                 
//                 NSLog(@"%@",e.notes);
//                 
//                 NSLog(@"::::time=%@",e.timeZone);
//                 
//                 
//                 
//                 NSLog(@"event: %@, %@,in %@",e.startDateComponents,e.title,e.calendar.title);
//                 
//                 
//                 
//                 NSString *titles = [NSString stringWithFormat:@"%@ \n",e.title];
//                 
//                 NSString *noto = [NSString stringWithFormat:@"%@ \n",e.notes];
//                   //「label（コードで作成）」から「_titleLabel（プロパティある方）」へ
//                 __titleLabel.textColor = [UIColor blackColor];
//                 
//                 __titleLabel.font = [UIFont systemFontOfSize:12];
//                 
//                 __titleLabel.numberOfLines = 0;
//                 
//                 __titleLabel.adjustsFontSizeToFitWidth = YES;
//                 
//                 //「　label2（コードで作成）　」から「　_notoLabel（プロパティある方）　」へ
//                 
//                 __notoLabel
//                 .textColor = [UIColor blackColor];
//                 
//                 __notoLabel.font = [UIFont systemFontOfSize:15];
//                 
//                 __notoLabel.numberOfLines = 0;
//                 
//                 __notoLabel.adjustsFontSizeToFitWidth = YES;
//                 
//                 
//                 //_titleLabel 5/21
//                 __titleLabel.text = [NSString stringWithFormat:@"%@\n",titles];//@"%@",titles;
//                 
//                 //_notoLabel 5/21
//                 __notoLabel.text = [NSString stringWithFormat:@" \n %@\n",noto];
//                 
//                NSLog(@"noto=%@",noto);
// 
//                 EKEventStore *eventStore = [[EKEventStore alloc] init];
//                 NSArray *lists = [eventStore calendarsForEntityType:EKEntityTypeReminder];
//                 EKCalendar *sampleList = [lists firstObject];
//                 
//                 NSLog(@"kokokokoko%@",sampleList);
//                 
//  //           UITableViewCell *cell = [UITableView dequeueReusableCellWithIdentifier:@"myCell"forIndexPath:NSIndexPath];
//                 
//              //   [self.view addSubview:label];
//                 [self.view addSubview:__titleLabel];
//                 
//              //   [self.view addSubview:label2];
//                 [self.view addSubview:__notoLabel];
//                 
//                 [labels addObject:label];
//                 
//                 i++;
//                 
//             }
//             
//             EKEventViewController *datailViewController =[[EKEventViewController alloc]initWithNibName:nil bundle:nil];
//             
//             //         datailViewController.event = [event objectAtindex:0];
//             
//             [self.navigationController pushViewController:datailViewController animated:YES];
//             
//             [datailViewController reloadInputViews];
//         }];
//        
//        [self.view addSubview:label];
// 
//    }
}



@end
