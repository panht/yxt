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
    height = self.view.frame.size.height - y - self.toolbar.frame.size.height;
    self.tab1.view.frame = CGRectMake(x, y, width, height);
    self.tab2.view.frame = CGRectMake(x, y, width, height);
    self.tab3.view.frame = CGRectMake(x, y, width, height);
    
    // 显示第一个视图
    [self.view addSubview:self.tab1.view];
    self.tabCurrent = self.tab1;
    
    // 设置工具栏按钮宽度、文字及绑定事件
    UIBarButtonItem *item1, *item2, *item3;
    item1 = [self.toolbar.items objectAtIndex:0];
    item2 = [self.toolbar.items objectAtIndex:1];
    item3 = [self.toolbar.items objectAtIndex:2];
    item1.width = self.view.frame.size.width / 3;
    item2.width = item1.width;
    item3.width = item1.width;
    item1.title = @"家校互动";
    item2.title = @"校园交流";
    item3.title = @"特色应用";
    
    [item1 setAction:@selector(item1Tapped:)];
    [item2 setAction:@selector(item2Tapped:)];
    [item3 setAction:@selector(item3Tapped:)];
}

-(void) item1Tapped:(id)sender
{
    if (self.tabCurrent != self.tab1) {
        [self transitionFromViewController:self.tabCurrent toViewController:self.tab1 duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        }  completion:^(BOOL finished) {
            if (finished) {
                self.tabCurrent = self.tab1;
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
            }
        }];
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
    [super viewDidUnload];
}
@end
