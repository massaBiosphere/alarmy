//
//  SettingViewController.m
//  alarmy
//
//  Created by 中川 正博 on 12/08/21.
//  Copyright (c) 2012年 Masahiro Nakagawa. All rights reserved.
//

#import "SettingViewController.h"
#import "AlarmyFirstViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    
    NSLog(@"%@", NSStringFromCGPoint([touch locationInView:self.view]));
    
    int index = touch.view.tag;
    NSLog(@"index:%d", index);
    if(index == 1){
        NSLog(@"あいうえお");
    }else{
        NSLog(@"a");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[AlarmyFirstViewController setAlerm:datePicker.date];
	// Do any additional setup after loading the view.
    alarmSwitch.on = NO;//switchをオフにしておく
    alarmEnabled = FALSE;
    textview.editable = NO;
}

- (void)viewDidUnload
{
    textview = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)setAlerm{
    [AlarmyFirstViewController setAlerm:datePicker.date];
    [self seveAlerm:datePicker.date]; //アラーム時刻の保存
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDate *date = [self loadAlerm]; //アラーム時刻の読み出し
    if (date == nil) {
        return;
    }
    datePicker.date = date;
    alarmSwitch.on = NO;
    alarmEnabled = FALSE;
}

- (IBAction)switchClick
{
    //スイッチをONにするとflag系をすべて初期化する
    AlarmyFirstViewController *set = [[AlarmyFirstViewController alloc] init];
    //アラームの状態によって変更
    if (alarmSwitch.on == YES) {
        [set alarm_init];
        [self setAlerm]; //ボタンを押したらアラーム時刻をとる
        [AlarmyFirstViewController setAlarmEnabled:TRUE];
    }
    else
    {
        [AlarmyFirstViewController setAlarmEnabled:FALSE];
        [alarmPlayer stop]; //アラームを止める
    }
    
    return;
}

// アラーム時刻を保存
- (void)seveAlerm:(NSDate*)w_alarmTime;
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:w_alarmTime];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:ALARM_SET_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// アラーム時刻の読み込み
- (NSDate*)loadAlerm;
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ALARM_SET_TIME];
    if (data == nil) {
        NSLog(@"あいうえお");
        return nil; //読めなかったときは、nilを返す。
        // NSDate *today = [NSDate date]; //現在時刻を取得
        //return today;
    }
    
    NSDate *w_alarmTime = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //retain抜いた
    return w_alarmTime;}

@end
