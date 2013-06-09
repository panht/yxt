//
//  yxtList1.m
//  yxt
//
//  Created by panht on 13-5-29.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtList1.h"
#import "yxtList2.h"
#import "yxtDetail1.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"
#import "yxtForm.h"
#import "yxtForm1.h"

@interface yxtList1 ()

@end

@implementation yxtList1

@synthesize action;
@synthesize type;
@synthesize role;
@synthesize classid;
@synthesize title1;
@synthesize title2;
@synthesize data;
@synthesize pageIndex;
@synthesize pageSize;
@synthesize navTitle;
@synthesize dataSource;

@synthesize image11;
@synthesize image12;
@synthesize image21;
@synthesize image22;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageIndex = @"1";
        self.pageSize = @"8";
        self.type = @"inbox";
        self.role = @"teacher";
    }
    
    return self;
}

- (void) setByAction: (NSString *) action {
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 默认隐藏按钮
    [self.btn0 setHidden:YES];
    [self.btn1 setHidden:YES];
    [self.btn2 setHidden:YES];
    
    // 表格视图位置
    int xTableView1, yTableView1, widthTableView1, heightTableView1;
    xTableView1 = 0;
    yTableView1 = self.navBar.frame.size.height;
    widthTableView1 = self.view.frame.size.width;
    heightTableView1 = self.view.frame.size.height - self.navBar.frame.size.height;
    
    
    // 如果是教师，且不是班级成员栏目，显示发送按钮
    if ([app.loginType isEqualToString:@"1"] && ![self.action isEqualToString:@"eduClass"]) {
        [self.btn0 setHidden:NO];
        
        // 表格视图位置
        yTableView1 += self.btn0.frame.size.height + 10;
        heightTableView1 -= self.btn0.frame.size.height + 10;
    } 
    
    // 设置标题栏、请求数据、表格行文本、详细页action名称
    if ([self.action isEqualToString:@"bulletin"]) {
        // 通知公告
        self.navTitle.title = @"通知公告 >> 列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", self.type, app.userId]];
        self.title1 = @"msg_title";
        self.title2 = @"rec_date";
        self.actionDetail = @"bulletinContent";
        
        // 如果是教师，显示收、发件箱按钮
        if ([app.loginType isEqualToString:@"1"]) {
            // 收、发件箱按钮调整
            int x, y, width, height;
            x = 0;
            y = self.view.frame.size.height - self.navBar.frame.size.height - 20;
            width = self.view.frame.size.width / 2;
            height = self.navBar.frame.size.height;
            self.btn1.frame = CGRectMake(x, y, width, height);
            self.btn2.frame = CGRectMake(x + width, y, width, height);
            
            // 为教师时，通知公告显示收发件箱
            if ([app.loginType isEqualToString:@"1"]) {
                [self.btn1 setHidden:NO];
                [self.btn2 setHidden:NO];
            }
            
            // 表格视图高度
            heightTableView1 -= self.btn1.frame.size.height;
        }
    } else if ([self.action isEqualToString:@"homework"]) {
        self.navTitle.title = @"家庭作业 >> 列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
        self.title1 = @"course_name";
        self.title2 = @"rec_date";
        self.actionDetail = @"homeworkContent";
    } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
        self.navTitle.title = @"成绩信息 >> 列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
        self.title1 = @"msg_title";
        self.title2 = @"op_date";
        self.actionDetail = @"selectExamSendMsg";
    } else if ([self.action isEqualToString:@"selectExamReceiveMsg"]) {
        self.navTitle.title = @"成绩信息 >> 列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"examType\":\"0\"}]"]];
        self.title1 = @"msg_content";
        self.title2 = @"rec_date";
        self.actionDetail = @"selectExamReceiveMsgDetail";
    }  else if ([self.action isEqualToString:@"reviews"]) {
        self.navTitle.title = @"日常表现 >> 列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"logintype\":\"%@\", \"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.loginType, app.userId]];
        self.title1 = @"title";
        self.title2 = @"announce_date";
        self.actionDetail = @"reviewsContent";
    }  else if ([self.action isEqualToString:@"eduClass"]) {
        self.navTitle.title = @"班级成员 >> 班级选择";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\"}]", app.userId]];
        self.title1 = @"name";
        self.title2 = @"";
    }
    
    // 重画表格
    self.tableView1.frame = CGRectMake(xTableView1, yTableView1, widthTableView1, heightTableView1);
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
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            
            NSArray *dataListArray = [jsonList objectForKey:@"list"];
            self.dataSource = dataListArray;
            
            //        for(int i=0; i < [data count]; i++) {
            //            NSLog(@"value%d : %@", i, [data objectAtIndex:i]);
            //        }
        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pageSize intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:CellIdentifier];
        cell=[[UITableViewCell alloc] initWithFrame: CGRectMake(5, 0, 300, 65)];
    }
    
    if (indexPath.row < [self.dataSource count]) {
        NSDictionary *rowData = [self.dataSource objectAtIndex:indexPath.row];
        NSInteger heightTitle1;
        
        // 显示副标题
        if (![self.title2 isEqualToString:@""]) {
            UILabel *date = [[UILabel alloc] initWithFrame: CGRectMake(5, 26, 200, 15)];
            date.text = [rowData objectForKey:self.title2];
            date.font = [UIFont boldSystemFontOfSize:12];
            date.textColor = [UIColor grayColor];
            [cell.contentView addSubview:date];
            
            heightTitle1 = 15;
        } else {
            heightTitle1 = 35;
        }
        
        // 显示标题
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, 250, heightTitle1)];
        title.text = [rowData objectForKey:self.title1];
        [cell.contentView addSubview:title]; 
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.dataSource count]) {
        if ([self.action isEqualToString:@"eduClass"]) {
            // 为班级成员时，打开list2
            self.list2 = [[yxtList2 alloc] initWithNibName:@"yxtList2" bundle:[NSBundle mainBundle]];
            NSDictionary *rowData = [self.dataSource objectAtIndex:indexPath.row];
            self.list2.classid = [rowData objectForKey:@"value"];
            
            // 设置子视图高度
            int x, y, width, height;
            x = 0;
            y = 30;
            width = self.list2.view.frame.size.width;
            height = self.list2.view.frame.size.height;
            self.list2.view.frame = CGRectMake(x, y, width, height);
            
            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
            self.list2.view.tag = 400;
            [topWindow addSubview: self.list2.view];
            [topWindow makeKeyAndVisible];
        } else {
            // 正常打开detail1
            self.detail1 = [[yxtDetail1 alloc] initWithNibName:@"yxtDetail1" bundle:[NSBundle mainBundle]];
            self.detail1.pageIndex = [NSString stringWithFormat:@"%d", indexPath.row + 1];
            self.detail1.pageSize = @"1";
            
            // 设置参数
            self.detail1.action = self.actionDetail;
            self.detail1.type = self.type;
            
            // 设置子视图高度
            int x, y, width, height;
            x = 0;
            y = 20;
            width = self.detail1.view.frame.size.width;
            height = self.detail1.view.frame.size.height;
            self.detail1.view.frame = CGRectMake(x, y, width, height);
            
            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
            self.detail1.view.tag = 400;
            [topWindow addSubview: self.detail1.view];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    self.image11 = [UIImage imageNamed:@"list1Bulletin11.png"];
    self.image12 = [UIImage imageNamed:@"list1Bulletin12.png"];
    self.image21 = [UIImage imageNamed:@"list1Bulletin21.png"];
    self.image22 = [UIImage imageNamed:@"list1Bulletin22.png"];
    
    // 导航栏背景图
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"backgroundNav.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置表格背景图
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageview setImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView1 setBackgroundView:imageview];
    
    self.tableView1.sectionFooterHeight = 0;
    self.tableView1.sectionHeaderHeight = 0;
    
    // 根据action设置相关信息
    [self setByAction:self.action];
    
    // 载入数据
    [self loadData];
    
    // 手势事件
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self tableView1] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self tableView1] addGestureRecognizer:recognizer];
}

// 上下滑动手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSInteger intPageIndex = [self.pageIndex integerValue];
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        // 上滑页号加1
        intPageIndex++;
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        // 下滑页号减1
        intPageIndex--;
        if (intPageIndex < 1) {
            intPageIndex = 1;
        }
    }
    
    [self setPageIndex:[NSString stringWithFormat:@"%d", intPageIndex]];
    [self loadData];
    [self.tableView1 reloadData];
}

- (IBAction)homeTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)backTapped:(id)sender {
    [self.view removeFromSuperview];
}

// 点击发件箱
- (IBAction)btn1Tapped:(id)sender {
    if ([self.action isEqualToString:@"bulletin"]) {
        [self.btn1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
        
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.type = @"outbox";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", self.type, app.userId]];
        
        [self loadData];
        [self.tableView1 reloadData];
    }
}

// 点击收件箱
- (IBAction)btn2Tapped:(id)sender {
    if ([self.action isEqualToString:@"bulletin"]) {
        [self.btn1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:self.image22 forState:UIControlStateNormal];
        
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.type = @"inbox";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", self.type, app.userId]];
        
        [self loadData];
        [self.tableView1 reloadData];
    }
}

// 发送
- (IBAction)btn0Tapped:(id)sender {
    // 打开通用表单
    self.form = [[yxtForm alloc] initWithNibName:@"yxtForm" bundle:[NSBundle mainBundle]];
    
    if ([self.action isEqualToString:@"bulletin"]) {
        self.form.xibName = @"yxtForm1";
    } else if ([self.action isEqualToString:@"homework"]) {
        self.form.xibName = @"yxtForm2";
    } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
        self.form.xibName = @"yxtForm3";
    } else if ([self.action isEqualToString:@"reviews"]) {
        self.form.xibName = @"yxtForm4";
    }

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView1:nil];
    [self setNavTitle:nil];
    [self setBtn0:nil];
    [self setBtn1:nil];
    [self setBtn2:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end
