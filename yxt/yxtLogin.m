//
//  yxtLogin.m
//  yxt
//
//  Created by pht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtLogin.h"
#import "yxtAppDelegate.h"

@interface yxtLogin ()

@end

@implementation yxtLogin

//@synthesize imageViewBackground;
//@synthesize imageViewLogo;
//@synthesize labelUsername;
@synthesize textUsername;
//@synthesize labelPassword;
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
//    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
//
    // 背景图及Logo
//    self.imageViewLogo.frame = CGRectMake((screenWidth - imageIcon.size.width) / 2, 40, imageIcon.size.width, imageIcon.size.height);
    
    // 用户名
    self.buttonLogin.frame = CGRectMake(100, 350, 200, 30);
    self.labelMessage.frame = CGRectMake(100, 400, 200, 30);
    [self.textUsername setFrame:CGRectMake(100, 200, 200, 30)];
    [self.textPassword setFrame:CGRectMake(100, 250, 200, 30)];
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
//    [textUsername resignFirstResponder];
//    [textPassword resignFirstResponder];
    [self.view endEditing: NO];
}

- (void)viewDidUnload {
//    [self setButtonLogin:nil];
    [super viewDidUnload];
}

// 登录事件
- (IBAction)login:(id)sender {
    Boolean flagLogin = YES;
    NSString *message;
    
    // TODO 检查网络连接
    
    
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
