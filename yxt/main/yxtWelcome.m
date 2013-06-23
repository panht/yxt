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
        
        self.image11 = [UIImage imageNamed:@"indextab11.png"];
        self.image12 = [UIImage imageNamed:@"indextab12.png"];
        self.image21 = [UIImage imageNamed:@"indextab21.png"];
        self.image22 = [UIImage imageNamed:@"indextab22.png"];
        self.image31 = [UIImage imageNamed:@"indextab31.png"];
        self.image32 = [UIImage imageNamed:@"indextab32.png"];
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
    
    // 创建定时器，每15分钟调用，循环调用repeats:YES，NO只调用一次
    id timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
}

- (void)runTimer:(id)timer {
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 向服务器验证token
    NSString *identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    NSString *data = [[NSString alloc] initWithFormat:@"[{\"token\":\"%@\", \"isbloc\":\"1\"}]", app.token];
    NSString *requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"tokenVerify" :@"0" :@"0" :identityInfo :data]];
//    NSLog(@"%@", requestInfo);
//    NSLog(@"%@", identityInfo);
//    NSLog(@"%@", data);
//    [yxtUtil getResponse:requestInfo :identityInfo :data];
    
    // 获取集中平台推送信息
    identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    data = [[NSString alloc] initWithFormat:@"[{\"userAccount\":\"%@\"}]", app.acc];
    requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"pushBlocMessage" :@"0" :@"0" :identityInfo :data]];
//        NSLog(@"%@", requestInfo);
//        NSLog(@"%@", identityInfo);
//        NSLog(@"%@", data);
//    NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
//
//    if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
//        NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error;
//        NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
//                                                                 options:kNilOptions
//                                                                   error:&error];
//        
//        NSArray *dataListArray = [jsonList objectForKey:@"list"];
//    }
}

- (void) viewDidAppear:(BOOL)animated {
    // 设置头像、名字
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.username.text = app.username;
    
    // 判断本地是否已保存头像文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"avatar.png"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UIImage *image;
    
    if (data != NULL) {
        image = [UIImage imageWithData:data];
    } else {
        // 否则从服务器获取
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", app.urlHead, app.headerimg]];
        data = [NSData dataWithContentsOfURL:url];
        
        if (data != NULL) {
            //  保存为本地文件
            [data writeToFile:filePath atomically:YES];
            image = [UIImage imageWithData:data];
        } else {
            // 否则显示默认头像
            image = [UIImage imageNamed:@"account_ico.png"];
        }
    }
    self.imageHead.image = image;
    [self.imageHead setNeedsDisplay];
    
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
                self.image12 = [UIImage imageNamed:@"indextab12.png"];
                self.image21 = [UIImage imageNamed:@"indextab21.png"];
                self.image31 = [UIImage imageNamed:@"indextab31.png"];
                [self.button1 setImage: self.image12];
                [self.button2 setImage: self.image21];
                [self.button3 setImage: self.image31];
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
                self.image11 = [UIImage imageNamed:@"indextab11.png"];
                self.image22 = [UIImage imageNamed:@"indextab22.png"];
                self.image31 = [UIImage imageNamed:@"indextab31.png"];
                [self.button1 setImage: self.image11];
                [self.button2 setImage: self.image22];
                [self.button3 setImage: self.image31];
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
                self.image11 = [UIImage imageNamed:@"indextab11.png"];
                self.image21 = [UIImage imageNamed:@"indextab21.png"];
                self.image32 = [UIImage imageNamed:@"indextab32.png"];
                [self.button1 setImage: self.image11];
                [self.button2 setImage: self.image21];
                [self.button3 setImage: self.image32];
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
    self.image12 = [UIImage imageNamed:@"indextab12.png"];
    self.image21 = [UIImage imageNamed:@"indextab21.png"];
    self.image31 = [UIImage imageNamed:@"indextab31.png"];
    [self.button1 setImage: self.image12];
    [self.button2 setImage: self.image21];
    [self.button3 setImage: self.image31];
    
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // 重画按钮
    int x, y = 0, width, height;
    x = 0;
    y = screenHeight - statusBarHeight - self.navBar.frame.size.height;
    width  = screenWidth / 3;
    height = self.navBar.frame.size.height;
    self.button1.frame = CGRectMake(x, y, width, height);
    self.button2.frame = CGRectMake(x + width + 1, y, width, height);
    self.button3.frame = CGRectMake(x + width * 2 + 2, y, width, height);
    
    // 点击事件
    UITapGestureRecognizer *button1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(item1Tapped:)];
    if (self.button1) {
        self.button1.userInteractionEnabled = YES;
        [self.button1 addGestureRecognizer:button1Tap];
    }
    UITapGestureRecognizer *button2Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(item2Tapped:)];
    if (self.button2) {
        self.button2.userInteractionEnabled = YES;
        [self.button2 addGestureRecognizer:button2Tap];
    }
    UITapGestureRecognizer *button3Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(item3Tapped:)];
    if (self.button3) {
        self.button3.userInteractionEnabled = YES;
        [self.button3 addGestureRecognizer:button3Tap];
    }
//    [self.button1 addTarget:self action:@selector(item1Tapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.button2 addTarget:self action:@selector(item2Tapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.button3 addTarget:self action:@selector(item3Tapped:) forControlEvents:UIControlEventTouchUpInside];
    
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
                    self.image12 = [UIImage imageNamed:@"indextab12.png"];
                    self.image21 = [UIImage imageNamed:@"indextab21.png"];
                    self.image31 = [UIImage imageNamed:@"indextab31.png"];
                    [self.button1 setImage: self.image12];
                    [self.button2 setImage: self.image21];
                    [self.button3 setImage: self.image31];
                }
            }];
            
        } else if (self.tabCurrent == self.tab3) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab2 duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.tabCurrent = self.tab2;
                    self.image11 = [UIImage imageNamed:@"indextab11.png"];
                    self.image22 = [UIImage imageNamed:@"indextab22.png"];
                    self.image31 = [UIImage imageNamed:@"indextab31.png"];
                    [self.button1 setImage: self.image11];
                    [self.button2 setImage: self.image22];
                    [self.button3 setImage: self.image31];
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
                    self.image11 = [UIImage imageNamed:@"indextab11.png"];
                    self.image22 = [UIImage imageNamed:@"indextab22.png"];
                    self.image31 = [UIImage imageNamed:@"indextab31.png"];
                    [self.button1 setImage: self.image11];
                    [self.button2 setImage: self.image22];
                    [self.button3 setImage: self.image31];
                }
            }];
        } else if (self.tabCurrent == self.tab2) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab3 duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.tabCurrent = self.tab3;
                    self.image11 = [UIImage imageNamed:@"indextab11.png"];
                    self.image21 = [UIImage imageNamed:@"indextab21.png"];
                    self.image32 = [UIImage imageNamed:@"indextab32.png"];
                    [self.button1 setImage: self.image11];
                    [self.button2 setImage: self.image21];
                    [self.button3 setImage: self.image32];
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
