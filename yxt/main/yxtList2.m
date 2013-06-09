//
//  yxtList2.m
//  yxt
//
//  Created by world ask on 13-6-9.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtList2.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"

@interface yxtList2 ()

@end

@implementation yxtList2

@synthesize data;
@synthesize role;
@synthesize classid;
@synthesize pageIndex;
@synthesize pageSize;
@synthesize navTitle;
@synthesize dataSource;

@synthesize image11;
@synthesize image12;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageIndex = @"1";
        self.pageSize = @"8";
        self.role = @"teacher";
    }
    
    return self;
}

- (void) loadData {
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    NSString *requestInfo;
    NSString *identityInfo;
    
    identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"membertype\":\"%@\", \"classid\":\"%@\"}]", self.role, self.classid]];
    requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"members" :self.pageIndex :self.pageSize :identityInfo :self.data]];
    
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
        cell=[[UITableViewCell alloc] initWithFrame: CGRectMake(5, 0, 300, 65)];
    }
    
    if (indexPath.row < [self.dataSource count]) {
        // 显示标题
        NSDictionary *rowData = [self.dataSource objectAtIndex:indexPath.row];
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(5, 5, 250, 15)];
        title.text = [rowData objectForKey:@"user_name"];
        [cell.contentView addSubview:title];
        
        UILabel *date = [[UILabel alloc] initWithFrame: CGRectMake(5, 26, 200, 15)];
        date.text = [NSString stringWithFormat:@"%@  %@", [rowData objectForKey:@"header_title"],  [rowData objectForKey:@"course_name"]];
        date.font = [UIFont boldSystemFontOfSize:12];
        date.textColor = [UIColor grayColor];
        [cell.contentView addSubview:date];
        
        NSString *phoneNo = [rowData objectForKey:@"mobilephone"];
        
        // 有号码的，显示电话与短信图标
        if (![phoneNo isEqualToString:@""]) {
            UIButton *btnPhonecall = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnPhonecall setImage:[UIImage imageNamed:@"phonecall.png"] forState:UIControlStateNormal];
            btnPhonecall.frame = CGRectMake(230, 5, 30, 30);
            btnPhonecall.tag = indexPath.row;
            [btnPhonecall setBackgroundColor:[UIColor clearColor]];
            [btnPhonecall addTarget:self action:@selector(phoneTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnPhonecall];
            
            UIButton *btnSMS = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnSMS setImage:[UIImage imageNamed:@"sms.png"] forState:UIControlStateNormal];
            btnSMS.frame = CGRectMake(270, 5, 30, 30);
            btnSMS.tag = indexPath.row;
            [btnSMS setBackgroundColor:[UIColor clearColor]];
            [btnSMS addTarget:self action:@selector(smsTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnSMS];
//            UIImage *imagePhonecall = [UIImage imageNamed:@"phonecall.png"];
//            UIImageView *imageViewPhonecall = [[UIImageView alloc] initWithImage:imagePhonecall];
//            imageViewPhonecall.frame = CGRectMake(230, 5, 30, 30);
//            [imageViewPhonecall setUserInteractionEnabled:YES];
//            [cell.contentView addSubview:imageViewPhonecall];
//            
//            UITapGestureRecognizer *gestureCall = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneTapped)];
//            imageViewPhonecall.userInteractionEnabled = YES;
//            [imageViewPhonecall addGestureRecognizer:gestureCall];
        }
    }
    
    return cell;
}

- (void) phoneTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSDictionary *rowData = [self.dataSource objectAtIndex:button.tag];
    NSString *phoneNo = [rowData objectForKey:@"mobilephone"];
    NSString *callNo = [NSString stringWithFormat:@"tel://%@", phoneNo];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callNo]];
}

- (void) smsTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSDictionary *rowData = [self.dataSource objectAtIndex:button.tag];
    NSString *phoneNo = [rowData objectForKey:@"mobilephone"];
    NSString *smsNo = [NSString stringWithFormat:@"sms://%@", phoneNo];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:smsNo]];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row < [self.dataSource count]) {
//        
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navTitle.title = @"班级成员 >> 详细内容";
    
    self.image11 = [UIImage imageNamed:@"list1Bulletin11.png"];
    self.image12 = [UIImage imageNamed:@"list1Bulletin12.png"];
    
    // 导航栏背景图
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"backgroundNav.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置表格背景图
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageview setImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView1 setBackgroundView:imageview];
    
    self.tableView1.sectionFooterHeight = 0;
    self.tableView1.sectionHeaderHeight = 0;
    
    [self resettle];
    
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

// 整理班级成员列表界面
- (void) resettle {
    // 底部按钮调整
    [self.btn1 setTitle:@"学校教师" forState:UIControlStateNormal];
    [self.btn2 setTitle:@"学生" forState:UIControlStateNormal];
    [self.btn3 setTitle:@"家长" forState:UIControlStateNormal];
    [self.btn1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:self.image11 forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:self.image11 forState:UIControlStateNormal];
    [self.btn1 setHidden:NO];
    [self.btn2 setHidden:NO];
    [self.btn3 setHidden:NO];
    
    int x, y, width, height;
    x = 0;
    y = self.view.frame.size.height - self.navBar.frame.size.height;
    width = self.view.frame.size.width / 3;
    height = self.navBar.frame.size.height;
    self.btn1.frame = CGRectMake(x, y, width, height);
    self.btn2.frame = CGRectMake(x + width, y, width, height);
    self.btn3.frame = CGRectMake(x + width * 2, y, width, height);
//    self.view.frame = CGRectMake(x, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height * 2);
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
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *list1View = [topWindow viewWithTag:300];
    [self.view removeFromSuperview];
    [list1View removeFromSuperview];
}

- (IBAction)backTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)btn1Tapped:(id)sender {
    [self.btn1 setBackgroundImage:self.image12 forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:self.image11 forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:self.image11 forState:UIControlStateNormal];
    
    self.role = @"teacher";
    self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"membertype\":\"%@\", \"classid\":\"%@\"}]", self.role, self.classid]];
    
    [self loadData];
    [self.tableView1 reloadData];
}

- (IBAction)btn2Tapped:(id)sender {
    [self.btn1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:self.image12 forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:self.image11 forState:UIControlStateNormal];
    
    self.role = @"student";
    self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"membertype\":\"%@\", \"classid\":\"%@\"}]", self.role, self.classid]];
    
    [self loadData];
    [self.tableView1 reloadData];
}

- (IBAction)btn3Tapped:(id)sender {
    [self.btn1 setBackgroundImage:self.image11 forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:self.image11 forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:self.image12 forState:UIControlStateNormal];
    
    self.role = @"partent";
    self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"membertype\":\"%@\", \"classid\":\"%@\"}]", self.role, self.classid]];
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
    [self setBtn1:nil];
    [self setBtn2:nil];
    [self setNavBar:nil];
    [self setBtn3:nil];
    [super viewDidUnload];
}
@end
