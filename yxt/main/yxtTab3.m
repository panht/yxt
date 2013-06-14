//
//  yxtIndex3.m
//  yxt
//
//  Created by panht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtTab3.h"
#import "yxtUtil.h"
#import "yxtAppDelegate.h"

@interface yxtTab3 ()

@end

@implementation yxtTab3

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
}

- (void) viewDidAppear:(BOOL)animated {
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 获取集中平台应用列表
    NSString *identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    NSString *data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"Token\":\"%@\"}]", app.blocToken]];
    NSString *requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"getBlocAppList" :@"0" :@"0" :identityInfo :data]];
    //    NSLog(@"%@", requestInfo);
    //    NSLog(@"%@", identityInfo);
    //    NSLog(@"%@", data);
    NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
    
    if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageBackground:nil];
    [super viewDidUnload];
}
@end
