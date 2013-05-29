//
//  yxtIndex1.m
//  yxt
//
//  Created by pht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtIndex1.h"

@interface yxtIndex1 ()

@end

@implementation yxtIndex1
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self createIcons];
    
    return self;
}

// 创建图标
- (void) createIcons
{
    // 区分中小学版和幼教版
    // 中小学版第一屏【家校互动】：通知公告、家庭作业、成绩信息、日常表现
    // 中小学版第二屏【交流园地】：班级成员、翼聊、爱城市、天翼景象、家校微博、名师大讲堂
    // 中小学版第三屏【特色应用】：集团应用调用
    // 幼教版第一屏【家校互动】：幼教通知、幼园活动、营养配餐、疫情通知、成长寄语
    // 幼教版第二屏【交流园地】：班级成员、活动靓照、宝宝视频、家校微博
    // 幼教版第三屏【特色应用】：集团应用调用
    self.button1.frame = CGRectMake(self.button1.frame.origin.x, self.button1.frame.origin.y, self.button1.frame.size.width, self.button1.frame.size.height);
    self.button2.frame = CGRectMake(self.button1.frame.origin.x + 100, self.button1.frame.origin.y, self.button1.frame.size.width, self.button1.frame.size.height);
    self.button3.frame = CGRectMake(self.button2.frame.origin.x + 100, self.button1.frame.origin.y, self.button1.frame.size.width, self.button1.frame.size.height);
    self.button4.frame = CGRectMake(self.button1.frame.origin.x, self.button1.frame.origin.y + 100, self.button1.frame.size.width, self.button1.frame.size.height);
    self.button5.hidden = YES;
    
    [self.button1 addTarget:self action:@selector(openList) forControlEvents:UIControlEventTouchUpInside];
}

// 打开列表界面
- (void) openList
{
    NSLog(@"111");		
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [self setButton3:nil];
    [self setButton4:nil];
    [self setButton5:nil];
    [super viewDidUnload];
}
@end
