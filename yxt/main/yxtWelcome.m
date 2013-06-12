//
//  yxtWelcome.m
//  yxt
//
//  Created by panht on 13-6-2.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "yxtWelcome.h"
#import "yxtTab1.h"
#import "yxtTab2.h"
#import "yxtTab3.h"
#import "yxtForm.h"
#import "yxtFormUser.h"

@interface yxtWelcome ()

@end

@implementation yxtWelcome

@synthesize tab1;
@synthesize tab2;
@synthesize tab3;
@synthesize tabCurrent;
@synthesize navBar;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize image11;
@synthesize image12;
@synthesize image21;
@synthesize image22;
@synthesize image31;
@synthesize image32;
@synthesize imageHead;
@synthesize username;

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
    
    // 添加子视图
    self.tab1 = [[yxtTab1 alloc] initWithNibName:@"yxtTab1" bundle:nil];
    [self addChildViewController:self.tab1];
    self.tab2 = [[yxtTab2 alloc] initWithNibName:@"yxtTab2" bundle:nil];
    [self addChildViewController:self.tab2];
    self.tab3 = [[yxtTab3 alloc] initWithNibName:@"yxtTab3" bundle:nil];
    [self addChildViewController:self.tab3];
    
    // 设置子视图高度
    int x, y, width, height;
    x = 0;
    y = self.navBar.frame.size.height;
    width = self.view.frame.size.width;
    height = self.view.frame.size.height - y - self.navBar.frame.size.height * 2;
    self.tab1.view.frame = CGRectMake(x, y, width, height);
    self.tab2.view.frame = CGRectMake(x, y, width, height);
    self.tab3.view.frame = CGRectMake(x, y, width, height);
    self.tab1.imageBackground.frame = CGRectMake(x, y, width, height);
    self.tab2.imageBackground.frame = CGRectMake(x, y, width, height);
    self.tab3.imageBackground.frame = CGRectMake(x, y, width, height);
    
    // 显示第一个视图
    [self.view addSubview:self.tab1.view];
    self.tabCurrent = self.tab1;
    [self setButton];
    
    // 设置头像、名字
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", app.urlHead, app.headerimg]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data != NULL) {
        // 要判断头像图片是否存在
        UIImage *aimage = [[UIImage alloc] initWithData:data];
        self.imageHead.image = aimage;
        [self.imageHead setNeedsDisplay];
    }
    self.username.text = app.username;
    
    // 点击头像打开更新用户信息界面
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openForm:)];
    [self.imageHead addGestureRecognizer:headTap];
}

// 打开通用表单
-(void) openForm: (NSString*) nibName {
    self.form = [[yxtForm alloc] initWithNibName:@"yxtForm" bundle:[NSBundle mainBundle]];
    
    self.form.xibName = @"yxtFormUser";
    self.form.parentImageHead = self.imageHead;
    self.form.view.tag = 300;
    
    // 设置子视图高度
    int x, y, width, height;
    x = 0;
    y = 20;
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    self.form.view.frame = CGRectMake(x, y, width, height);
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    [topWindow addSubview: self.form.view];
    [topWindow makeKeyAndVisible];
}

// 打开用户信息编辑页
-(void) openFormUser{
    self.formUser = [[yxtFormUser alloc] initWithNibName:@"yxtFormUser" bundle:nil];
    
    // 设置子视图高度
//    int x, y, width, height;
//    x = 0;
//    y = 0;
//    width = self.parentViewController.view.frame.size.width;
//    height = self.parentViewController.view.frame.size.height;
//    self.list1.view.frame = CGRectMake(x, y, width, height);
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    [topWindow addSubview: self.formUser.view];
    [topWindow makeKeyAndVisible];
}

-(void) item1Tapped:(id)sender
{
    if (self.tabCurrent != self.tab1) {
        [self transitionFromViewController:self.tabCurrent toViewController:self.tab1 duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        }  completion:^(BOOL finished) {
            if (finished) {
                self.tabCurrent = self.tab1;
                [self.button1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
                [self.button2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
                [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
            }
        }];
    }
}

-(void) item2Tapped:(id)sender
{
    if (self.tabCurrent != self.tab2) {
        [self transitionFromViewController:self.tabCurrent toViewController:self.tab2 duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        }  completion:^(BOOL finished) {
            if (finished) {
                self.tabCurrent = self.tab2;
                [self.button1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
                [self.button2 setBackgroundImage:self.image22 forState:UIControlStateNormal];
                [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
            }
        }];
    }
}

-(void) item3Tapped:(id)sender
{
    if (self.tabCurrent != self.tab3) {
        [self transitionFromViewController:self.tabCurrent toViewController:self.tab3 duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        }  completion:^(BOOL finished) {
            if (finished) {
                self.tabCurrent = self.tab3;
                [self.button1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
                [self.button2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
                [self.button3 setBackgroundImage:self.image32 forState:UIControlStateNormal];
            }
        }];
    }
}

// 设置工具栏按钮宽度、文字及绑定事件
- (IBAction)logout:(id)sender {
    // 向服务器注销
    NSString *requestInfo;
    NSString *identityInfo;
    NSString *data;
    identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
    requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"logout" :@"0" :@"0" :identityInfo :data]];
    [yxtUtil getResponse:requestInfo :identityInfo :data];
    
    yxtAppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app setLoginType:@""];
    [app setHeaderimg:@""];
    [app setUserId:@""];
    [app setUsername:@""];
    [app setSchoolNo:@""];
    [app setToken:@""];
    
    // 跳转到登录界面
    [app showLogin];
    [self.view removeFromSuperview];
}

-(void) setButton {
    // 设置背景图
    //    self.button1.title = @"家校互动";
    //    self.button2.title = @"校园交流";
    //    self.button3.title = @"特色应用";
    self.image11 = [UIImage imageNamed:@"indextab11.png"];
    self.image12 = [UIImage imageNamed:@"indextab12.png"];
    self.image21 = [UIImage imageNamed:@"indextab21.png"];
    self.image22 = [UIImage imageNamed:@"indextab22.png"];
    self.image31 = [UIImage imageNamed:@"indextab31.png"];
    self.image32 = [UIImage imageNamed:@"indextab32.png"];
    [self.button1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
    [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
    
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // 重画按钮
    int x, y = 0, width, height;
    x = 0;
    y = screenHeight - statusBarHeight - self.navBar.frame.size.height;
    width  = screenWidth / 3 - 1;
    height = self.navBar.frame.size.height;
    self.button1.frame = CGRectMake(x, y, width, height);
    self.button2.frame = CGRectMake(x + width + 1, y, width, height);
    self.button3.frame = CGRectMake(x + width * 2 + 2, y, width, height);
    
    // 点击事件
    [self.button1 addTarget:self action:@selector(item1Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(item2Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(item3Tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // 手势事件
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
}

// 左右滑动手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.tabCurrent == self.tab1) {
            
        } else if (self.tabCurrent == self.tab2) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab1 duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.tabCurrent = self.tab1;
                    [self.button1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
                    [self.button2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
                    [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
                }
            }];
            
        } else if (self.tabCurrent == self.tab3) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab2 duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.tabCurrent = self.tab2;
                    [self.button1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
                    [self.button2 setBackgroundImage:self.image22 forState:UIControlStateNormal];
                    [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
                }
            }];
        }
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.tabCurrent == self.tab1) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab2 duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.tabCurrent = self.tab2;
                    [self.button1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
                    [self.button2 setBackgroundImage:self.image22 forState:UIControlStateNormal];
                    [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
                }
            }];
        } else if (self.tabCurrent == self.tab2) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab3 duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.tabCurrent = self.tab3;
                    [self.button1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
                    [self.button2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
                    [self.button3 setBackgroundImage:self.image32 forState:UIControlStateNormal];
                }
            }];
        } else if (self.tabCurrent == self.tab3) {
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTab1:nil];
    [self setTab2:nil];
    [self setTab3:nil];
    [self setNavBar:nil];
    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [self setImage11:nil];
    [self setImage12:nil];
    [self setImage21:nil];
    [self setImage22:nil];
    [self setImage31:nil];
    [self setImage32:nil];
    [self setImageHead:nil];
    [self setUsername:nil];
    [super viewDidUnload];
}
@end
