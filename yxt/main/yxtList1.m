//
//  yxtList1.m
//  yxt
//
//  Created by world ask on 13-5-29.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtList1.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"

@interface yxtList1 ()

@end

@implementation yxtList1

@synthesize tableView1;
@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self loadData];
    }
    return self;
}

- (void) loadData {
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 从服务端获取数据
    NSString *identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
    NSString *data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"inbox\", \"userid\":\"%@\"}]", app.userId]];
    NSString *requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"bulletin" :@"0" :@"5" :identityInfo :data]];
    NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
    
//    NSLog(@"%@", requestInfo);
//    NSLog(@"%@", identityInfo);
//    NSLog(@"%@", data);
    // 如果返回成功代码
//    NSError *error;
//    NSDictionary* jsonResult;
    if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
        NSString *list = @"{\"list\":[{\"msg_title\":\"测试通知11111111\",\"rec_date\":\"2012-11-28 11:10:35\"},{\"msg_title\":\"学校通知学生\",\"rec_date\":\"2012-11-28 10:23:09\"},{\"msg_title\":\"学校通知家长\",\"rec_date\":\"2012-11-28 10:22:52\"},{\"msg_title\":\"教师通知班级通知\",\"rec_date\":\"2012-11-7 15:27:15\"},{\"msg_title\":\"测试通知\",\"rec_date\":\"2012-11-1 10:55:18\"},{\"msg_title\":\"学校通知学生\",\"rec_date\":\"2012-11-28 10:23:09\"},{\"msg_title\":\"学校通知家长\",\"rec_date\":\"2012-11-28 10:22:52\"},{\"msg_title\":\"教师通知班级通知\",\"rec_date\":\"2012-11-7 15:27:15\"},{\"msg_title\":\"测试通知\",\"rec_date\":\"2012-11-1 10:55:18\"},{\"msg_title\":\"学校通知学生\",\"rec_date\":\"2012-11-28 10:23:09\"},{\"msg_title\":\"学校通知家长\",\"rec_date\":\"2012-11-28 10:22:52\"},{\"msg_title\":\"教师通知班级通知\",\"rec_date\":\"2012-11-7 15:27:15\"},{\"msg_title\":\"测试通知\",\"rec_date\":\"2012-11-1 10:55:18\"},{\"msg_title\":\"学校通知学生\",\"rec_date\":\"2012-11-28 10:23:09\"},{\"msg_title\":\"学校通知家长\",\"rec_date\":\"2012-11-28 10:22:52\"},{\"msg_title\":\"教师通知班级通知\",\"rec_date\":\"2012-11-7 15:27:15\"},{\"msg_title\":\"测试通知\",\"rec_date\":\"2012-11-1 10:55:18\"},{\"msg_title\":\"学校通知学生\",\"rec_date\":\"2012-11-28 10:23:09\"},{\"msg_title\":\"学校通知家长\",\"rec_date\":\"2012-11-28 10:22:52\"},{\"msg_title\":\"教师通知班级通知\",\"rec_date\":\"2012-11-7 15:27:15\"},{\"msg_title\":\"测试通知\",\"rec_date\":\"2012-11-1 10:55:18\"}]}";
//        
        
        NSData *dataList = [list dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                   options:kNilOptions
                                                                     error:&error];
        
        NSArray *data = [jsonList objectForKey:@"list"];

//        for(int i=0; i < [data count]; i++) {
//            NSLog(@"value%d : %@", i, [data objectAtIndex:i]);
//        }
        
        self.dataSource = data;
//        NSLog(@"data: %@", self.dataSource);

    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1; 
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
//    NSLog(@"%i", indexPath.row);
//    NSLog(@"%@", [self.dataSource objectAtIndex:indexPath.row]);
    NSDictionary *row = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [row objectForKey:@"msg_title"];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView1:nil];
    [super viewDidUnload];
}
@end
