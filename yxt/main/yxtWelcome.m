//
//  yxtWelcome.m
//  yxt
//
//  Created by world ask on 13-6-2.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtWelcome.h"
#import "yxtTab1.h"
#import "yxtTab2.h"
#import "yxtTab3.h"

@interface yxtWelcome ()

@end

@implementation yxtWelcome

@synthesize tab1;
@synthesize tab2;
@synthesize tab3;
@synthesize tabCurrent;
@synthesize navBar;
@synthesize toolbar;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize item1;
@synthesize item2;
@synthesize item3;
@synthesize image11;
@synthesize image12;
@synthesize image21;
@synthesize image22;
@synthesize image31;
@synthesize image32;

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
    // Do any additional setup after loading the view from its nib.
    
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
    height = self.view.frame.size.height - y - self.navBar.frame.size.height;
    self.tab1.view.frame = CGRectMake(x, y, width, height);
    self.tab2.view.frame = CGRectMake(x, y, width, height);
    self.tab3.view.frame = CGRectMake(x, y, width, height);
    
    // 显示第一个视图
    [self.view addSubview:self.tab1.view];
    self.tabCurrent = self.tab1;
    [self setButton];
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
-(void) setButton {
    // 设置背景图
    //    self.item1.title = @"家校互动";
    //    self.item2.title = @"校园交流";
    //    self.item3.title = @"特色应用";
    self.image11 = [UIImage imageNamed:@"indextab11.png"];
    self.image12 = [UIImage imageNamed:@"indextab12.png"];
    self.image21 = [UIImage imageNamed:@"indextab21.png"];
    self.image22 = [UIImage imageNamed:@"indextab22.png"];
    self.image31 = [UIImage imageNamed:@"indextab31.png"];
    self.image32 = [UIImage imageNamed:@"indextab32.png"];
    [self.button1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
    [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
    
    // 重画按钮
    int x, y, width, height;
    x = 0;
    y = self.view.frame.size.height - self.navBar.frame.size.height;
    width  = self.view.frame.size.width / 3;
    height = self.navBar.frame.size.height;
    self.button1.frame = CGRectMake(x, y, width, height);
    self.button2.frame = CGRectMake(x + width, y, width, height);
    self.button3.frame = CGRectMake(x + width * 2, y, width, height);
    
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

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.tabCurrent == self.tab1) {
            
        } else if (self.tabCurrent == self.tab2) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab1 duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.tabCurrent = self.tab1;
                    [self.button1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
                    [self.button2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
                    [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
                }
            }];
            
        } else if (self.tabCurrent == self.tab3) {
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
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.tabCurrent == self.tab1) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab2 duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.tabCurrent = self.tab2;
                    [self.button1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
                    [self.button2 setBackgroundImage:self.image22 forState:UIControlStateNormal];
                    [self.button3 setBackgroundImage:self.image31 forState:UIControlStateNormal];
                }
            }];
        } else if (self.tabCurrent == self.tab2) {
            [self transitionFromViewController:self.tabCurrent toViewController:self.tab3 duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
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
    [self setNavBar:nil];
    [self setToolbar:nil];
    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [super viewDidUnload];
}
@end
