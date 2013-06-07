//
//  yxtDetail1.m
//  yxt
//
//  Created by world ask on 13-6-5.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtDetail1.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"

@interface yxtDetail1 ()

@end

@implementation yxtDetail1

@synthesize action;
@synthesize pageIndex;
@synthesize pageSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)homeTapped:(id)sender {
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *list1View = [topWindow viewWithTag:300];
    [self.view removeFromSuperview];
    [list1View removeFromSuperview];
}

- (IBAction)backTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (void) loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 判断action
        NSString *requestInfo;
        NSString *identityInfo;
        NSString *data;
        
//        self.action = @"bulletinContent";
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        if ([self.action isEqualToString:@"bulletinContent"]) {
            self.navTitle.text = @"|通知公告|详细内容";
            data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
            requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
        } else if ([self.action isEqualToString:@"homeworkContent"]) {
            self.navTitle.text = @"|家庭作业|详细内容";
            data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
            requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
        } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
            self.navTitle.text = @"|成绩信息|详细内容";
            data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
            requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
        } else if ([self.action isEqualToString:@"selectExamReceiveMsg"]) {
            self.navTitle.text = @"|成绩信息|详细内容";
            data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
            requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
        } else if ([self.action isEqualToString:@"reviewsContent"]) {
            self.navTitle.text = @"|日常表现|详细内容";
            data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
            requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
        }
        
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            
            NSArray *data = [jsonList objectForKey:@"list"];
            NSDictionary *row = [data objectAtIndex:0];
            
            // 数据绑定到控件
            if ([self.action isEqualToString:@"bulletin"]) {
                self.labelTitle.text = [row objectForKey:@"msg_title"];
                self.labelTime.text = [NSString stringWithFormat:@"发件人：%@ 时间：%@", [row objectForKey:@"user_name"], [row objectForKey:@"rec_date"]];
                self.labelContent.text = [row objectForKey:@"bulletin_content"];
            } else if ([self.action isEqualToString:@"homework"]) {
                self.labelTitle.text = [row objectForKey:@"msg_title"];
                self.labelTime.text = [NSString stringWithFormat:@"发件人：%@ 时间：%@", [row objectForKey:@"user_name"], [row objectForKey:@"rec_date"]];
                self.labelContent.text = [row objectForKey:@"bulletin_content"];
            } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
                self.labelTitle.text = [row objectForKey:@"msg_title"];
                self.labelTime.text = [NSString stringWithFormat:@"发件人：%@ 时间：%@", [row objectForKey:@"user_name"], [row objectForKey:@"rec_date"]];
                self.labelContent.text = [row objectForKey:@"bulletin_content"];
            }  else if ([self.action isEqualToString:@"selectExamReceiveMsg"]) {
                self.labelTitle.text = [row objectForKey:@"msg_title"];
                self.labelTime.text = [NSString stringWithFormat:@"发件人：%@ 时间：%@", [row objectForKey:@"user_name"], [row objectForKey:@"rec_date"]];
                self.labelContent.text = [row objectForKey:@"bulletin_content"];
            } else if ([self.action isEqualToString:@"reviews"]) {
                self.labelTitle.text = [row objectForKey:@"msg_title"];
                self.labelTime.text = [NSString stringWithFormat:@"发件人：%@ 时间：%@", [row objectForKey:@"user_name"], [row objectForKey:@"rec_date"]];
                self.labelContent.text = [row objectForKey:@"bulletin_content"];
            }
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabelTitle:nil];
    [self setLabelTime:nil];
    [self setLabelContent:nil];
    [self setNavTitle:nil];
    [super viewDidUnload];
}
@end
