//
//  yxtForm1.m
//  yxt
//
//  Created by panht on 13-6-1.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtForm1.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface yxtForm1 () 

@end

@implementation yxtForm1

@synthesize selectedRow1;
@synthesize selectedRow2;
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
    // 通知范围、对象边框
    self.inputScope.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputScope.layer.borderWidth = 1.0;
    self.inputTarget.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputTarget.layer.borderWidth = 1.0;
    self.inputContent.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputContent.layer.borderWidth = 1.0;
    
    // picker添加点击事件
    UITapGestureRecognizer *pickerTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePicker)];
    [self.picker addGestureRecognizer:pickerTapped];
}

- (void) resetForm {
    self.inputTitle.text = @"";
    if ([self.dataListArray count] > 0) {
        NSDictionary *row = [self.dataListArray objectAtIndex:0];
        self.selectedRow1 = 0;
        
        // 通知范围初始值
        [self.inputScope setTitle:[row objectForKey:@"name"] forState:UIControlStateNormal];
        [self.inputScope setTag:[[row objectForKey:@"value"] integerValue]];
    }
    [self.inputTarget setTitle:@"家长" forState:UIControlStateNormal];
    self.selectedRow2 = 0;
    self.inputSMS.on = YES;
    self.inputWeibo.on = YES;
    self.inputContent.text = @"";
}

- (void) loadData {
    // 通知对象初始值
    [self.inputTarget setTitle:@"家长" forState:UIControlStateNormal];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // 获取通知班级
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
            
            self.dataListArray = [jsonList objectForKey:@"list"];
            if ([self.dataListArray count] > 0) {
                NSDictionary *row = [self.dataListArray objectAtIndex:0];
                self.selectedRow1 = 0;
                
                // 通知范围初始值
                [self.inputScope setTitle:[row objectForKey:@"name"] forState:UIControlStateNormal];
                [self.inputScope setTag:[[row objectForKey:@"value"] integerValue]];
            }
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)scopeTapped:(id)sender {
    if ([self.dataListArray count] > 0) {
        self.dataSource = self.dataListArray;
        [self.picker setTag:1];
        [self.picker setHidden:NO];
        [self.picker reloadAllComponents];
        [self.picker selectRow:self.selectedRow1 inComponent:0 animated:NO];
    } else {
        [yxtUtil warning:self.view :@"没有可用的通知范围"];
    }
}

- (IBAction)targetTapped:(id)sender {
    self.dataSource = [[NSArray alloc]initWithObjects:@"家长",@"学生",@"老师", nil];
    [self.picker setTag:2];
    [self.picker setHidden:NO];
    [self.picker reloadAllComponents];
    [self.picker selectRow:self.selectedRow2 inComponent:0 animated:NO];
}

- (IBAction)send:(id)sender {
    [self.view endEditing: YES];
    
    // 校验必填项
    if ([self.inputTitle.text isEqualToString:@""]) {
        [yxtUtil warning:self.view :@"请输入通知主题"];
        return;
    } else if (self.inputScope.currentTitle == nil || [self.inputScope.currentTitle isEqualToString:@""]) {
        [yxtUtil warning:self.view :@"请选择通知范围"];
        return;
    } else if ([self.inputContent.text isEqualToString:@""]) {
        [yxtUtil warning:self.view :@"请输入内容"];
        return;
    }
    else if ([self.inputTitle.text length] > 127) {
        [yxtUtil warning:self.view :@"通知主题不能超过127字"];
        return;
    } else if ([self.inputContent.text length] > 1000) {
        [yxtUtil warning:self.view :@"内容不能超过1000字"];
        return;
    }
    
    // 保存
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSString *classid = [NSString stringWithFormat:@"%d", self.inputScope.tag];
        NSString *chksms = self.inputSMS.on ? @"1" : @"0";
        NSString *blocflag = self.inputWeibo.on ? @"1" : @"0";
        NSString *target = @"";
        if ([self.inputTarget.currentTitle isEqualToString:@"家长"]) {
            target = @"0";
        } else if ([self.inputTarget.currentTitle isEqualToString:@"学生"]) {
            target = @"1";
        } else if ([self.inputTarget.currentTitle isEqualToString:@"老师"]) {
           target = @"2"; 
        }
        NSString *title = self.inputTitle.text;
        NSString *content = self.inputContent.text;
        title = [yxtUtil replaceSpecialChar:title];
        content = [yxtUtil replaceSpecialChar:content];
//        title = [yxtUtil urlEncode:title];
//        content = [yxtUtil urlEncode:content];
        NSString *blocToken = [yxtUtil retrieveBlocToken];

        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\", \"title\":\"%@\", \"content\":\"%@\", \"classid\":\"%@\", \"selectuser\":\"%@\", \"chksms\":\"%@\", \"useraccount\":\"%@\", \"bloctoken\":\"%@\", \"blocflag\":\"%@\"}]", app.userId, title, content, classid, target, chksms, app.acc, blocToken, blocflag]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"addBulletin" :@"0" :@"0" :identityInfo :data]];
//        NSLog(@"requestInfo   %@", requestInfo);
//        NSLog(@"identityInfo   %@", identityInfo);
//        NSLog(@"data   %@", data);
        
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            // 关闭当前视图，在父视图弹出消息
//            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
//            UIView *listView = [topWindow viewWithTag:300];
            [self resetForm];
            [yxtUtil message:self.view :@"发送成功"];
//            [listView setNeedsDisplay];
            
//            [self.view removeFromSuperview];
//            UIView *list1View = [topWindow viewWithTag:400];
//            [list1View removeFromSuperview];
        } else {
            [yxtUtil warning:self.view :[dataResponse objectForKey:@"resultdes"]];
        }
    });
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
            [self.inputScope setTag:[[rowData objectForKey:@"value"] integerValue]];
        } else if (self.picker.tag == 2) {
            result = [self.dataSource objectAtIndex:row];
        }
    }
    
    return result;
}

// 点击关闭picker
- (void) closePicker {
    NSInteger row = [self.picker selectedRowInComponent:0];
    
    if ([self.dataSource count] > 0) {
        if (self.picker.tag == 1) {
            NSDictionary *value = [self.dataSource objectAtIndex:row];
            [self.inputScope setTitle:[value objectForKey:@"name"]  forState:UIControlStateNormal];
            self.inputScope.tag = [[value objectForKey:@"value"] integerValue];
            self.selectedRow1 = [self.picker selectedRowInComponent:0];
        } else if (self.picker.tag == 2) {
            NSString *value = [self.dataSource objectAtIndex:row];
            [self.inputTarget setTitle:value forState:UIControlStateNormal];
            self.selectedRow2 = [self.picker selectedRowInComponent:0];
        }
    }
    [self.picker setHidden:YES];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    [self.picker setHidden:YES];
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    [super textViewDidBeginEditing:textView];
    [self.picker setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageBackground:nil];
    [self setInputTitle:nil];
    [self setInputScope:nil];
    [self setInputTarget:nil];
    [self setInputSMS:nil];
    [self setInputWeibo:nil];
    [self setInputContent:nil];
    [self setPicker:nil];
    [self setInputScope:nil];
    [self setInputTarget:nil];
    [super viewDidUnload];
}
@end
