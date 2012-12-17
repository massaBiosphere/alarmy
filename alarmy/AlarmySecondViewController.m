//
//  AlarmySecondViewController.m
//  alarmy
//
//  Created by 中川 正博 on 12/08/20.
//  Copyright (c) 2012年 Masahiro Nakagawa. All rights reserved.
//

#import "AlarmySecondViewController.h"

@interface AlarmySecondViewController ()

@end

@implementation AlarmySecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self selectCompDB];
    sum = chick1+chick2+chick3+chick4+chick5+chick6+chick7+chick8+chick9;
    per = (sum/(float)9)*100;
    if(chick1 == 0){
        [view1 setHidden:YES];
    }
    if(chick2 == 0){
        [view2 setHidden:YES];
    }
    if(chick3 == 0){
        [view3 setHidden:YES];
    }
    if(chick4 == 0){
        [view4 setHidden:YES];
    }
    if(chick5 == 0){
        [view5 setHidden:YES];
    }
    if(chick6 == 0){
        [view6 setHidden:YES];
    }
    if(chick7 == 0){
        [view7 setHidden:YES];
    }
    if(chick8 == 0){
        [view8 setHidden:YES];
    }
    if(chick9 == 0){
        [view9 setHidden:YES];
    }
    conp.text = [NSString stringWithFormat:
                 @"コンプ率%d％だよ",per];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


//データベース接続
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

//コンプ情報取り出し
-(void)selectCompDB{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        // SELECT
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM comp"];
        while([rs next]){
            chick1 = [rs intForColumn:@"chick1"];
            chick2 = [rs intForColumn:@"chick2"];
            chick3 = [rs intForColumn:@"chick3"];
            chick4 = [rs intForColumn:@"chick4"];
            chick5 = [rs intForColumn:@"chick5"];
            chick6 = [rs intForColumn:@"chick6"];
            chick7 = [rs intForColumn:@"chick7"];
            chick8 = [rs intForColumn:@"chick8"];
            chick9 = [rs intForColumn:@"chick9"];

        }
        [rs close];
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}




@end
