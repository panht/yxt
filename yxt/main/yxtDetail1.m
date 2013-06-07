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
@synthesize title1;
@synthesize title2;
@synthesize content;
@synthesize data;
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


-(void) setByAction: (NSString *)action{
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([self.action isEqualToString:@"bulletinContent"]) {
        self.navTitle.text = @"|通知公告|详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
    } else if ([self.action isEqualToString:@"homeworkContent"]) {
        self.navTitle.text = @"|家庭作业|详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
    } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
        self.navTitle.text = @"|成绩信息|详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
    } else if ([self.action isEqualToString:@"selectExamReceiveMsgDetail"]) {
        self.navTitle.text = @"|成绩信息|详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
    } else if ([self.action isEqualToString:@"reviewsContent"]) {
        self.navTitle.text = @"|日常表现|详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
    }
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
        // 判断action
        NSString *requestInfo;
        NSString *identityInfo;
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :self.data]];
        
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :self.data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            
            NSArray *dataListArray = [jsonList objectForKey:@"list"];
            NSDictionary *row = [dataListArray objectAtIndex:0];
            
            
            int x, y, width, height;
            x = 5;
            y = self.navBar.frame.size.height + 5;
            width = self.view.frame.size.width;
            height = 25;
            
            // 数据绑定到控件
            if ([self.action isEqualToString:@"bulletinContent"]) {
                // 通知公告
                self.label1.text = [row objectForKey:@"msg_title"];
                self.label2.text = [NSString stringWithFormat:@"发件人：%@", [row objectForKey:@"user_name"]];
                self.label3.text = [NSString stringWithFormat:@"时间：%@", [row objectForKey:@"rec_date"]];
                self.labelContent.text = [row objectForKey:@"bulletin_content"];
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.label3.frame = CGRectMake(x, y + height * 2, width, height);
                self.labelContent.frame = CGRectMake(x, y + height * 3, width, self.labelContent.frame.size.height);
                self.label1.textAlignment = UITextAlignmentCenter;
                self.label2.textAlignment = UITextAlignmentCenter;
                self.label3.textAlignment = UITextAlignmentCenter;
                self.label2.textColor =  [UIColor grayColor];
                self.label3.textColor =  [UIColor grayColor];
            } else if ([self.action isEqualToString:@"homeworkContent"]) {
                // 家庭作业 
                self.label1.text = [NSString stringWithFormat:@"作业课程：%@", [row objectForKey:@"course_name"]];
                self.label2.text = [NSString stringWithFormat:@"发送人：%@", [row objectForKey:@"user_name"]];
                self.label3.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"rec_date"]];
                self.label4.text = [NSString stringWithFormat:@"作业标题：%@", [row objectForKey:@"ass_title"]];
                self.labelContent.text = [row objectForKey:@"ass_content"];
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.label3.frame = CGRectMake(x, y + height * 2, width, height);
                self.label4.frame = CGRectMake(x, y + height * 3, width, height);
                self.labelContent.frame = CGRectMake(x, y + height * 4, width, self.labelContent.frame.size.height);
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
                self.label3.textAlignment = UITextAlignmentLeft;
                self.label4.textAlignment = UITextAlignmentLeft;
            } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
                self.label1.text = [NSString stringWithFormat:@"标题：%@", [row objectForKey:@"msg_title"]];
                self.label2.text = [NSString stringWithFormat:@"考试班级：%@", [row objectForKey:@"class_name"]];
                self.label3.text = [NSString stringWithFormat:@"考试科目：%@", [row objectForKey:@"course_name"]];
                self.label4.text = [NSString stringWithFormat:@"发送备注：%@", [row objectForKey:@"send_remark"]];
                self.label5.text = [NSString stringWithFormat:@"发送时间 ：%@", [row objectForKey:@"op_date"]];
//                self.labelContent.text = [row objectForKey:@"bulletin_content"];
            } else if ([self.action isEqualToString:@"selectExamReceiveMsgDetail"]) {
                self.label1.text = [row objectForKey:@"msg_content"];
                self.label2.text = [NSString stringWithFormat:@"发送者：%@", [row objectForKey:@"user_name"]];
                self.label3.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"op_date"]];
            } else if ([self.action isEqualToString:@"reviewsContent"]) {
                self.label1.text = [NSString stringWithFormat:@"发件人：%@", [row objectForKey:@"user_name"]];
                self.label2.text = [row objectForKey:@"msg_title"];
                self.label3.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"rec_date"]];
                self.labelContent.text = [row objectForKey:@"msg_content"];
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.label3.frame = CGRectMake(x, y + height * 2, width, height);
                self.labelContent.frame = CGRectMake(x, y + height * 3, width, self.labelContent.frame.size.height);
            }
            
//            [self.label1 sizeToFit];
//            [self.label2 sizeToFit];
//            [self.label3 sizeToFit];
//            [self.label4 sizeToFit];
//            [self.label5 sizeToFit];
            [self.labelContent sizeToFit];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setByAction:self.action];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabel1:nil];
    [self setLabel2:nil];
    [self setLabelContent:nil];
    [self setNavTitle:nil];
    [self setLabel3:nil];
    [self setLabel4:nil];
    [self setLabel5:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end
