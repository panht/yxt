//
//  yxtLogin.m
//  yxt
//
//  Created by panht on 13-4-19.
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

@synthesize flagLogout;
@synthesize flagCheckVersion;
// 1为选择角色，2为强制更新，3为可选更新
@synthesize flagAlert;
@synthesize urlUpdate;
@synthesize imageViewIcon;
@synthesize textUsername;
@synthesize textPassword;
@synthesize buttonLogin;

- (void)viewDidLoad {
//    NSLog(@"%@", [yxtUtil md5:@"㟗"]);
    [super viewDidLoad];
    [self setFlagCheckVersion:YES];
    
    // 读取本地信息
    [self readDefaults];
    [self displayPasswordTapped];
    
    // 自动登录
    [self autoLogin];
    
    // 重新排放控件
    [self resettle];
}

// 重新排放控件
- (void) resettle {
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    int x, y = 0, width, height;
    x = 30;
    width = 80;
    height = 30;
    
    NSInteger spacing = 0;
    if (screenHeight == 568) {
        spacing = 50;
        y = 210;
    } else if (screenHeight == 480) {
        spacing = 43;
        y = 180;
    } 

    // 背景图及Logo
//    UIImage *imageBackground = [UIImage imageWithContentsOfFile:@"backgroundLogin"];
    self.imageBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    
    // 用户名、密码
    self.labelUsername.frame  = CGRectMake(x, y, width, height);
    self.textUsername.frame = CGRectMake(x + width, y, 200, 30);
    self.labelPassword.frame = CGRectMake(x, y + spacing, width, height);
    self.textPassword.frame = CGRectMake(x + width, y + spacing, 200, 30);
    
    // 显示密码，自动登录
    self.labelDisplayPassword.frame = CGRectMake(x, y + spacing * 2, width, height);
    self.inputDisplayPassword.frame = CGRectMake(x + width, y + spacing * 2, 120, 35);
    self.labelAutoLogin.frame =  CGRectMake(x, y + spacing * 3, width, height);
    self.inputAutoLogin.frame = CGRectMake(x + width, y + spacing * 3, 120, 35);
    // 显示密码添加点击事件
    UITapGestureRecognizer *gestureDisplayPassword = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayPasswordTapped)];
    self.inputDisplayPassword.userInteractionEnabled = YES;
    [self.inputDisplayPassword addGestureRecognizer:gestureDisplayPassword];
    
    // 登录按钮，居中，密码框下方
    self.buttonLogin.frame = CGRectMake((screenWidth - self.buttonLogin.frame.size.width) / 2, y + spacing * 4, self.buttonLogin.frame.size.width, self.buttonLogin.frame.size.height);
    
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
    [self setLabelDisplayPassword:nil];
    [self setInputDisplayPassword:nil];
    [self setLabelAutoLogin:nil];
    [self setInputAutoLogin:nil];
    [super viewDidUnload];
}

// 登录事件
- (IBAction)loginTapped:(id)sender {
    Boolean flagLogin = YES;
    NSString *message;
    
    // 检查用户名密码是否为空
    if ([self.textUsername.text isEqualToString:@""]) {
        message = @"请输入用户名";
        flagLogin = NO;
        
    }
    if (flagLogin == YES && [self.textPassword.text isEqualToString:@""]) {
        message = @"请输入密码";
        flagLogin = NO;
    }
    if (flagLogin == NO) {
        [yxtUtil warning:self.view :message];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // 检查网络连接
        [yxtUtil checkNetwork];
        
        // 检查版本
        BOOL flagVersionNew = [self checkVersion];
        
        if (flagVersionNew == NO) {
            NSString *identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
            // 验证用户名密码
            //  3DES加密
            yxtAppDelegate *app = (yxtAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *pwd = [ThreeDES encrypt:self.textPassword.text withKey:app.ThreeDesKey];
            NSString *data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"logintype\":\"\", \"account\":\"%@\", \"pwd\":\"%@\"}]", self.textUsername.text, pwd]];
            NSString *requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"login" :@"0" :@"0" :identityInfo :data]];
            
            [self login: requestInfo :identityInfo : data];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void) login:(NSString *)requestInfo :(NSString *)identityInfo :(NSString *)data {
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
        
        
        // 登录类型为3，弹出选择角色界面
        if ([app.loginType isEqualToString:@""] && [[jsonResult objectForKey:@"logintype"] isEqualToString: @"3"]) {
            // 保存全局变量
            [app setLoginType:[jsonResult objectForKey:@"logintype"]];
            
            [self setFlagAlert:1];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择登录身份" message:@"" delegate:self cancelButtonTitle:@"教师" otherButtonTitles: @"家长", nil];
            [alert show];
            return;
        } else {
            // 保存全局变量
            if (![[jsonResult objectForKey:@"logintype"] isEqualToString:@"3"]) {
                [app setLoginType:[jsonResult objectForKey:@"logintype"]];
            }
            [app setHeaderimg:[jsonResult objectForKey:@"headerimg"]];
            [app setUserId:[jsonResult objectForKey:@"userid"]];
            [app setAcc:[jsonResult objectForKey:@"acc"]];
            [app setUsername:[jsonResult objectForKey:@"username"]];
            [app setSchoolNo:[jsonResult objectForKey:@"schoolserno"]];
            [app setSchoolName:[jsonResult objectForKey:@"schoolname"]];
            [app setAreaCode:[jsonResult objectForKey:@"areacode"]];
            [app setToken:[jsonResult objectForKey:@"token"]];
            
            // 保存用户名密码
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:self.textUsername.text forKey: @"username"];
            [userDefaults setValue:self.textPassword.text forKey: @"password"];
            [userDefaults setValue:[NSString stringWithFormat:@"%d", self.inputDisplayPassword.selectedSegmentIndex] forKey: @"displayPassword"];
            [userDefaults setValue:[NSString stringWithFormat:@"%d", self.inputAutoLogin.selectedSegmentIndex] forKey: @"autoLogin"];
            
            // 跳转到入口界面
            [app showWelcome];
            [self.view removeFromSuperview];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dataResponse objectForKey:@"resultdes"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

//定义的委托，buttonindex就是按下的按钮的index值
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.flagAlert == 1) {
        yxtAppDelegate *app = (yxtAppDelegate *)[[UIApplication sharedApplication] delegate];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (buttonIndex == 0) {
                [app setLoginType:@"1"];
            } else if (buttonIndex == 1) {
                [app setLoginType:@"2"];
            }
            
            NSString *pwd = [ThreeDES encrypt:self.textPassword.text withKey:app.ThreeDesKey];
            NSString *identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
            NSString *data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"logintype\":\"\", \"account\":\"%@\", \"pwd\":\"%@\"}]", self.textUsername.text, pwd]];
            NSString *requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"login" :@"0" :@"0" :identityInfo :data]];
            
            [self login: requestInfo :identityInfo : data];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } else if (self.flagAlert == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlUpdate]];
    } else if (self.flagAlert == 3) {
//        self.urlUpdate = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", 436957167];
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlUpdate]];
        } else {
            [self setFlagCheckVersion:NO];
            [self autoLogin];
        }
    }
}

// 版本检查
- (BOOL) checkVersion {
    if (self.flagCheckVersion == YES) {
        // 从plist读取当前版本号
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSMutableDictionary *dataPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:plist];
        NSInteger version = [[dataPlist objectForKey:@"Version"] integerValue];
        
        // 从服务器获取最新版本号
        NSString *identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        NSString *data = @"";
        NSString *requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"ver" :@"0" :@"0" :identityInfo :data]];
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            NSArray *data = [jsonList objectForKey:@"list"];
            NSDictionary *row = [data objectAtIndex:0];
            
            NSInteger dataver = [[row objectForKey:@"ver"] integerValue];
            
            //        NSLog(@"old:%d   new:%d", version, dataver);
            // 比较版本号
            if (dataver > version) {
                [self setUrlUpdate:[row objectForKey:@"ver_url"]];
                
                // 是否强制更新
                if ([[row objectForKey:@"ver"] isEqualToString:@"1"]) {
                    [self setFlagAlert:2];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本，请更新" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                } else {
                    [self setFlagAlert:3];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新版本，是否更新" message:@"" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否", nil];
                    [alert show];
                }
                
                return YES;
            }
        }
    }
    
    return NO;
}

// 读取本地存储
- (void) readDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.textUsername.text = [userDefaults stringForKey:@"username"];
    self.textPassword.text = [userDefaults stringForKey:@"password"];
    
    NSString *displayPassword = [userDefaults stringForKey:@"displayPassword"];
    if (displayPassword != nil) {
        self.inputDisplayPassword.selectedSegmentIndex = [displayPassword integerValue];
    } else {
        self.inputDisplayPassword.selectedSegmentIndex = 1;
    }
    NSString *autoLogin = [userDefaults stringForKey:@"autoLogin"];
    if (autoLogin != nil) {
        self.inputAutoLogin.selectedSegmentIndex = [autoLogin integerValue];
    } else {
        self.inputAutoLogin.selectedSegmentIndex = 1;
    }
}

// 自动登录
- (void) autoLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithFormat:@"%d", self.inputAutoLogin.selectedSegmentIndex] forKey: @"autoLogin"];
    
    if (self.flagLogout != YES && self.inputAutoLogin.selectedSegmentIndex == 0 && self.textUsername.text != nil && ![self.textUsername.text isEqualToString:@""] && self.textPassword.text != nil && ![self.textPassword.text isEqualToString:@""]) {
        [self loginTapped: self.buttonLogin];
    }
}

// 显示密码开关实现
- (void) displayPasswordTapped {
    if (self.inputDisplayPassword.selectedSegmentIndex == 0) {
        [self.textPassword setSecureTextEntry:NO];
    } else {
        [self.textPassword setSecureTextEntry:YES];
    }
}

@end
