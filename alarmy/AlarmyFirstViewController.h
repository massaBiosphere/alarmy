//
//  AlarmyFirstViewController.h
//  alarmy
//
//  Created by 中川 正博 on 12/08/20.
//  Copyright (c) 2012年 Masahiro Nakagawa. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface AlarmyFirstViewController : UIViewController{
    IBOutlet UILabel *display;
    IBOutlet UILabel *setTime;
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *hukidashi;
    IBOutlet UIButton *snoo;
    IBOutlet UILabel *text;
}
    - (void)driveClock:(NSTimer *)timer;
    + (void)setAlerm:(NSDate*)w_alermTime;
    + (NSDate*)getAlerm;
    - (void)alarmStop:(id)sender;
    + (void)setAlarmEnabled:(BOOL)w_alermEnabled;
    - (IBAction)setSnooze:(id)sender;
    + (BOOL)getAlarmEnabled;
    - (void)moving;
    - (void)setInitialPosition;
    - (void)setstop_flagnumber;
    - (void)alarm_init;
@end

NSDate *alarmTime; //アラーム時間
AVAudioPlayer *alarmPlayer; //アラーム音の再生プレーヤー
BOOL alarmEnabled; //アラームの利用状態
BOOL ringing; //アラームが鳴ってるかどうか
BOOL snooNow;//スヌーズかどうか
NSString *imageName; //キャラ画像の名前


int alarmTotal; //アラーム起動回数
int snoozeTotal;
int shakeNumber; //shake回数
int snoozeNumber; //スヌーズ回数
int sinkaFlag; //進化フラグ

NSString *path;

NSMutableArray *kotoba;
NSMutableArray *tsundere;
NSMutableArray *uso;
NSMutableArray *hutsu;
NSMutableArray *homeru;
NSMutableArray *okosanai;
NSMutableArray *kamate;
NSMutableArray *bakuon;
NSMutableArray *okan;
NSMutableArray *ka;
