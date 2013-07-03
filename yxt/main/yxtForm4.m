//
//  yxtForm4.m
//  yxt
//
//  Created by panht on 13-6-8.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtForm4.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface yxtForm4 ()

@end

@implementation yxtForm4

@synthesize dataSource1;
@synthesize dataSource2;
@synthesize dataListArray2;
@synthesize dataSource2Selected;
@synthesize classId;
@synthesize ids;

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
    
    // 重新布局、初始值
    [self resettle];
}

- (void) resettle {
    [self.inputPicker1 setHidden:YES];
    
    // 作业课程、内容边框
    self.inputUser.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputUser.layer.borderWidth = 1.0;
    self.inputContent.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputContent.layer.borderWidth = 1.0;
    
    // 获得屏幕宽高
//    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
//    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//    self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight - statusBarHeight - self.btnAlbum.frame.size.height);
    
    // inputPicker添加点击事件
    UITapGestureRecognizer *pickerTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePicker)];
    [self.inputPicker1 addGestureRecognizer:pickerTapped];
}

- (void) loadData1 {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        // 获取班级
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\"}]", app.userId]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"eduClass" :@"1" :@"100" :identityInfo :data]];
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            
            self.dataSource1 = [jsonList objectForKey:@"list"];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    });
    
    if ([self.dataSource1 count] > 0) {
        [self.inputPicker1 setTag:1];
        [self.inputPicker1 setHidden:NO];
        [self.inputPicker1 reloadAllComponents];
    } else {
        [yxtUtil warning:self.view :@"没有可用的班级"];
    }
}

- (void) loadData2{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // 获取班级
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"classid\":\"%@\"}]", self.classId]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"selectStudent" :@"1" :@"100" :identityInfo :data]];
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
//            self.dataListArray2 = [jsonList objectForKey:@"list"];
//            
//            // 遍历数组，将姓名取出来放到表格数据源中
//            NSMutableArray *array2 = [[NSMutableArray alloc] init];
//            for (NSDictionary *dict in self.dataListArray2) {
//                [array2 addObject:[NSString stringWithFormat:@"%@(%@)", [dict objectForKey:@"user_name"], [[dict objectForKey:@"is_open"] isEqualToString:@"1"] ? @"已开通业务" : @"未开通业务"]];
//            }
//            self.dataSource2 = [array2 mutableCopy];
            self.dataSource2 = [jsonList objectForKey:@"list"];
            selectionStates = [[NSMutableDictionary alloc] init];
            
            //点击后删除之前的PickerView
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]]) {
                    [view removeFromSuperview];
                }
            }
            
            //    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 360 - 20, 320, 260 + 44)];
            self.multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 260)];
            self.multiPickerView.entriesArray = self.dataSource2;
            self.multiPickerView.entriesSelectedArray = self.dataSource2Selected;
            self.multiPickerView.multiPickerDelegate = self;
            [self.view addSubview: self.multiPickerView];
            [self.multiPickerView pickerShow];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)send:(id)sender {
    [self.view endEditing: YES];
    
    // 校验必填项
    if ([self.inputTitle.text isEqualToString:@""]) {
        [yxtUtil warning:self.view :@"请输入标题"];
        return;
    } else if ([self.inputContent.text isEqualToString:@""]) {
        [yxtUtil warning:self.view :@"请输入内容"];
        return;
    }else if ([self.ids isEqualToString:@""] || self.ids == nil) {
        [yxtUtil warning:self.view :@"请选择接收用户"];
        return;
    }
    else if ([self.inputTitle.text length] > 100) {
        [yxtUtil warning:self.view :@"标题不能超过100字"];
        return;
    } else if ([self.inputContent.text length] > 250) {
        [yxtUtil warning:self.view :@"内容不能超过250字"];
        return;
    }
    
    // 保存
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *chksms = self.inputSMS.on ? @"1" : @"0";
        NSString *blocflag = self.inputWeibo.on ? @"1" : @"0";
        NSString *title = self.inputTitle.text;
        NSString *content = self.inputContent.text;
        title = [yxtUtil replaceSpecialChar:title];
        content = [yxtUtil replaceSpecialChar:content];
        NSString *blocToken = [yxtUtil retrieveBlocToken];
        
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"title\":\"%@\", \"content\":\"%@\", \"classid\":\"%@\", \"ids\":\"%@\", \"chksms\":\"%@\", \"userName\":\"%@\", \"blocToken\":\"%@\", \"userAccount\":\"%@\", \"blocFlag\":\"%@\"}]", title, content, self.classId, ids, chksms, app.username, blocToken, app.acc, blocflag]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"addReviews" :@"0" :@"0" :identityInfo :data]];
        
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

- (IBAction)userTapped:(id)sender {
    [self loadData1];
}

#pragma mark Picker Data Soucrce Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    //Picker里有几个竖的栏目就返回几
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //picker中的选项有几个
    return [self.dataSource1 count];
}

// 点击picker返回选中项
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *result;
    
    if (row < [self.dataSource1 count]) {
        // 显示标题
        if (self.inputPicker1.tag == 1) {
            NSDictionary *rowData = [self.dataSource1 objectAtIndex:row];
            result = [rowData objectForKey:@"name"];
//            [self.inputCourse setTag:[[rowData objectForKey:@"value"] integerValue]];
        }
    }
    
    return result;
}

// 点击关闭inputPicker
- (void) closePicker {
    NSInteger row = [self.inputPicker1 selectedRowInComponent:0];
    
    if ([self.dataSource1 count] > 0 && self.inputPicker1.tag == 1) {
        NSDictionary *value = [self.dataSource1 objectAtIndex:row];
        self.classId = [value objectForKey:@"value"];
        
        // 载入多选picker
        [self loadData2];
    }
    
    [self.inputPicker1 setHidden:YES];
}

#pragma mark - Delegate
//获取到选中的数据
-(void)returnChoosedPickerString:(NSMutableArray *)selectedEntriesArr {
    NSString *names = [[NSString alloc] init];
    
    if ([self.dataSource2 count] > 0) {
        for (NSString *row in self.multiPickerView.selectedArray) {
            NSDictionary *rowData = [self.dataSource2 objectAtIndex:[row integerValue]];
            
            if (self.ids == nil) {
                self.ids = [rowData objectForKey:@"user_id"];
            } else {
                self.ids = [self.ids stringByAppendingFormat:@",%@", [rowData objectForKey:@"user_id"]];
            }
            
            names = [names stringByAppendingFormat:@"%@,", [rowData objectForKey:@"user_name"]];
        }
    }
    
    if ([names isEqualToString:@""]) {
        names = @"请选择用户";
    }
    [self.inputUser setTitle:names forState:UIControlStateNormal];
    
    // 再次初始化选中的数据
    self.dataSource2Selected = [NSArray arrayWithArray:selectedEntriesArr];
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    [self.inputPicker1 setHidden:YES];
    [self.multiPickerView pickerHide];
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    [super textViewDidBeginEditing:textView];
    [self.inputPicker1 setHidden:YES];
    [self.multiPickerView pickerHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setInputTitle:nil];
    [self setInputSMS:nil];
    [self setInputWeibo:nil];
    [self setInputContent:nil];
    [self setInputPicker1:nil];
    [self setInputUser:nil];
    [super viewDidUnload];
}

@end
