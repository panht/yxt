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
#import "ThreeDES.h"
#import "MBProgressHUD.h"

@interface yxtLogin ()

@end

@implementation yxtLogin

//@synthesize imageBackground;
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
    self.imageBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    // 添加点击关闭键盘事件
//    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTap:)];
//    [self.imageViewBackground addGestureRecognizer:backgroundTap];
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
    
    self.textUsername.delegate = self;
    self.textPassword.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeKeyboard:(id)sender  {
    [sender resignFirstResponder];
}

//- (IBAction)backgroundTap:(id)sender {
////    [textUsername resignFirstResponder];
////    [textPassword resignFirstResponder];
//    [self.view endEditing: YES];
//}

- (void)viewDidUnload {
//    [self setButtonLogin:nil];
//    [self setImageBackground:nil];
    [self setImageViewIcon:nil];
    [self setLabelUsername:nil];
    [self setLabelPassword:nil];
    [super viewDidUnload];
}

// 登录事件
- (IBAction)loginTapped:(id)sender {
    // loading
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    sleep(1);
    
    yxtAppDelegate *app = [[UIApplication sharedApplication] delegate];
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
    [yxtUtil checkNetwork];
    
    
    NSString *identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    // TODO 检查版本
//    NSString *dataVer = @"";
//    NSString *requestInfoVer = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"ver" :@"0" :@"0" :identityInfo :dataVer]];
//    NSDictionary *dataResponseVer = [yxtUtil getResponse:requestInfoVer :identityInfo :dataVer];
    
    // 验证用户名密码
    // TODO 3DES加密，双角色那里还有一处也要改
//    NSString *pwd = [ThreeDES encrypt:self.textPassword.text withKey:app.ThreeDesKey];
    NSString *pwd = @"/uNkSKHfSh8=";
//    NSString *pwd = self.textPassword.text;
    NSString *data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"logintype\":\"\", \"account\":\"%@\", \"pwd\":\"%@\"}]", self.textUsername.text, pwd]];
    NSString *requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"login" :@"0" :@"0" :identityInfo :data]];
    
    [self login: requestInfo :identityInfo : data];
    
    [HUD hide:YES];
    [HUD removeFromSuperview];
}

- (void) login:(NSString *)requestInfo :(NSString *)identityInfo :(NSString *)data
{
    NSError *error;
    NSDictionary* jsonResult;
    NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
    
    // 如果成功
    if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"1"]) {
        yxtAppDelegate *app = (yxtAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *result = [dataResponse objectForKey:@"data"];
        NSData *dataResult = [result dataUsingEncoding:NSUTF8StringEncoding];
        jsonResult = [NSJSONSerialization JSONObjectWithData:dataResult
                                                     options:kNilOptions
                                                       error:&error];
        
        
        // TODO 登录类型为3，暂时自动重新登录，要改为弹出选择角色界面
        if ([app.loginType isEqualToString:@""] && [[jsonResult objectForKey:@"logintype"] isEqualToString: @"3"]) {
            // 保存全局变量
            [app setLoginType:[jsonResult objectForKey:@"logintype"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择登录身份" message:@"" delegate:self cancelButtonTitle:@"教师" otherButtonTitles: @"家长", nil];
            [alert show];
            return;
        } else {
            // 保存全局变量
            [app setLoginType:[jsonResult objectForKey:@"logintype"]];
            [app setHeaderimg:[jsonResult objectForKey:@"headerimg"]];
            [app setUserId:[jsonResult objectForKey:@"userid"]];
            [app setUsername:[jsonResult objectForKey:@"username"]];
            [app setSchoolNo:[jsonResult objectForKey:@"schoolserno"]];
            [app setToken:[jsonResult objectForKey:@"token"]];
            
            // 保存用户名密码
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:self.textUsername.text forKey: @"username"];
            [userDefaults setValue:self.textPassword.text forKey: @"password"];
            
            // 跳转到入口界面
            [app showIndex];
            [self.view removeFromSuperview];
            //        NSLog(@"resultdata: %@", [jsonResult objectForKey:@"logintype"]);
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dataResponse objectForKey:@"resultdes"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

//定义的委托，buttonindex就是按下的按钮的index值
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    yxtAppDelegate *app = (yxtAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (buttonIndex == 0) {
        [app setLoginType:@"1"];
    } else if (buttonIndex == 1) {
        [app setLoginType:@"2"];
    }
    
    NSString *pwd = @"/uNkSKHfSh8=";
    NSString *identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    NSString *data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"logintype\":\"\", \"account\":\"%@\", \"pwd\":\"%@\"}]", self.textUsername.text, pwd]];
    NSString *requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"login" :@"0" :@"0" :identityInfo :data]];
    
    NSLog(@"id: %@", identityInfo);
    [self login: requestInfo :identityInfo : data];
    
//    dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
//
//    if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"1"]) {
//        result = [dataResponse objectForKey:@"data"];
//        dataResult = [result dataUsingEncoding:NSUTF8StringEncoding];
//        jsonResult = [NSJSONSerialization JSONObjectWithData:dataResult
//                                                     options:kNilOptions
//                                                       error:&error];
//    }
}

// 版本检查
- (void) checkVersion {
    
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
