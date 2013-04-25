//
//  yxtLogin.m
//  yxt
//
//  Created by world ask on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtLogin.h"
#import "yxtAppDelegate.h"

@interface yxtLogin ()

@end

@implementation yxtLogin

@synthesize textUsername;
@synthesize textPassword;
@synthesize buttonLogin;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建控件
    self.textUsername = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 200, 30];
    self.textUsername.borderStyle = UITextBorderStyleRoundedRect;
//    self.textUsername
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"] ];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 登录事件
- (IBAction)login:(id)sender
{
    Boolean flagLogin = YES;
    NSString *message;
    
    // 检查网络连接
    
    // 检查用户名密码是否为空
//    textUsername = self.view.;
    if ([self.textUsername.text isEqualToString:@""])
    {
        message = @"请输入用户名";	
        flagLogin = NO;
    }
    if ([self.textPassword.text isEqualToString:@""])
    {
        message = @"请输入密码";
        flagLogin = NO;
    }

    // 检查用户名密码是否正确
    if ([self.textUsername.text isEqualToString:@"12345"])
    {
        message = @"用户名不存在";
        flagLogin = NO;
    }
    if ([self.textPassword.text isEqualToString:@"1"])
    {
        message = @"密码错误";
        flagLogin = NO;
    }    
    
    // 显示提示信息
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label1.text = message;
    [self.view addSubview:label1];    
    
    // 跳转到入口界面
//    if (flagLogin == YES) {
//        [self.view removeFromSuperview];
//        yxtAppDelegate *app = (yxtAppDelegate *)[[UIApplication sharedApplication] delegate];
//        [app showIndex];
//    }
}

-(IBAction)closeKeyboard:(id)sender {
    [sender resignFirstResponder];
}

//- (IBAction)backgroundTap:(id)sender {
//    [textUsername resignFirstResponder];
//    [textPassword resignFirstResponder];
//    NSLog(@"111");
//}

- (void)viewDidUnload {
    [self setButtonLogin:nil];
    [super viewDidUnload];
}
@end
