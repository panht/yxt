//
//  yxtForm.m
//  yxt
//
//  Created by world ask on 13-6-6.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtForm.h"
#import "yxtFormUser.h"

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
    
    // 设置表单
    if ([self.xibName isEqualToString:@"yxtFormUser"]) {
        [self loadFormUser];
    }
}

-(void) loadFormUser {
    self.navTitle.title = @"个人信息 | 修改";
    self.formUser = [[yxtFormUser alloc] initWithNibName:@"yxtFormUser" bundle:nil];
    [self addChildViewController:self.formUser];
    
    // 设置子视图高度
    int x, y, width, height;
    x = 0;
    y = self.navBar.frame.size.height;
    width = self.view.frame.size.width;
    height = self.view.frame.size.height - y ;
    self.formUser.view.frame = CGRectMake(x, y, width, height);
    self.formUser.imageBackground.frame = CGRectMake(x, y, width, height);
    
//    // 添加点击关闭键盘事件
//    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc]initWithTarget:self.formUser action:@selector(backgroundTap:)];
//    [self.formUser.imageBackground addGestureRecognizer:backgroundTap];
    
    // 显示表单视图
    [self.view addSubview:self.formUser.view];
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
