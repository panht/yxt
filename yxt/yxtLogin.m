//
//  yxtLogin.m
//  yxt
//
//  Created by pht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtLogin.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"

@interface yxtLogin ()

@end

@implementation yxtLogin

@synthesize imageViewBackground;
@synthesize imageViewIcon;
@synthesize labelUsername;
@synthesize textUsername;
@synthesize labelPassword;
@synthesize textPassword;
@synthesize buttonLogin;
@synthesize labelMessage;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 读取用户名密码
    [self readDefaults];
    
    // 重新排放控件
    [self resettle];
    
//    [self.view endEditing:YES];
}

// 重新排放控件
- (void) resettle
{
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;

    // 背景图及Logo
//    UIImage *imageBackground = [UIImage imageWithContentsOfFile:@"background"];
    self.imageViewBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    // 添加点击关闭键盘事件
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTap:)];
    [self.imageViewBackground addGestureRecognizer:backgroundTap];
//    UIImage *imageIcon = [UIImage imageWithContentsOfFile:@"Icon"];
//    self.imageViewIcon.frame = CGRectMake((screenWidth - imageIcon.size.width) / 2, 40, imageIcon.size.width, imageIcon.size.height);
    
    // 用户名
    self.labelUsername.frame  = CGRectMake(30, 190, 60, 30);
    self.textUsername.frame = CGRectMake(90, self.labelUsername.frame.origin.y, 200, 30);
    // 密码
    self.labelPassword.frame = CGRectMake(self.labelUsername.frame.origin.x, self.labelUsername.frame.origin.y + 50, self.labelUsername.frame.size.width, self.labelUsername.frame.size.height);
    self.textPassword.frame = CGRectMake(self.textUsername.frame.origin.x, self.labelPassword.frame.origin.y, self.textUsername.frame.size.width, self.textUsername.frame.size.height);
    // 登录按钮，居中，密码框下方
    self.buttonLogin.frame = CGRectMake((screenWidth - self.buttonLogin.frame.size.width) / 2, self.textPassword.frame.origin.y + 50, self.buttonLogin.frame.size.width, self.buttonLogin.frame.size.height);
    // 提示框，登录按钮下方，宽高同输入框
    self.labelMessage.frame = CGRectMake(100, self.buttonLogin.frame.origin.y + 40, self.textUsername.frame.size.width, self.textUsername.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeKeyboard:(id)sender  {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [textUsername resignFirstResponder];
    [textPassword resignFirstResponder];
    [self.view endEditing: NO];
}

- (void)viewDidUnload {
//    [self setButtonLogin:nil];
    [self setImageViewBackground:nil];
    [self setImageViewIcon:nil];
    [self setLabelUsername:nil];
    [self setLabelPassword:nil];
    [super viewDidUnload];
}

// 登录事件
- (IBAction)login:(id)sender {
    Boolean flagLogin = YES;
    NSString *message;
    
    // 检查用户名密码是否为空
    if ([self.textUsername.text isEqualToString:@""])
    {
        message = @"请输入用户名";
        flagLogin = NO;
    }
    if (flagLogin == YES && [self.textPassword.text isEqualToString:@""])
    {
        message = @"请输入密码";
        flagLogin = NO;
    }
    
    // TODO 检查网络连接
    yxtUtil *util = [yxtUtil new];
    [util checkNetwork];
    
    // 验证用户名密码
    
    
    // 检查用户名密码是否正确
    if (flagLogin == YES && ![self.textUsername.text isEqualToString:@"12345"])
    {
        message = @"用户名不存在";
        flagLogin = NO;
    }
    if (flagLogin == YES && ![self.textPassword.text isEqualToString:@"1"])
    {
        message = @"密码错误";
        flagLogin = NO;
    }
    
    // 显示提示信息
    if (flagLogin == NO) {
        labelMessage.text = message;
        
//        NSLog([NSString stringWithFormat: @"%f", self.labelMessage.frame.origin.y], nil);
    } else {
        labelMessage.text = @"";
        
        // 保存用户名密码
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:self.textUsername.text forKey: @"username"];
        [userDefaults setValue:self.textPassword.text forKey: @"password"];

        // 跳转到入口界面
        [self.view removeFromSuperview];
        yxtAppDelegate *app = (yxtAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app showIndex];
    }
}

// 从本地存储读取用户名密码
- (void) readDefaults
{
    // 读取用户名密码
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.textUsername.text = [userDefaults stringForKey:@"username"];
    self.textPassword.text = [userDefaults stringForKey:@"password"];
}

@end
