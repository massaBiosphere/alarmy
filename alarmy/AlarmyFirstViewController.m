//
//  AlarmyFirstViewController.m
//  alarmy
//
//  Created by 中川 正博 on 12/08/20.
//  Copyright (c) 2012年 Masahiro Nakagawa. All rights reserved.
//

#import "AlarmyFirstViewController.h"

static int flag = 0;  //flagを0に設定
int flag1 = 0;
int flag2 = 0; //アニメーションを終了させるflag
int flag3 = 0; //アラーム時のアニメーションの左右の動きを真ん中にするためのflag

int stop_flag = 0;
int snooze_count = 0;
CGPoint initPosition;

@interface AlarmyFirstViewController ()

@end

@implementation AlarmyFirstViewController

- (void)viewDidLoad
{
	//最初1秒ほどのNAVITIMEとか表示を消す作業
    if(flag == 0){
        setTime.text = [NSString stringWithFormat:@"アラームを設定してね"];
        NSDate *today = [NSDate date]; //ついた瞬間に現在時刻を取得する
        
        NSCalendar *calender = [NSCalendar currentCalendar]; //現在時刻の時分秒を取得
        unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *todayComponents = [calender components:flags fromDate:today];
        int hour = [todayComponents hour];
        int min = [todayComponents minute];
        int sec = [todayComponents second];
        
        display.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec]; //時間を表示
        flag = 1;  //flagを1にしてここでメソッドを終わらせる
    }    
    // Do any additional setup after loading the view, typically from a nib.
    //変数の初期化
    alarmEnabled = FALSE;
    shakeNumber = 0;
    snoozeNumber = 0;
    snooNow = FALSE;
    ringing = FALSE;
    [snoo setHidden:YES];
    path = nil;
    //台詞処理
    kotoba = [[NSMutableArray alloc] init];
    tsundere= [NSArray arrayWithObjects:@"あんたってホントお寝坊さん。アタチがいないと起きれないんだから〜", @"アタチは一人で起きれるけどあんたはアタチ無しで起きれないんでしょ", @"あんたはアタチのことだけ頼りにしてればいいのよっ", @"べっ、別に起こして上げてるからって勘違いしないでよ！", @"そんな時間におきるの？べっ別に心配してる訳じゃないんだから！", @"お、起こしてあげたんだから感謝しなさい！", @"あんたはおっちょこちょいなんだから今日も気をつけなさいよ！", @"早くおきなさいよバカ！", @"今日は何するの？寂しくなんかないけど聞いただけ！", @"天気予報見てる？ちゃんと見なさいよバカ！", @"アタチに起こしてもらえるなんて今のうちだからね！", @"アタチに起こしてもらって眠いとか言わないでよね！", @"今日はよく眠れた？べ、別に気になんかしてないんだから！", @"みんなのためにアラームならしてる訳じゃないんだからね！", @"早寝早起きは三文の得！ア、アドバイスじゃないんだからね！", @"起きれない？私が一生懸命起こしてあげてるんだから起きてよ！", @"ちゃんと暖かくして寝てなさいよ、風邪でも引いたら困るんだからね！", @"やっと起きたわね、ぐっすり寝ちゃってもう", @"おはよう！な、なによ別にいいじゃない", @"アタチに起こしてもらえて嬉しい？き、興味ないけどね！", nil];
    uso= [NSArray arrayWithObjects:@"12:59ですよー起きなさああい", @"15:00ですよーおやつ食べます？", @"19:00ですよー晩ご飯まだあ？", @"06:00ですよーいい目覚めですね！", @"03:00ですよー夜行性ですか？", @"00:00ですよー新しい一日の始まりです！", @"07:21ですよー今日も一日頑張りましょう！", @"09:33ですよー社長出勤ですか？", @"09:58ですよー今日はのんびりですね！", @"10:12ですよー朝ご飯かお昼ご飯か悩ましいですね！", @"08:44ですよーそろそろ準備しなきゃまずくないですか？", @"08:26ですよー今日の運勢は大吉です！なんちゃって", @"28:79ですよーさて！ほんとの時間は何時でしょう？", @"12:60ですよーあっ繰り上げるのわすれちゃった〜", @"16:00ですよーキリがいいですね！", @"17:30ですよーそろそろお腹減ってきましたね", @"07:50ですよー今日は何があるんですか？", @"08:11ですよーふふっふ〜", @"09:02ですよー今日も一日お元気に！",@"09:53ですよーもしかしてお寝坊ですか？", @"08:47ですよーっと、ハイ起きて〜", nil];
    hutsu= [NSArray arrayWithObjects:@"おはようございます", @"おそようございます", @"今日も一日頑張ってくださいね", @"今日のお天気はチェックされましたか？", @"明日もよろしくお願いします", @"すっきり目覚めれましたか？", @"朝にカフェインをとると目覚めが良くなりますよ", @"朝ご飯は食べましたか？", @"いつもお疲れさまです", @"体調に気をつけてくださいね", @"今日はきっとラッキーデーですよ", @"おっはー、とかゆってみました", @"外のお天気はどうですか？", @"今日の目標を一言どうぞ！", @"今日の予定はなんですか？服装ばっちりで行きましょう！", @"起きてちょんまげ〜とかゆってみました", @"ジリリリリ。起きてくださいね", @"目を覚ますには手足を曲げ伸ばしするといいですよ", @"お体に気をつけて今日もファイトです！", @"今日は何日、ふっふ〜。ご機嫌なんです。", nil];
    homeru= [NSArray arrayWithObjects:@"おはよう様でございます！今日もすっきりお目覚め素敵です！！", @"お目覚め様でございます！今日も輝いています！！", @"おはよう様でございます！今日も素晴らしい一日になりますよ！！", @"おはよう様です〜一回で起きられる人って素晴らしいです！！", @"あなた様を起こせるなんて光栄至極に存じます！！", @"すぐに目覚めるなんて流石です！！感心いたします！！", @"今日もすっきり起きてくださってありがとうございます！！", @"今日も一度で起きてくださってありがとうございます！！", @"自己管理の出来る人って本当に尊敬します！！", @"すぐに起きられるなんて偉い！！偉い！！偉いいい！！", @"今日もあなた様を起こせて幸せです！！", @"一度で目覚められるあなた様は天才！！", @"ほんっとあなた様ってサイコー！！", @"すぐに起きられる人って魅力的！！", @"すぐに起きられるなんてあなた様は凄すぎです〜！！", @"すぐに起きられるなんて、もう一生起こさせていただきたいです！！", @"寝起きの良さは天下一品であられます！！", @"あなた様の寝起きの良さは世界一です！！", @"毎日健やかな目覚めをされるなんて素敵！！", @"おはようございます！！今日も素敵な一日になられますよーに！！", nil];
    okosanai= [NSArray arrayWithObjects:@"・・・", @"しぃーっ！", @"すやすや寝てて可愛い子ね", @"起こしても起きないなら起こさなくていいよね", @"もう起こさなくていいよね", @"本日休業日", @"定休日のためお休みします", @"私も寝よう", @"絶対に起こすものかー", @"起こし疲れたから今日は休むの", @"もう起こしたくないです＞＜", @"声が出ないよー", @"ニヤニヤ", @"寝過ごしちゃえー", @"寝坊して後悔しちゃえー", @"いつからアラームがなると錯覚してたの？", @"ならないアラーム、そうそれが私", @"どうしても鳴れないの＞＜", @"音のないアラーム",nil];
    kamate= [NSArray arrayWithObjects:@"おなかすいたよー", @"遊びにいこうよー", @"ご飯食べたいよー", @"起きてくれなきゃ死んじゃうー", @"起きてくれないと寂しくて死んじゃうよー", @"ねえねえ、おきてー", @"起きてくれないから泣いちゃうー", @"かまってくれなきゃやだー", @"もう何を信じていいかわからないの", @"私のためなら死ねる？", @"起きてくれたらうれしいな", @"私より睡眠なの？", @"そっか、疲れてるもんね…", @"眠たいよね。ごめんね、私のせいで…", @"遊んでくれなきゃやだよぉ", @"起きてどっかいこうよー", @"今日は遊んでくれるっていったじゃん", @"もう、しらないよ？", @"ふーん、また寝るの？", nil];
    bakuon= [NSArray arrayWithObjects:@"ドッカーン！", @"バッコーン！", @"ズッドーン！", @"ガッチャーン！", @"ブオオオオオ！", @"ドン！ドンッ！", @"バン！バンッ！", @"ズドドドドッ！", @"ガッシャーン！", @"ドコドコドーン！", @"ガチャガチャガチャーン！", @"ドシドシドッシ！", @"ボッコボッコボーン！", @"バッキューン！", @"ドッシーン！", @"ズッダッダダダーン！", @"ウォオオオオオオン！", @"ゴルァアアアアアア！", @"ドリャアアアアア！", @"くぁwせdrftgyふじこlp；", nil];
    okan= [NSArray arrayWithObjects:@"あんた、いつまで寝てんの？", @"ご飯できてるからはよ起きてきー", @"はよ起きーな", @"いっつまでもゴロゴロしてほんまに", @"あんた起こしてたらもう１０歳老けたわ", @"いいかげんにせな、背中と布団ひっつくで", @"何時やと思ってんの？はよせな遅刻やで", @"あんたがはよ起こしてってゆうたんやんか", @"もう起こすのこれが最後やで", @"これで起きなお母さんもう知らんからな", @"ぐーたらぐーたらしてばっかりで、いらんとこばっかりお父さんに似たな", @"なっかなか起きへんから死んだんかと思ったわ", @"いつまでも寝てやんと自分の部屋の掃除ぐらいしなさいよ", @"いつまでも寝てやんと自分の洗濯物ぐらい自分でたたみなさい", @"あんたお母さんおらんなったらどうすんの", @"そろそろ起きて勉強しなさい", @"お母さんあんたの将来心配やわ", @"私もあんたぐらい寝たいわ", @"毎日、毎日なっかなか起きへんからお母さんもう嫌なるわ", @"どこでもぐーすか寝れてうらやましいわ", nil];
    ka= [NSArray arrayWithObjects:@"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", @"ぶーん", nil];

    //初回起動処理
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // KEY_BOOLの内容を取得し、BOOL型変数へ格納（初回起動の判断）
    BOOL isBool = [defaults boolForKey:@"KEY_BOOL"];
    // isBoolがNOの場合データベース作成
    if (!isBool) {
		[self createPointTable];
        [self createCompTable];
        [self insertFirst];
        [defaults setBool:YES forKey:@"KEY_BOOL"];
        // 設定を保存
        [defaults synchronize];
    }
    
    //DBから取得
    [self selectPointDB];
    [super viewDidLoad];
    
    //画像の読み込み
    CGRect rect = CGRectMake(85, 200, 150, 150); //画像の表示領域を作成
    imageView = [[UIImageView alloc]initWithFrame:rect]; //表示するview を作成
    [self.view addSubview:imageView]; //作成したviewを追加
    imageView.image = [UIImage imageNamed:imageName];
    
    //アニメーション後の初期位置
    initPosition = imageView.center;
    
    //タイマー処理
    [NSTimer scheduledTimerWithTimeInterval:1.0 //タイマーを発生させる間隔（1秒毎）
                                     target:self //メソッドがあるオブジェクト
                                   selector:@selector(driveClock:) //呼び出すメソッド
                                   userInfo:nil //メソッドに渡すパラメータ
                                    repeats:YES]; //繰り返し
    
    //音ファイル処理取得・設定
    [self chooseVoice];
    NSURL *url = [NSURL fileURLWithPath:path];
    alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    alarmPlayer.numberOfLoops = -1;//ループ回数指定
}

- (void)viewDidUnload
{
    //[self setSnooze:nil];
    snoo = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)alarm_init{
    flag1 = 0;
    flag2 = 0;
    flag3 = 0;
    stop_flag = 0;
    snooze_count = 0;
    stop_flag = 0;
    snooze_count = 0;
}

- (void)setInitialPosition{
    imageView.center = initPosition;
    flag1 = 3;
    //flagを初期化する。
    flag2 = 0;
    flag3 = 0;
    stop_flag = 1;
}

- (void)setstop_flagnumber{
    stop_flag = 0;
    flag1 = 0;
}

//アラーム時のイメージが左右に動くアニメーション
- (void)moving{
    if (flag1 < 3 && stop_flag == 0 && snooze_count != 3) {
        [UIView beginAnimations:NULL context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(moving)]; // アニメーション完了時にコールされるメソッドを設定
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        // 移動先の座標を設定
        if (flag1 == 0) {
            if(flag3 == 0) {
                //CGRectにdx,dyを加算したRectを取得する。
                imageView.frame = CGRectOffset(imageView.frame, -50, 0);
                flag3 = 1;
            }else{
                imageView.frame = CGRectOffset(imageView.frame, -100, 0);
            }
            flag1 = 1;
        }else if (flag1 == 1){
            imageView.frame = CGRectOffset(imageView.frame , 100,0);
            flag1 = 0;
        }else if(flag1 == 2){
            [self setInitialPosition];
        }
        // アニメーションブロック終了
        [UIView commitAnimations];
    }
    //flag1を初期化する。
    if(flag1 == 3 && stop_flag == 1){
        flag1 = 0;
    }
    
}

-(void)hukidasu{
    [text setHidden:NO];
    [hukidashi setHidden:NO];
}


//時計、アラーム処理
- (void)driveClock:(NSTimer *)timer
{
    NSDate *today = [NSDate date]; //現在時刻を取得
    
    NSCalendar *calender = [NSCalendar currentCalendar]; //現在時刻の時分秒を取得
    unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *todayComponents = [calender components:flags fromDate:today];
    int hour = [todayComponents hour];
    int min = [todayComponents minute];
    int sec = [todayComponents second];
    
    display.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec]; //時間を表示
    NSDateComponents *alarmComponents = [calender components:flags fromDate:alarmTime];
    int alarmhour = [alarmComponents hour];
    int alarmmin = [alarmComponents minute];
    //NSLog(@"hour=>%d min=>%d",alarmhour,alarmmin);
    
    if (alarmEnabled == TRUE) {
        setTime.text = [NSString stringWithFormat:@"アラーム設定 %02d:%02d",alarmhour,alarmmin];
        if ((hour == alarmhour && min == alarmmin)) {
            [alarmPlayer play];
            if (flag2 == 0) {
                [self moving];
                flag2 = 1;
            }
            ringing = TRUE;
            [snoo setHidden:NO];
        }
    }else if(snooNow == TRUE){
        setTime.text = [NSString stringWithFormat:@"スヌーズ中です%d/3回",snoozeNumber];
    }
    else{
        setTime.text = [NSString stringWithFormat:@"アラームを設定してね"];
    }
}
//スヌーズ処理
-(IBAction)setSnooze:(id)sender
{
    snooNow = TRUE;
    snoozeNumber++;
    [snoo setHidden:YES];
    [alarmPlayer stop];
    ringing = FALSE;
    shakeNumber = 0;
    alarmEnabled = FALSE;
    //二分後に鳴らせる
    if(snoozeNumber < 3){
        setTime.text = [NSString stringWithFormat:@"スヌーズ中です%d/3回",snoozeNumber];
        
    }else{
        setTime.text = @"アラームを設定してね";
        snooNow = FALSE;
    }
    [self performSelector:@selector(timerHandler) withObject:nil afterDelay:5];
}
//スヌーズした際の実処理
-(void)timerHandler
{
    if (snoozeNumber == 3){
        //２回スヌーズして起きれなかった時の処理
        [self alarmStop:@"massa"];
    }else{
        [alarmPlayer play];
        ringing = TRUE;
        [snoo setHidden:NO];
    }
}
//アラームのセット
+ (void)setAlerm:(NSDate*)w_alarmTime;
{
    alarmTime = w_alarmTime;
}
//アラーム時間の取得
+ (NSDate*)getAlerm;
{
    return(alarmTime);
}
//アラーム停止関数
- (void)alarmStop:(id)sender
{
    [alarmPlayer stop];
    ringing = FALSE;
    alarmEnabled = FALSE;
    snooNow = FALSE;
    shakeNumber = 0;
    [snoo setHidden:YES];
    snoozeTotal += snoozeNumber;
    snoozeNumber = 0;
    [self updateSnoozePoint];
    alarmTotal++;
    [self updateKidousuu];
    [self shinka];
}

////////////////////進化
-(void)chooseVoice{
    //音と吹き出しラベル内容選択
    if(alarmTotal < 5 || alarmTotal > 14){
        [text setHidden:YES];
        [hukidashi setHidden:YES];
        path = [[NSBundle mainBundle] pathForResource:@"b_011" ofType:@"mp3"];
    }else{
        if([imageName isEqualToString:@"おかん.jpg"]){
            [kotoba addObjectsFromArray:okan];
            path = [[NSBundle mainBundle] pathForResource:@"おかん声" ofType:@"mp3"];
        }else if([imageName isEqualToString:@"誉める.jpg"]){
            [kotoba addObjectsFromArray:homeru];
            path = [[NSBundle mainBundle] pathForResource:@"朝だよ" ofType:@"mp3"];
        }else if([imageName isEqualToString:@"蚊.jpg"]){
            [kotoba addObjectsFromArray:ka];
            path = [[NSBundle mainBundle] pathForResource:@"蚊の飛ぶ音" ofType:@"mp3"];
        }else if([imageName isEqualToString:@"起こさない.jpg"]){
            [kotoba addObjectsFromArray:okosanai];
            path = [[NSBundle mainBundle] pathForResource:@"b_011" ofType:@"mp3"];
        }else if([imageName isEqualToString:@"ふつう.jpg"]){
            [kotoba addObjectsFromArray:hutsu];
            path = [[NSBundle mainBundle] pathForResource:@"b_011" ofType:@"mp3"];
        }else if([imageName isEqualToString:@"かまてちゃん.jpg"]){
            [kotoba addObjectsFromArray:kamate];
            path = [[NSBundle mainBundle] pathForResource:@"朝だよ2" ofType:@"mp3"];
        }else if([imageName isEqualToString:@"ツンデレ.jpg"]){
            [kotoba addObjectsFromArray:tsundere];
            path = [[NSBundle mainBundle] pathForResource:@"おはよう" ofType:@"mp3"];
        }else if([imageName isEqualToString:@"嘘の時間.jpg"]){
            [kotoba addObjectsFromArray:uso];
            path = [[NSBundle mainBundle] pathForResource:@"b_011" ofType:@"mp3"];
        }else if([imageName isEqualToString:@"爆音.jpg"]){
            [kotoba addObjectsFromArray:bakuon];
            path = [[NSBundle mainBundle] pathForResource:@"syo-geki" ofType:@"mp3"];
        }
        else{
        }
        NSInteger random_number = arc4random() % 20;
        text.text = [kotoba objectAtIndex:random_number];
    }
}
//進化
-(void)shinka{
    if(alarmTotal == 5){
        //進化処理
        [text setHidden:YES];
        [hukidashi setHidden:YES];
        
        int number = 3;
        NSArray *imageArray = [NSArray arrayWithObjects: // 画像を登録します
                               [UIImage imageNamed:@"卵.jpg"],
                               [UIImage imageNamed:@"たまごヒビ.jpg"],
                               nil];
        imageView.animationImages = imageArray;	// 登録された画像をUIImageViewに反映します
        imageView.animationDuration = 1.0;	// 1コマの速度(秒)
        imageView.animationRepeatCount = number;	// 繰返す回数
        [imageView startAnimating];// 動作開始命令
        [self performSelector:@selector(hukidasu) withObject:nil afterDelay:3];
        [self performSelector:@selector(stopAnime) withObject:nil afterDelay:3];
    }else if(alarmTotal == 15){
        //死亡処理
        int number = 3;
        NSArray *imageArray = [NSArray arrayWithObjects: // 画像を登録します
                               [UIImage imageNamed:@"墓.png"],
                               [UIImage imageNamed:@"卵.jpg"],
                               nil];
        imageView.animationImages = imageArray;	// 登録された画像をUIImageViewに反映します
        imageView.animationDuration = 1.0;	// 1コマの速度(秒)
        imageView.animationRepeatCount = number;	// 繰返す回数
        [hukidashi setHidden:YES];
        [text setHidden:YES];
        [imageView startAnimating];		// 動作開始命令
        [self performSelector:@selector(stopAnime2) withObject:nil afterDelay:3];
    }else{
        //通常
    }
    imageView.image = [UIImage imageNamed:imageName];
}

-(void)stopAnime{
    [imageView stopAnimating];
    [self shinkaChange];
    [self changeChara];
    [self chooseVoice];
    NSURL *url = [NSURL fileURLWithPath:path];
    alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    alarmPlayer.numberOfLoops = -1;//ループ回数指定
}

-(void)stopAnime2{
    [imageView stopAnimating];
    [self clearDB];
    [self selectPointDB];
    [self updateImageName];
    [self changeChara];
    [self chooseVoice];
    NSURL *url = [NSURL fileURLWithPath:path];
    alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    alarmPlayer.numberOfLoops = -1;//ループ回数指定
}

//進化先選択
-(void)shinkaChange{
    //ポイントによる条件フラグ値変更
    if(snoozeTotal ==0){
        sinkaFlag = 0;
    }else if (snoozeTotal >= 1 && snoozeTotal <= 2){
        sinkaFlag =1;
    }else if (snoozeTotal >= 3 && snoozeTotal <= 6){
        sinkaFlag =2;
    }else if (snoozeTotal >= 7 && snoozeTotal <= 11){
        sinkaFlag =3;
    }else if (snoozeTotal >=12 && snoozeTotal <= 16){
        sinkaFlag =4;
    }else if (snoozeTotal >= 17 && snoozeTotal <= 21){
        sinkaFlag =5;
    }else if (snoozeTotal >= 22 && snoozeTotal <= 26){
        sinkaFlag =6;
    }else if (snoozeTotal >= 27 && snoozeTotal <= 31){
        sinkaFlag =7;
    }else{
        sinkaFlag =8;
    }
    //キャラクター変更処理
    switch (sinkaFlag) {
        case 0:
            imageName = @"誉める.jpg";
            [self updateImageName];
            [self updateChick1];
            break;
        case 1:
            imageName = @"ふつう.jpg";
            [self updateImageName];
            [self updateChick2];
            break;
        case 2:
            imageName = @"ツンデレ.jpg";
            [self updateImageName];
            [self updateChick3];
            break;
        case 3:
            imageName = @"嘘の時間.jpg";
            [self updateImageName];
            [self updateChick4];
            break;
        case 4:
            imageName = @"起こさない.jpg";
            [self updateImageName];
            [self updateChick5];
            break;
        case 5:
            imageName = @"かまてちゃん.jpg";
            [self updateImageName];
            [self updateChick6];
            break;
        case 6:
            imageName = @"爆音.jpg";
            [self updateImageName];
            [self updateChick7];
            break;
        case 7:
            imageName = @"おかん.jpg";
            [self updateImageName];
            [self updateChick8];
            break;
        case 8:
            imageName = @"蚊.jpg";
            [self updateImageName];
            [self updateChick9];
            break;
        default:
            break;
    }
}
//背景変更
-(void)changeChara{
     imageView.image = [UIImage imageNamed:imageName];
}
//アラームの有効無効の真偽値セット
+ (void)setAlarmEnabled:(BOOL)w_alermEnabled
{
    alarmEnabled = w_alermEnabled;
}
//取得
+ (BOOL)getAlarmEnabled
{
    return(alarmEnabled);
}

//////////////////シェイク関連
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // モーションがシェイクジェスチャーの場合には、新しい画面を開く
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"shake");
        flag1 = 2;  //アニメーション終了
        shakeNumber++;
        if(ringing == TRUE){
            if(shakeNumber>0){
                [self alarmStop:@"massa"];
            }
        }
    }
}

////////////////DB周りの処理
-(id) dbConnect{
    BOOL success;
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"alarmy.db"];
    NSLog(@"%@",writableDBPath);
    success = [fm fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"alarmy.db"];
        success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if(!success){
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    return db;
}
-(void)createPointTable{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS point (kidousuu INTEGER, point INTEGER, imageName TEXT)"];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)createCompTable{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        [db executeUpdate: @"CREATE TABLE IF NOT EXISTS comp (chick1 INTEGER, chick2 INTEGER, chick3 INTEGER, chick4 INTEGER, chick5 INTEGER, chick6 INTEGER, chick7 INTEGER, chick8 INTEGER, chick9 INTEGER)"];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)insertFirst{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //insert
        [db beginTransaction];
        [db executeUpdate:@"INSERT INTO point values (0,0,'卵.jpg')"];
        [db executeUpdate:@"INSERT INTO comp values (0,0,0,0,0,0,0,0,0)"];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)selectPointDB{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        // SELECT
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM point"];
        while([rs next]){
            alarmTotal = [rs intForColumn:@"kidousuu"];
            snoozeTotal = [rs intForColumn:@"point"];
            imageName = [rs stringForColumn:@"imageName"];
        }
        [rs close];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateSnoozePoint{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE point SET point=?",[NSNumber numberWithInt:snoozeTotal]];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateKidousuu{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE point SET kidousuu=?",[NSNumber numberWithInt:alarmTotal]];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateImageName{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE point SET imageName=?",imageName];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick1{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick1=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick2{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick2=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick3{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick3=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick4{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick4=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick5{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick5=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick6{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick6=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick7{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick7=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick8{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick8=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)updateChick9{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        [db executeUpdate:@"UPDATE comp SET chick9=1"];
        NSLog(@"update");
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}
-(void)clearDB{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //insert
        [db beginTransaction];
        [db executeUpdate:@"DELETE FROM point"];
        [db executeUpdate:@"INSERT INTO point values (0,0,'卵.jpg')"];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db commit];
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

@end
