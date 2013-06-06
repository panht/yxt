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

@interface yxtList1 ()

@end

@implementation yxtList1

@synthesize action;
@synthesize pageIndex;
@synthesize pageSize;
//@synthesize tableView1;
@synthesize navTitle;
@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (IBAction)homeTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)backTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (void) loadData {
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.pageIndex = @"1";
    self.pageSize = @"8";
    
    // 判断action
    NSString *requestInfo;
    NSString *identityInfo;
    NSString *data;
    
//    self.action = @"bulletin";
    identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    if ([self.action isEqualToString:@"bulletin"]) {
        self.navTitle.text = @"|通知公告|列表信息";
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
    } else if ([self.action isEqualToString:@"homework"]) {
        self.navTitle.text = @"|家庭作业|列表信息";
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
    } else if ([self.action isEqualToString:@"selectExam"]) {
        self.navTitle.text = @"|成绩信息|列表信息";
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"examType\":\"0\"}]"]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
    } else if ([self.action isEqualToString:@"reviews"]) {
        self.navTitle.text = @"|日常表现|列表信息";
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\", \"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.loginType, app.userId]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :data]];
    }
    
    // 从服务端获取数据
//    NSLog(@"%@", requestInfo);
//        NSLog(@"%@", identityInfo);
//        NSLog(@"%@", data);
    NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
    
    if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
        NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                   options:kNilOptions
                                                                     error:&error];
        
        NSArray *data = [jsonList objectForKey:@"list"];
        self.dataSource = data;

//        for(int i=0; i < [data count]; i++) {
//            NSLog(@"value%d : %@", i, [data objectAtIndex:i]);
//        }
        
    }
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
        NSString *title1, *title2;
        if ([self.action isEqualToString:@"bulletin"]) {
            title1 = @"msg_title";
            title2 = @"rec_date";
        } else if ([self.action isEqualToString:@"homework"]) {
            title1 = @"course_name";
            title2 = @"rec_date";
        } else if ([self.action isEqualToString:@"selectExam"]) {
            title1 = @"msg_title";
            title2 = @"rec_date";
        } else if ([self.action isEqualToString:@"reviews"]) {
            title1 = @"title";
            title2 = @"announce_date";
        }

        
        // 显示标题
        NSDictionary *row = [self.dataSource objectAtIndex:indexPath.row];  
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, 250, 15)];
        title.text = [row objectForKey:title1];
        [cell.contentView addSubview:title];
    
        // 显示时间
        UILabel *date = [[UILabel alloc] initWithFrame: CGRectMake(5, 26, 200, 15)];
        date.text = [row objectForKey:title2];
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
        self.detail1.action = [NSString stringWithFormat:@"%@Content", self.action];
        
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
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView1:nil];
//    [self setTitle:nil];
    [self setNavTitle:nil];
    [super viewDidUnload];
}
@end
