//
//  yxtForm2.m
//  yxt
//
//  Created by panht on 13-6-8.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtForm2.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface yxtForm2 ()

@end

@implementation yxtForm2

@synthesize dataSource;
@synthesize dataListArray;
//@synthesize picker;

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
    
    // 隐藏 picker
    [self.picker setHidden:YES];
    
    // 重新布局、初始值
    [self resettle];
    [self loadData];
}

- (void) resettle {
    // 作业课程、内容边框
    self.inputCourse.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputCourse.layer.borderWidth = 1.0;
    self.inputContent.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputContent.layer.borderWidth = 1.0;
    
    // picker添加点击事件
    UITapGestureRecognizer *pickerTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePicker)];
    [self.picker addGestureRecognizer:pickerTapped];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 获取作业课程
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\"}]", app.userId]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"classCourse" :@"1" :@"100" :identityInfo :data]];
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            
            self.dataListArray = [jsonList objectForKey:@"list"];
            NSDictionary *row = [self.dataListArray objectAtIndex:0];
            
            // 作业课程初始值
            [self.inputCourse setTitle:[row objectForKey:@"name"] forState:UIControlStateNormal];
            [self.inputCourse setTag:[[row objectForKey:@"value"] integerValue]];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)send:(id)sender {
    // 校验必填项
    if ([self.inputTitle.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入作业标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    } else if ([self.inputContent.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // 保存
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *courseid = [NSString stringWithFormat:@"%d", self.inputCourse.tag];
        NSString *coursename = self.inputCourse.currentTitle;
        NSString *chksms = self.inputSMS.on ? @"1" : @"0";
        NSString *blocflag = self.inputWeibo.on ? @"1" : @"0";
        NSString *files = @"";
        
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\", \"assTitle\":\"%@\", \"assContent\":\"%@\", \"classCourse\":\"%@\", \"chksms\":\"%@\", \"userName\":\"%@\", \"classCourseName\":\"%@\", \"blocToken\":\"%@\", \"userAccount\":\"%@\", \"blocFlag\":\"%@\", \"Files\":\"%@\"}]", app.userId, self.inputTitle.text, self.inputContent.text, courseid, chksms, app.username, coursename, app.token, app.userId, blocflag, files]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"addHomeWork" :@"0" :@"0" :identityInfo :data]];
        NSLog(@"requestInfo   %@", requestInfo);
        NSLog(@"identityInfo   %@", identityInfo);
        NSLog(@"data   %@", data);
        
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dataResponse objectForKey:@"resultdes"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)courseTapped:(id)sender {
    self.dataSource = self.dataListArray;
    [self.picker setTag:1];
    [self.picker setHidden:NO];
    [self.picker reloadAllComponents];
}

#pragma mark Picker Data Soucrce Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    //Picker里有几个竖的栏目就返回几
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //picker中的选项有几个
    return [self.dataSource count];
}

// 点击picker返回选中项
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *result;
    
    if (row < [self.dataSource count]) {
        // 显示标题
        if (self.picker.tag == 1) {
            NSDictionary *rowData = [self.dataSource objectAtIndex:row];
            result = [rowData objectForKey:@"name"];
            [self.inputCourse setTag:[[rowData objectForKey:@"value"] integerValue]];
        }
    }
    
    return result;
}

// 点击关闭picker
- (void) closePicker {
    NSInteger row = [self.picker selectedRowInComponent:0];
    
    if (self.picker.tag == 1) {
        NSDictionary *value = [self.dataSource objectAtIndex:row];
        [self.inputCourse setTitle:[value objectForKey:@"name"]  forState:UIControlStateNormal];
    }
    
    [self.picker setHidden:YES];
}

- (void)viewDidUnload {
    [self setInputCourse:nil];
    [self setInputTitle:nil];
    [self setInputSMS:nil];
    [self setInputWeibo:nil];
    [self setInputContent:nil];
    [self setPicker:nil];
    [self setImageBackground:nil];
    [super viewDidUnload];
}

@end
