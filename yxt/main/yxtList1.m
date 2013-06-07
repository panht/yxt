//
//  yxtList1.m
//  yxt
//
//  Created by world ask on 13-5-29.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtList1.h"
#import "yxtDetail1.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"

@interface yxtList1 ()

@end

@implementation yxtList1

@synthesize action;
@synthesize title1;
@synthesize title2;
@synthesize data;
@synthesize pageIndex;
@synthesize pageSize;
@synthesize navTitle;
@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.pageIndex = @"1";
        self.pageSize = @"8";
    }
    
    return self;
}

- (void) setByAction: (NSString *) action {
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 设置标题栏、请求数据、表格行文本、详细页action名称
    if ([self.action isEqualToString:@"bulletin"]) {
        self.navTitle.text = @"|通知公告|列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
        self.title1 = @"msg_title";
        self.title2 = @"rec_date";
        self.actionDetail = @"bulletinContent";
    } else if ([self.action isEqualToString:@"homework"]) {
        self.navTitle.text = @"|家庭作业|列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
        self.title1 = @"ass_title";
        self.title2 = @"rec_date";
        self.actionDetail = @"homeworkContent";
    } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
        self.navTitle.text = @"|成绩信息|列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
        self.title1 = @"msg_title";
        self.title2 = @"op_date";
        self.actionDetail = @"selectExamSendMsg";
    } else if ([self.action isEqualToString:@"selectExamReceiveMsg"]) {
        self.navTitle.text = @"|成绩信息|列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"examType\":\"0\"}]"]];
        self.title1 = @"msg_content";
        self.title2 = @"rec_date";
        self.actionDetail = @"selectExamReceiveMsgDetail";
    }  else if ([self.action isEqualToString:@"reviews"]) {
        self.navTitle.text = @"|日常表现|列表信息";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\", \"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.loginType, app.userId]];
        self.title1 = @"title";
        self.title2 = @"announce_date";
        self.actionDetail = @"reviewsContent";
    }
}

- (IBAction)homeTapped:(id)sender {
    [self.view removeFromSuperview];
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1; 
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pageSize intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:CellIdentifier];
        cell=[[UITableViewCell alloc] initWithFrame: CGRectMake(0, 0, 300, 65)];
    }
    
    if (indexPath.row < [self.dataSource count]) {
        // 显示标题
        NSDictionary *row = [self.dataSource objectAtIndex:indexPath.row];  
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, 250, 15)];
        title.text = [row objectForKey:self.title1];
        [cell.contentView addSubview:title];
    
        // 显示时间
        UILabel *date = [[UILabel alloc] initWithFrame: CGRectMake(5, 26, 200, 15)];
        date.text = [row objectForKey:self.title2];
        date.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:date];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.dataSource count]) {
        self.detail1 = [[yxtDetail1 alloc] initWithNibName:@"yxtDetail1" bundle:[NSBundle mainBundle]];
        self.detail1.pageIndex = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        self.detail1.pageSize = @"1";
        self.detail1.action = self.actionDetail;
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView1.sectionFooterHeight = 0;
    self.tableView1.sectionHeaderHeight = 0;
    
    // 根据action设置相关信息
    [self setByAction:self.action];
    
    // 载入数据
    [self loadData];
    
    // 设置表格背景图
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageview setImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView1 setBackgroundView:imageview];
    
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
        // 上滑页号减1
        intPageIndex++;
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        // 下滑页号加1
        intPageIndex--;
        if (intPageIndex < 1) {
            intPageIndex = 1;
        }
    }
    
    [self setPageIndex:[NSString stringWithFormat:@"%d", intPageIndex]];
    [self loadData];
    [self.tableView1 reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView1:nil];
    [self setNavTitle:nil];
    [super viewDidUnload];
}
@end
