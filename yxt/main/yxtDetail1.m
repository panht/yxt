//
//  yxtDetail1.m
//  yxt
//
//  Created by panht on 13-6-5.
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
@synthesize type;
@synthesize title1;
@synthesize title2;
@synthesize content;
@synthesize data;
@synthesize pageIndex;
@synthesize pageSize;
@synthesize recordCount;

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
        self.navTitle.title = @"通知公告 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", self.type, app.userId]];
    } else if ([self.action isEqualToString:@"homeworkContent"]) {
        self.navTitle.title = @"家庭作业 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
    } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
        self.navTitle.title = @"成绩信息 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
    } else if ([self.action isEqualToString:@"selectExamReceiveMsgDetail"]) {
        self.navTitle.title = @"成绩信息 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
    } else if ([self.action isEqualToString:@"reviewsConetent"]) {
        self.navTitle.title = @"日常表现 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
    }
}

- (IBAction)btn1Tapped:(id)sender {
    [self setPageIndex:@"1"];
    [self loadData];
}

- (IBAction)btn2Tapped:(id)sender {
    NSInteger intPageIndex = [self.pageIndex integerValue];
    
    intPageIndex--;
    if (intPageIndex < 1) {
        intPageIndex = 1;
    }
    
    [self setPageIndex:[NSString stringWithFormat:@"%d", intPageIndex]];
    [self loadData];
}

- (IBAction)btn3Tapped:(id)sender {
    NSInteger intPageIndex = [self.pageIndex integerValue];
    NSInteger recordcount = [self.recordCount integerValue];
    
    intPageIndex++;
    if (intPageIndex > recordcount) {
        intPageIndex = recordcount;
    }
    
    [self setPageIndex:[NSString stringWithFormat:@"%d", intPageIndex]];
    [self loadData];
}

- (IBAction)btn4Tapped:(id)sender {
    [self setPageIndex:self.recordCount];
    [self loadData];
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
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *requestInfo;
        NSString *identityInfo;
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :self.data]];
        
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :self.data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            // 总记录数，用于翻页
            self.recordCount = [dataResponse objectForKey:@"recordcount"];
            
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
            NSString *detailTitle;
            NSString *DetailContent;
            if ([self.action isEqualToString:@"bulletinContent"]) {
                // 通知公告
                detailTitle = [row objectForKey:@"msg_title"];
                detailTitle = [yxtUtil urlDecode:detailTitle];
                DetailContent = [row objectForKey:@"bulletin_content"];
                DetailContent = [yxtUtil urlDecode:DetailContent];
                
                self.label1.text = detailTitle;
                self.label2.text = [NSString stringWithFormat:@"发件人：%@", [row objectForKey:@"user_name"]];
                self.label3.text = [NSString stringWithFormat:@"时间：%@", [row objectForKey:@"rec_date"]];
                self.labelContent.text = DetailContent;
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.label3.frame = CGRectMake(x, y + height * 2, width, height);
                int heightContent = self.view.frame.size.height - height * 3 - self.navBar.frame.size.height * 2;
                self.labelContent.frame = CGRectMake(x, y + height * 3, width, heightContent);
                
                self.label1.textAlignment = UITextAlignmentCenter;
                self.label2.textAlignment = UITextAlignmentCenter;
                self.label3.textAlignment = UITextAlignmentCenter;
                self.label2.textColor =  [UIColor grayColor];
                self.label3.textColor =  [UIColor grayColor];
                self.label2.font = [UIFont systemFontOfSize:12];
                self.label3.font = [UIFont systemFontOfSize:12];
            } else if ([self.action isEqualToString:@"homeworkContent"]) {
                // 家庭作业
                detailTitle = [row objectForKey:@"ass_title"];
                detailTitle = [yxtUtil urlDecode:detailTitle];
                DetailContent = [row objectForKey:@"ass_content"];
                DetailContent = [yxtUtil urlDecode:DetailContent];
                self.label1.text = [NSString stringWithFormat:@"作业课程：%@", [row objectForKey:@"course_name"]];
                self.label2.text = [NSString stringWithFormat:@"发  送  人：%@", [row objectForKey:@"user_name"]];
                self.label3.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"rec_date"]];
                self.label4.text = [NSString stringWithFormat:@"作业标题：%@", detailTitle];
                self.labelContent.text = DetailContent;
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.label3.frame = CGRectMake(x, y + height * 2, width, height);
                self.label4.frame = CGRectMake(x, y + height * 3, width, height);
                self.labelContent.frame = CGRectMake(x, y + height * 4, width, self.view.frame.size.height - height * 4 - self.navBar.frame.size.height * 2);
                
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
                self.label3.textAlignment = UITextAlignmentLeft;
                self.label4.textAlignment = UITextAlignmentLeft;
            } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
                self.label1.text = [NSString stringWithFormat:@"标题：%@", [row objectForKey:@"msg_title"]];
                self.label2.text = [NSString stringWithFormat:@"考试班级：%@", [row objectForKey:@"class_name"]];
                self.label3.text = [NSString stringWithFormat:@"考试科目：%@", [row objectForKey:@"course_name"]];
                self.label4.text = [NSString stringWithFormat:@"发送备注：%@", [[row objectForKey:@"send_remark"] isEqualToString:@"1"] ? @"是" : @"否"];
                self.label5.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"op_date"]];
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.label3.frame = CGRectMake(x, y + height * 2, width, height);
                self.label4.frame = CGRectMake(x, y + height * 3, width, height);
                self.label5.frame = CGRectMake(x, y + height * 4, width, height);
                
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
                self.label3.textAlignment = UITextAlignmentLeft;
                self.label4.textAlignment = UITextAlignmentLeft;
                self.label5.textAlignment = UITextAlignmentLeft;
//                self.labelContent.text = [row objectForKey:@"bulletin_content"];
            } else if ([self.action isEqualToString:@"selectExamReceiveMsgDetail"]) {
//                self.label1.text = [row objectForKey:@"msg_content"];
                self.label1.text = [NSString stringWithFormat:@"发送者：%@", [row objectForKey:@"user_name"]];
                self.label2.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"op_date"]];
                self.labelContent.text = [row objectForKey:@"msg_content"];
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.labelContent.frame = CGRectMake(x, y + height * 2, width, height);
                
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
//                self.label3.textAlignment = UITextAlignmentLeft;
            } else if ([self.action isEqualToString:@"reviewsConetent"]) {
                // 日常表现
                detailTitle = [row objectForKey:@"title"];
                detailTitle = [yxtUtil urlDecode:detailTitle];
                DetailContent = [row objectForKey:@"content"];
                DetailContent = [yxtUtil urlDecode:DetailContent];
                
                self.label1.text = [NSString stringWithFormat:@"发件人：%@", [row objectForKey:@"user_name"]];
                self.label2.text = detailTitle;
                self.label3.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"announce_date"]];
                self.labelContent.text = DetailContent;
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.label3.frame = CGRectMake(x, y + height * 2, width, height);
                self.labelContent.frame = CGRectMake(x, y + height * 3, width, self.view.frame.size.height - height * 3 - self.navBar.frame.size.height * 2);
                
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
                self.label3.textAlignment = UITextAlignmentLeft;
                self.label3.textColor =  [UIColor grayColor];
                self.label3.font = [UIFont systemFontOfSize:12];
            }
            
//            [self.labelContent sizeToFit];
        }
    
    // 如果是成绩信息，置为已读
    if ([self.action isEqualToString:@"selectExamReceiveMsgDetail"]) {
    }
    
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    });
}

- (void) resettle {
    // 导航栏背景图
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"backgroundNav.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // 底部按钮
    int x, y, width, height;
    x = 0;
    y = screenHeight - statusBarHeight - self.navBar.frame.size.height;
    width = screenWidth / 4 - 2;
    height = self.navBar.frame.size.height;
    self.btn1.frame = CGRectMake(x, y, width, height);
    self.btn2.frame = CGRectMake(x + width + 2, y, width, height);
    self.btn3.frame = CGRectMake(x + width * 2 + 4, y, width, height);
    self.btn4.frame = CGRectMake(x + width * 3 + 6, y, width + 2, height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resettle];
    
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
    [self setBtn1:nil];
    [self setBtn2:nil];
    [self setBtn3:nil];
    [self setBtn4:nil];
    [super viewDidUnload];
}
@end
