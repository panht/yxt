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
@synthesize dataSource2Selected;

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

- (void) loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
            
            [self.inputPicker1 setTag:1];
            [self.inputPicker1 setHidden:NO];
            [self.inputPicker1 reloadAllComponents];
//            NSDictionary *row = [self.dataListArray objectAtIndex:0];
            
            // 通知范围初始值
//            [self.inputScope setTitle:[row objectForKey:@"name"] forState:UIControlStateNormal];
//            [self.inputScope setTag:[[row objectForKey:@"value"] integerValue]];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)send:(id)sender {
    [self.view endEditing: YES];
    
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
        NSString *chksms = self.inputSMS.on ? @"1" : @"0";
        NSString *blocflag = self.inputWeibo.on ? @"1" : @"0";
        NSString *title = self.inputTitle.text;
        NSString *content = self.inputContent.text;
        title = [yxtUtil urlEncode:title];
        content = [yxtUtil urlEncode:content];
        
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
//        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\", \"assTitle\":\"%@\", \"assContent\":\"%@\", \"classCourse\":\"%@\", \"chksms\":\"%@\", \"userName\":\"%@\", \"classCourseName\":\"%@\", \"blocToken\":\"%@\", \"userAccount\":\"%@\", \"blocFlag\":\"%@\", \"Files\":\"%@\"}]", app.userId, title, content, courseid, chksms, [yxtUtil urlEncode:app.username], coursename, app.token, app.userId, blocflag, bytesImage]];
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

- (IBAction)userTapped:(id)sender {
    [self loadData];
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
    
    if (self.inputPicker1.tag == 1) {
        NSDictionary *value = [self.dataSource1 objectAtIndex:row];
        //        [self.inputCourse setTitle:[value objectForKey:@"name"]  forState:UIControlStateNormal];
        
        [self.inputPicker1 setHidden:YES];
        
        // 载入多选picker
        [self loadMultiPicker];
    }
}

- (void) loadMultiPicker {
    //初始化一下数据，分别为 所有源数据，和 已经选中的数据
	self.dataSource2 = [[NSArray alloc] initWithObjects:@"Duke", @"ColorMark", @"●(り啩__唸り)●", @"zaza", @"Miss.Y'G先生",@"iOS 开发者_北京联盟",@"QQ群:262091386",@"iZ",@"Code4App.com",nil];
    self.dataSource2Selected = [[NSArray alloc] initWithObjects: @"QQ群:262091386",@"Code4App.com",nil];
	selectionStates = [[NSMutableDictionary alloc] init];
    
    // 配置是否选中状态
	for (NSString *key in self.dataSource2){
        BOOL isSelected = NO;
        
        for (NSString *keyed in self.dataSource2Selected) {
            if ([key isEqualToString:keyed]) {
                isSelected = YES;
            }
        }
        [selectionStates setObject:[NSNumber numberWithBool:isSelected] forKey:key];
    }
    
    [self getData];
}

- (void) getData {
    //点击后删除之前的PickerView
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]]) {
            [view removeFromSuperview];
        }
    }
    
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 360 - 20, 320, 260 + 44)];
    
    //  multiPickerView.backgroundColor = [UIColor redColor];
    multiPickerView.entriesArray = self.dataSource2;
    multiPickerView.entriesSelectedArray = self.dataSource2Selected;
    multiPickerView.multiPickerDelegate = self;
    
    [self.view addSubview:multiPickerView];
    
    [multiPickerView pickerShow];
}

#pragma mark - Delegate
//获取到选中的数据
-(void)returnChoosedPickerString:(NSMutableArray *)selectedEntriesArr {
    NSLog(@"selectedArray=%@", selectedEntriesArr);
    
    NSString *dataStr = [selectedEntriesArr componentsJoinedByString:@"\n"];
    
//    showLbl.text = dataStr;
    // 再次初始化选中的数据
    self.dataSource2Selected = [NSArray arrayWithArray:selectedEntriesArr];
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
