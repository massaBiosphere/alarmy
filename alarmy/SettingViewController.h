//
//  SettingViewController.h
//  alarmy
//
//  Created by 中川 正博 on 12/08/21.
//  Copyright (c) 2012年 Masahiro Nakagawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ALARM_SET_TIME @"ALARM_SET_TIME"

@interface SettingViewController : UIViewController{
    IBOutlet UIDatePicker *datePicker; //ピッカー
    IBOutlet UISwitch *alarmSwitch; //アラームスイッチ
    IBOutlet UITextView *textview;
}
 - (IBAction)setAlerm;
- (IBAction)switchClick;
- (void)seveAlerm:(NSDate*)w_alermTime;
- (NSDate*)loadAlerm;
@end
