//
//  yxtIndex2.m
//  yxt
//
//  Created by panht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtTab2.h"
#import "yxtList1.h"
#import "yxtAppDelegate.h"

@interface yxtTab2()
@end

@implementation yxtTab2


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self createIcons];
    
    return self;
}

// 显示列表页
- (void) showList1:(NSString *)action {
    // 设置action
    //    yxtAppDelegate *app = (yxtAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.list1 = [[yxtList1 alloc] initWithNibName:@"yxtList1" bundle:[NSBundle mainBundle]];
    [self.list1 setAction:action];
    
    // 设置子视图高度
    int x, y, width, height;
    x = 0;
    y = 20;
    width = self.parentViewController.view.frame.size.width;
    height = self.parentViewController.view.frame.size.height;
    self.list1.view.frame = CGRectMake(x, y, width, height);
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    self.list1.view.tag = 300;
    [topWindow addSubview:self.list1.view];
    [topWindow makeKeyAndVisible];
}

- (IBAction)button1Touch:(id)sender {
    [self showList1:@"eduClass"];
}

- (IBAction)button2Touch:(id)sender {
    NSString *link = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=YOUR_APP_ID";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)button3Touch:(id)sender {
}

- (IBAction)button4Touch:(id)sender {
}

- (IBAction)button5Touch:(id)sender {
}

- (IBAction)button6Touch:(id)sender {
}


- (void) createIcons
{
    // 中小学版第一屏【家校互动】：通知公告、家庭作业、成绩信息、日常表现
    // 中小学版第二屏【交流园地】：班级成员、翼聊、爱城市、天翼景象、家校微博、名师大讲堂
    // 中小学版第三屏【特色应用】：集团应用调用
//    self.button1.frame = CGRectMake(self.button1.frame.origin.x, self.button1.frame.origin.y, self.button1.frame.size.width, self.button1.frame.size.height);
//    self.button2.frame = CGRectMake(self.button1.frame.origin.x + 100, self.button1.frame.origin.y, self.button1.frame.size.width, self.button1.frame.size.height);
//    self.button3.frame = CGRectMake(self.button2.frame.origin.x + 100, self.button1.frame.origin.y, self.button1.frame.size.width, self.button1.frame.size.height);
//    self.button4.frame = CGRectMake(self.button1.frame.origin.x, self.button1.frame.origin.y + 100, self.button1.frame.size.width, self.button1.frame.size.height);
//    
//    [self.button1 addTarget:self action:@selector(openList) forControlEvents:UIControlEventTouchUpInside];
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
    [self setButton4:nil];
    [self setButton5:nil];
    [self setButton6:nil];
    [self setImageBackground:nil];
    [super viewDidUnload];
}

@end
