//
//  yxtForm.m
//  yxt
//
//  Created by panht on 13-6-6.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtForm.h"
#import "yxtFormUser.h"
#import "yxtForm1.h"
#import "yxtForm2.h"
#import "yxtForm3.h"
#import "yxtForm4.h"

@interface yxtForm ()

@end

@implementation yxtForm

@synthesize xibName;
@synthesize formUser;

@synthesize navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 导航栏背景图
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"backgroundNav.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置表单
    if ([self.xibName isEqualToString:@"yxtFormUser"]) {
        [self loadFormUser];
    } else if ([self.xibName isEqualToString:@"yxtForm1"]) {
        [self loadForm1];
    } else if ([self.xibName isEqualToString:@"yxtForm2"]) {
        [self loadForm2];
    } else if ([self.xibName isEqualToString:@"yxtForm3"]) {
        [self loadForm3];
    } else if ([self.xibName isEqualToString:@"yxtForm4"]) {
        [self loadForm4];
    }
}

//  设置子视图
- (void) settleForm: (yxtViewControllerBase*)vc {
    // 设置子视图高度
    int x, y, width, height;
    x = 0;
    y = self.navBar.frame.size.height;
    width = self.view.frame.size.width;
    height = self.view.frame.size.height - y ;
    vc.view.frame = CGRectMake(x, y, width, height);
    vc.imageBackground.frame = CGRectMake(x, y, width, height);
}

// 载入个人信息表单
-(void) loadFormUser {
    self.navTitle.title = @"个人信息 >> 修改";
    self.formUser = [[yxtFormUser alloc] initWithNibName:@"yxtFormUser" bundle:nil];
    self.formUser.parentImageHead = self.parentImageHead;
    [self addChildViewController:self.formUser];
    [self settleForm:self.formUser];
    
//    // 添加点击关闭键盘事件
//    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc]initWithTarget:self.formUser action:@selector(backgroundTap:)];
//    [self.formUser.imageBackground addGestureRecognizer:backgroundTap];
    
    // 显示表单视图
    [self.view addSubview:self.formUser.view];
}

// 载入通知公告表单
-(void) loadForm1 {
    self.navTitle.title = @"通知公告 >> 添加内容";
    self.form1 = [[yxtForm1 alloc] initWithNibName:@"yxtForm1" bundle:nil];
    [self addChildViewController:self.form1];
    [self settleForm:self.form1];
    
    // 显示表单视图
    [self.view addSubview:self.form1.view];
}

// 载入通知公告表单
-(void) loadForm2 {
    self.navTitle.title = @"通知公告 >> 添加内容";
    self.form2 = [[yxtForm2 alloc] initWithNibName:@"yxtForm2" bundle:nil];
    [self addChildViewController:self.form2];
    [self settleForm:self.form2];
    
    // 显示表单视图
    [self.view addSubview:self.form2.view];
}

// 载入通知公告表单
-(void) loadForm3 {
    self.navTitle.title = @"成绩信息 >> 添加内容";
    self.form3 = [[yxtForm3 alloc] initWithNibName:@"yxtForm3" bundle:nil];
    [self addChildViewController:self.form3];
    [self settleForm:self.form3];
    
    // 显示表单视图
    [self.view addSubview:self.form3.view];
}

// 载入通知公告表单
-(void) loadForm4 {
    self.navTitle.title = @"日常表现 >> 添加内容";
    self.form4 = [[yxtForm4 alloc] initWithNibName:@"yxtForm4" bundle:nil];
    [self addChildViewController:self.form4];
    [self settleForm:self.form4];
    
    // 显示表单视图
    [self.view addSubview:self.form4.view];
}


- (IBAction)backgroundTap:(id)sender {
//    [self.formUser.view endEditing: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeTapped:(id)sender {
    [self.view removeFromSuperview];
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *list1View = [topWindow viewWithTag:300];
    [list1View removeFromSuperview];
}

- (IBAction)backTapped:(id)sender {
    [self.view removeFromSuperview];
}
- (void)viewDidUnload {
    [self setNavBar:nil];
    [self setNavTitle:nil];
    [super viewDidUnload];
}
@end
