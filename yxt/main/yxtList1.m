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

@synthesize recordcount;
@synthesize lastOffsetY;
@synthesize flagLoadNext;
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
        self.type = @"inbox";
        self.role = @"teacher";
        
        int screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if (screenHeight == 568) {
            self.pageSize = @"10";
        } else {
            self.pageSize = @"8";
        }
    }
    
    return self;
}

- (void) setByAction: (NSString *) action {
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *boxtype;
    
    // 默认隐藏按钮
    [self.btn0 setHidden:YES];
    [self.btn1 setHidden:YES];
    [self.btn2 setHidden:YES];
    
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // 表格视图位置
    int xTableView1, yTableView1, widthTableView1, heightTableView1;
    xTableView1 = 0;
    yTableView1 = self.navBar.frame.size.height;
    widthTableView1 = screenWidth;
    heightTableView1 = screenHeight - self.navBar.frame.size.height;
    
    // 如果是教师
    if ([app.loginType isEqualToString:@"1"]) {
        // 底部按钮位置
        int x, y, width, height;
        x = 0;
        y = screenHeight - statusBarHeight - self.navBar.frame.size.height;
        width = self.view.frame.size.width / 2;
        height = self.navBar.frame.size.height;
        
        if ([self.action isEqualToString:@"bulletin"]) {
            self.pageSize = @"7";
            
            // 通知公告栏目，显示发送按钮
            [self.btn0 setHidden:NO];
            
            self.btn1.frame = CGRectMake(x, y, width, height);
            self.btn2.frame = CGRectMake(x + width, y, width, height);
            
            // 为教师时，通知公告显示收发件箱
            [self.btn1 setHidden:NO];
            [self.btn2 setHidden:NO];
            
            // 表格视图位置
            yTableView1 += self.btn0.frame.size.height + 10;
            heightTableView1 -= self.btn0.frame.size.height + 10 + self.btn1.frame.size.height;
        } else if ([self.action isEqualToString:@"eduClass"]) {
        } else {
            self.btn1.frame = CGRectMake(x, y, width * 2, height);
            
            if ([self.action isEqualToString:@"homework"]) {
                [self.btn1 setTitle:@"发送作业" forState:UIControlStateNormal];
            } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
                [self.btn1 setTitle:@"发送成绩" forState:UIControlStateNormal];
            } else if ([self.action isEqualToString:@"reviews"]) {
                [self.btn1 setTitle:@"发送日常表现" forState:UIControlStateNormal];
            }
            
            [self.btn1 setHidden:NO];
            
            // 表格视图高度
            heightTableView1 -= self.btn1.frame.size.height;
        }
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
//        if ([app.loginType isEqualToString:@"1"]) {
//            // 收、发件箱按钮调整
//            int x, y, width, height;
//            x = 0;
//            y = screenHeight - statusBarHeight - self.navBar.frame.size.height;
//            width = self.view.frame.size.width / 2;
//            height = self.navBar.frame.size.height;
//            self.btn1.frame = CGRectMake(x, y, width, height);
//            self.btn2.frame = CGRectMake(x + width, y, width, height);
//            
//            // 为教师时，通知公告显示收发件箱
//            if ([app.loginType isEqualToString:@"1"]) {
//                [self.btn1 setHidden:NO];
//                [self.btn2 setHidden:NO];
//            }
//            
//            // 表格视图高度
//            heightTableView1 -= self.btn1.frame.size.height;
//        }
    } else if ([self.action isEqualToString:@"homework"]) {
        if ([app.loginType isEqualToString:@"1"]) {
            boxtype = @"outbox";
        } else {
            boxtype = @"inbox";
        }
        
        self.navTitle.title = @"家庭作业 >> 列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", boxtype, app.userId]];
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
        self.title1 = @"student_name";
        self.title2 = @"op_date";
        self.actionDetail = @"selectExamReceiveMsgDetail";
    }  else if ([self.action isEqualToString:@"reviews"]) {
        if ([app.loginType isEqualToString:@"1"]) {
            boxtype = @"outbox";
        } else {
            boxtype = @"inbox";
        }
        
        self.navTitle.title = @"日常表现 >> 列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"logintype\":\"%@\", \"boxtype\":\"%@\", \"userid\":\"%@\"}]", app.loginType, boxtype, app.userId]];
        self.title1 = @"title";
        self.title2 = @"announce_date";
        self.actionDetail = @"reviewsConetent";
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *requestInfo;
        NSString *identityInfo;
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :self.data]];
        
//        NSLog(@"%@", requestInfo);
//        NSLog(@"%@", identityInfo);
//        NSLog(@"%@", self.data);
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :self.data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            if ([dataResponse objectForKey:@"recordcount"] != nil) {
                self.recordcount = [[dataResponse objectForKey:@"recordcount"] integerValue];
            } else {
                self.recordcount = 0;
            }
            NSArray *dataListArray = [jsonList objectForKey:@"list"];
            
            // 将数据合并到原数组中
            NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
            if ([self.dataSource count] > 0){
                arrayTemp = [self.dataSource mutableCopy];
            }
            [arrayTemp addObjectsFromArray:dataListArray];
            self.dataSource = [arrayTemp mutableCopy];
            [self.tableView1 reloadData];
        }
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.frame = CGRectMake(5, 0, 300, 65);
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.row < [self.dataSource count]) {
        NSDictionary *rowData = [self.dataSource objectAtIndex:indexPath.row];
        NSInteger heightTitle1;
        
        // 有没有副标题，主标题高度不同
        if (![self.title2 isEqualToString:@""]) {
            heightTitle1 = 15;
        } else {
            heightTitle1 = 35;
        }
        UILabel *text1 = [[UILabel alloc] init];
        UILabel *text2 = [[UILabel alloc] init];
        UILabel *date = [[UILabel alloc] init];
        
        // 通知公告和家庭作业图标
        if ([self.action isEqualToString:@"bulletin"] || [self.action isEqualToString:@"homework"] || [self.action isEqualToString:@"eduClass"]) {
            // 主、副标题位置
            text1.frame = CGRectMake(5, 5, 250, heightTitle1);
            date.frame = CGRectMake(5, 26, 200, 15);
            
            // 右方箭头图标
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowLeft1.png"]];
            image.frame = CGRectMake(300, 12, 14, 20);
            [cell.contentView addSubview:image];
        } else if ([self.action isEqualToString:@"selectExamSendMsg"] || [self.action isEqualToString:@"selectExamReceiveMsg"] || [self.action isEqualToString:@"reviews"]) {
            // 主、副标题位置
            text1.frame = CGRectMake(25, 5, 250, heightTitle1);
            text2.frame = CGRectMake(5, 26, 180, 15);
            date.frame = CGRectMake(200, 26, 120, 15);
            
            // 添加副标题，已读未读图标文件名
            NSString *imageName = @"messageRead.png";
            if ([self.action isEqualToString:@"selectExamSendMsg"]) {
                text2.text = [NSString stringWithFormat:@"考试班级:%@考试科目:%@", [rowData objectForKey:@"class_name"], [rowData objectForKey:@"course_name"]];
                
            } else if ([self.action isEqualToString:@"selectExamReceiveMsg"]) {
                text2.text = [yxtUtil replacePercent: [rowData objectForKey:@"msg_content"]];
                if ([[rowData objectForKey:@"is_read"] isEqualToString:@"0"]) {
                    imageName = @"messageUnread.png";
                }
            } else if ([self.action isEqualToString:@"reviews"]) {
                text2.text = [yxtUtil replacePercent: [rowData objectForKey:@"content"]];
            }
            text2.font = [UIFont boldSystemFontOfSize:12];
            text2.textColor = [UIColor grayColor];
            [cell.contentView addSubview:text2];
            
            // 左方已读未读图标
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            image.frame = CGRectMake(5, 5, 18, 14);
            [cell.contentView addSubview:image];
        }
        
        // 显示副标题
        if (![self.title2 isEqualToString:@""]) {
            date.text = [yxtUtil replacePercent: [rowData objectForKey:self.title2]];
            date.font = [UIFont boldSystemFontOfSize:12];
            date.textColor = [UIColor grayColor];
            [cell.contentView addSubview:date];
        } 
        
        // 显示主标题
        text1.text = [yxtUtil replacePercent: [rowData objectForKey:self.title1]];
        if ([self.action isEqualToString:@"homework"]) {
            text1.text = [text1.text stringByAppendingFormat:@"作业"];
        } else if ([self.action isEqualToString:@"selectExamReceiveMsg"]) {
            text1.text = [text1.text stringByAppendingFormat:@"家长"];
        }
        [cell.contentView addSubview:text1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.row < [self.dataSource count]) {
        // 获得屏幕宽高
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        int screenHeight = [[UIScreen mainScreen] bounds].size.height;
//        int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        
        if ([self.action isEqualToString:@"eduClass"]) {
            // 为班级成员时，打开list2
            self.list2 = [[yxtList2 alloc] initWithNibName:@"yxtList2" bundle:[NSBundle mainBundle]];
            NSDictionary *rowData = [self.dataSource objectAtIndex:indexPath.row];
            self.list2.classid = [rowData objectForKey:@"value"];
            
            // 设置子视图高度
            int x, y, width, height;
            x = 0;
            y = 30;
            width = screenWidth;
            height = screenHeight;
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
            width = screenWidth;
            height = screenHeight;
            self.detail1.view.frame = CGRectMake(x, y, width, height);
            
            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
            self.detail1.view.tag = 400;
            [topWindow addSubview: self.detail1.view];
        }
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.flagLoadNext = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.flagLoadNext = NO;
    if (self.lastOffsetY < scrollView.contentOffset.y) {
        self.lastOffsetY = scrollView.contentOffset.y;
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获得屏高
//    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
//    NSLog(@"%f", scrollView.contentOffset.y);
    // 如果向上拖动超过屏高三分之一，并且flagLoadNext = YES
    if (scrollView.contentOffset.y - self.lastOffsetY  > 0 && self.flagLoadNext == YES && [self.tableView1 numberOfRowsInSection:0] < self.recordcount) {
        NSInteger intPageIndex = [self.pageIndex integerValue];
        intPageIndex++;
        
        [self setPageIndex:[NSString stringWithFormat:@"%d", intPageIndex]];
        [self loadData];
        self.flagLoadNext = NO;
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
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    // 载入数据
    [self loadData];
}

- (IBAction)homeTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)backTapped:(id)sender {
    [self.view removeFromSuperview];
}

// 点击发件箱或按钮一
- (IBAction)btn1Tapped:(id)sender {
    if ([self.action isEqualToString:@"bulletin"]) {
        // 上次y坐标值后清0，否则切换后不能翻页
        self.lastOffsetY = 0;
        
        self.image12 = [UIImage imageNamed:@"list1Bulletin12.png"];
        self.image21 = [UIImage imageNamed:@"list1Bulletin21.png"];
        [self.btn1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:self.image21 forState:UIControlStateNormal];
        
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.type = @"outbox";
        self.dataSource = nil;
        self.pageIndex = @"1";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", self.type, app.userId]];
        
        [self loadData];
    } else {
        // 打开通用表单
        self.form = [[yxtForm alloc] initWithNibName:@"yxtForm" bundle:[NSBundle mainBundle]];
        
        if ([self.action isEqualToString:@"homework"]) {
            self.form.xibName = @"yxtForm2";
        } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
            self.form.xibName = @"yxtForm3";
        } else if ([self.action isEqualToString:@"reviews"]) {
            self.form.xibName = @"yxtForm4";
        }
        
        // 获得屏幕宽高
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        int screenHeight = [[UIScreen mainScreen] bounds].size.height;
        int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        
        // 设置子视图高度
        int x, y, width, height;
        x = 0;
        y = statusBarHeight;
        width = screenWidth;
        height = screenHeight - statusBarHeight;
        self.form.view.frame = CGRectMake(x, y, width, height);
        self.form.view.tag = 400;
        
        UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
        [topWindow addSubview: self.form.view];
        [topWindow makeKeyAndVisible];
    }
}

// 点击收件箱
- (IBAction)btn2Tapped:(id)sender {
    if ([self.action isEqualToString:@"bulletin"]) {
        // 上次y坐标值后清0，否则切换后不能翻页
        self.lastOffsetY = 0;
        
        self.image11 = [UIImage imageNamed:@"list1Bulletin11.png"];
        self.image22 = [UIImage imageNamed:@"list1Bulletin22.png"];
        [self.btn1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:self.image22 forState:UIControlStateNormal];
        
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.type = @"inbox";
        self.dataSource = nil;
        self.pageIndex = @"1";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", self.type, app.userId]];
        
        [self loadData];
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
    
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // 设置子视图高度
    int x, y, width, height;
    x = 0;
    y = statusBarHeight;
    width = screenWidth;
    height = screenHeight - statusBarHeight;
    self.form.view.frame = CGRectMake(x, y, width, height);
    self.form.view.tag = 400;
    
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
