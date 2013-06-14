//
//  yxtForm3.m
//  yxt
//
//  Created by panht on 13-6-8.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtForm3.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>


@interface yxtForm3 ()

@end

@implementation yxtForm3

@synthesize dataSource;
@synthesize dataListArray1;
@synthesize dataListArray2;
@synthesize dataListArray3;

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
    
    [self resettle];

    [self loadData];
}

- (void) resettle{
    // 考试名称、考试班级、考试科目边框
    self.inputName.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputName.layer.borderWidth = 1.0;
    self.inputClass.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputClass.layer.borderWidth = 1.0;
    self.inputSubject.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputSubject.layer.borderWidth = 1.0;
    
    // picker添加点击事件
    UITapGestureRecognizer *pickerTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePicker)];
    [self.picker addGestureRecognizer:pickerTapped];
}

- (void) loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    // 获取picker数据
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        // 考试类型，从segment控件获取，0为大考，1为其它
        NSString *type = [NSString stringWithFormat:@"%d", self.inputType.selectedSegmentIndex];
        NSString *examid, *classid;
        
        // 获取考试名称
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"examType\":\"%@\"}]", type]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"selectExam" :@"1" :@"10" :identityInfo :data]];
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            self.dataListArray1 = [jsonList objectForKey:@"list"];
            NSDictionary *row = [self.dataListArray1 objectAtIndex:0];
            
            // 考试名称
            [self.inputName setTitle:[row objectForKey:@"exam_name"] forState:UIControlStateNormal];
            
            examid = [row objectForKey:@"exam_id"];
            [self.inputName setTag:[examid integerValue]];
        }
        
        // 获取考试班级
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"examType\":\"%@\", \"examId\":\"%@\"}]", type, examid]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"selectExamClass" :@"1" :@"10" :identityInfo :data]];
        // 从服务端获取数据
        dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            self.dataListArray2 = [jsonList objectForKey:@"list"];
            NSDictionary *row = [self.dataListArray2 objectAtIndex:0];
            
            // 考试名称
            [self.inputClass setTitle:[row objectForKey:@"class_name"] forState:UIControlStateNormal];
            classid = [row objectForKey:@"class_id"];
            [self.inputClass setTag:[classid integerValue]];
        }
        
        // 获取考试科目
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"classId\":\"%@\", \"examId\":\"%@\"}]", classid, examid]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"selectExamCourse" :@"1" :@"10" :identityInfo :data]];
        // 从服务端获取数据
        dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            self.dataListArray3 = [jsonList objectForKey:@"list"];
            NSDictionary *row = [self.dataListArray3 objectAtIndex:0];
            
            // 考试名称
            [self.inputSubject setTitle:[row objectForKey:@"course_name"] forState:UIControlStateNormal];
            [self.inputSubject setTag:[[row objectForKey:@"course_id"] integerValue]];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)send:(id)sender {
    [self.view endEditing: YES];
    
    // 保存
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *examId = [NSString stringWithFormat:@"%d", self.inputName.tag];
        NSString *classId = [NSString stringWithFormat:@"%d", self.inputClass.tag];
        NSString *courseId = [NSString stringWithFormat:@"%d", self.inputSubject.tag];
        NSString *chkSendRemark = self.inputMemo.on ? @"1" : @"0";
        NSString *chkSendParents = self.inputMessage.on ? @"1" : @"0";
        NSString *chksms = self.inputSMS.on ? @"1" : @"0";
        NSString *blocflag = self.inputWeibo.on ? @"1" : @"0";
        
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"classid\":\"%@\", \"courseid\":\"%@\", \"examid\":\"%@\", \"sendparents\":\"%@\", \"sendparentsmsg\":\"%@\", \"sendremark\":\"%@\", \"sendstudent\":\"%@\", \"bloctoken\":\"%@\", \"useraccount\":\"%@\", \"blocflag\":\"%@\"}]", classId, courseId, examId, chkSendParents, chksms, chkSendRemark, @"0", app.blocToken, app.acc, blocflag]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"addExamSendMsg" :@"0" :@"0" :identityInfo :data]];
        
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            // 关闭当前视图，在父视图弹出消息
            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
            UIView *listView = [topWindow viewWithTag:300];
            [yxtUtil message:listView :@"发送成功"];
            
            [self.view removeFromSuperview];
            UIView *list1View = [topWindow viewWithTag:400];
            [list1View removeFromSuperview];
        } else {
            [yxtUtil warning:self.view :[dataResponse objectForKey:@"resultdes"]];
        }
    });
}

#pragma mark Picker Data Soucrce Methods

- (IBAction)nameTapped:(id)sender {
    self.dataSource = self.dataListArray1;
    [self.picker setTag:1];
    [self.picker setHidden:NO];
    [self.picker reloadAllComponents];
}

- (IBAction)classTapped:(id)sender {
    self.dataSource = self.dataListArray2;
    [self.picker setTag:2];
    [self.picker setHidden:NO];
    [self.picker reloadAllComponents];
}

- (IBAction)subjectTapped:(id)sender {
    self.dataSource = self.dataListArray3;
    [self.picker setTag:3];
    [self.picker setHidden:NO];
    [self.picker reloadAllComponents];
}

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
    NSDictionary *rowData = [self.dataSource objectAtIndex:row];
    NSString *result;
    
    if (row < [self.dataSource count]) {
        // 显示标题
        if (self.picker.tag == 1) {
            result = [rowData objectForKey:@"exam_name"];
            [self.inputName setTag:[[rowData objectForKey:@"exam_id"] integerValue]];
        } else if (self.picker.tag == 2) {
            result = [rowData objectForKey:@"class_name"];
            [self.inputClass setTag:[[rowData objectForKey:@"class_id"] integerValue]];
        } else if (self.picker.tag == 3) {
            result = [rowData objectForKey:@"course_name"];
            [self.inputSubject setTag:[[rowData objectForKey:@"course_id"] integerValue]];
        }
    }
    
    return result;
}

// 点击关闭picker
- (void) closePicker {
    NSInteger row = [self.picker selectedRowInComponent:0];
    NSDictionary *value = [self.dataSource objectAtIndex:row];
    
    if (self.picker.tag == 1) {
        [self.inputName setTitle:[value objectForKey:@"exam_name"]  forState:UIControlStateNormal];
        [self.inputName setTag:[[value objectForKey:@"exam_id"] integerValue]];
    } else if (self.picker.tag == 2) {
        [self.inputClass setTitle:[value objectForKey:@"class_name"]  forState:UIControlStateNormal];
        [self.inputClass setTag:[[value objectForKey:@"class_id"] integerValue]];
    } else if (self.picker.tag == 3) {
        [self.inputSubject setTitle:[value objectForKey:@"course_name"]  forState:UIControlStateNormal];
        [self.inputSubject setTag:[[value objectForKey:@"course_id"] integerValue]];
    }
    [self.picker setHidden:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setInputType:nil];
    [self setInputName:nil];
    [self setInputClass:nil];
    [self setInputSubject:nil];
    [self setInputMemo:nil];
    [self setInputMessage:nil];
    [self setInputSMS:nil];
    [self setInputWeibo:nil];
    [self setPicker:nil];
    [super viewDidUnload];
}
@end
