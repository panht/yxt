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
#import "GTMBase64.h"
#import <QuartzCore/QuartzCore.h>

@interface yxtForm2 ()

@end

@implementation yxtForm2

@synthesize dataSource;
@synthesize dataListArray;
@synthesize files;

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
    
    self.files = [[NSMutableArray alloc] init];
    
    // 隐藏 inputPicker
    [self.inputPicker setHidden:YES];
    
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
//    self.scrollView.layer.borderColor = [UIColor grayColor].CGColor;
//    self.scrollView.layer.borderWidth = 1.0;
    
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight - statusBarHeight - self.btnAlbum.frame.size.height);
    
    // 底部按钮，子视图宽高已经计算过，不需要再按屏幕宽高计算
    int x, y, width, height;
    x = 0;
    y = self.view.frame.size.height - self.btnAlbum.frame.size.height;
    width = self.view.frame.size.width / 2;
    height = self.btnAlbum.frame.size.height;
    self.btnAlbum.frame = CGRectMake(x, y, width - 1, height);
    self.btnPhoto.frame = CGRectMake(x + width + 1, y, width, height);
    self.scrollView.frame = CGRectMake(x, y - 60, self.view.frame.size.width, 60);
    
    // inputPicker添加点击事件
    UITapGestureRecognizer *pickerTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePicker)];
    [self.inputPicker addGestureRecognizer:pickerTapped];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
}

- (void) resetForm {
    self.inputTitle.text = @"";
    if ([self.dataListArray count] > 0) {
        NSDictionary *row = [self.dataListArray objectAtIndex:0];
        [self.inputPicker selectRow:0 inComponent:0 animated:NO];
        
        // 作业课程初始值
        [self.inputCourse setTitle:[row objectForKey:@"name"] forState:UIControlStateNormal];
        [self.inputCourse setTag:[[row objectForKey:@"value"] integerValue]];
    }
    self.inputSMS.on = YES;
    self.inputWeibo.on = YES;
    self.inputContent.text = @"";
    
    [self.files removeAllObjects];
    // 从界面删除所有图片
    for (UIView *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIImageView class]] || [v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
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
            if ([self.dataListArray count] > 0) {
                NSDictionary *row = [self.dataListArray objectAtIndex:0];
                
                // 作业课程初始值
                [self.inputCourse setTitle:[row objectForKey:@"name"] forState:UIControlStateNormal];
            }
//            [self.inputCourse setTag:[[row objectForKey:@"value"] integerValue]];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (IBAction)send:(id)sender {
    [self.view endEditing: YES];
    
    // 校验必填项
    if (self.inputCourse.currentTitle == nil || [self.inputCourse.currentTitle isEqualToString:@""]) {
        [yxtUtil warning:self.view :@"请选择作业课程"];
        return;
    } else if ([self.inputTitle.text isEqualToString:@""]) {
        [yxtUtil warning:self.view :@"请输入作业标题"];
        return;
    } else if ([self.inputContent.text isEqualToString:@""]) {
        [yxtUtil warning:self.view :@"请输入内容"];
        return;
    }
    else if ([self.inputTitle.text length] > 100) {
        [yxtUtil warning:self.view :@"作业标题不能超过100字"];
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
        NSString *courseid = @"";
        NSString *coursename = self.inputCourse.currentTitle;
        for (NSDictionary *rowData in self.dataListArray) {
            if ([[rowData objectForKey:@"name"] isEqualToString:self.inputCourse.currentTitle]) {
                courseid = [rowData objectForKey:@"value"];
                break;
            }
        }
        NSString *chksms = self.inputSMS.on ? @"1" : @"0";
        NSString *blocflag = self.inputWeibo.on ? @"1" : @"0";
        NSString *title = self.inputTitle.text;
        NSString *content = self.inputContent.text;
        title = [yxtUtil replaceSpecialChar:title];
        content = [yxtUtil replaceSpecialChar:content];
//        coursename = [yxtUtil urlEncode:coursename];
        NSString *blocToken = [yxtUtil retrieveBlocToken];
        if (blocToken == nil || blocToken == NULL || blocToken == Nil) {
            blocToken = @"";
        }
        
        NSString *requestInfo;
        NSString *data;
        NSString *identityInfo;
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"userid\":\"%@\", \"assTitle\":\"%@\", \"assContent\":\"%@\", \"classCourse\":\"%@\", \"chkSms\":\"%@\", \"userName\":\"%@\", \"classCourseName\":\"%@\", \"blocToken\":\"%@\", \"userAccount\":\"%@\", \"blocFlag\":\"%@\"}]", app.userId, title, content, courseid, chksms, app.username, coursename, blocToken, app.acc, blocflag]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"addHomeWork" :@"0" :@"0" :identityInfo :data]];
//        NSLog(@"requestInfo   %@", requestInfo);
//        NSLog(@"identityInfo   %@", identityInfo);
//        NSLog(@"data   %@", data);
        
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        [_params setObject:requestInfo forKey:@"RequestInfo"];
        [_params setObject:identityInfo forKey:@"IdentityInfo"];
        [_params setObject:data forKey:@"data"];
        
        NSString *boundary = @"----------V2ymHFg03ehbqgZCaKO6jy";
        NSURL* requestURL = [NSURL URLWithString:app.urlService];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];	
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        for (NSString *param in _params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: text/plain; charset=UTF-8\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Transfer-Encoding: 8bit\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }

        // 处理图片
//        NSString* FileParamConstant = @"pic";
        NSInteger i = 0;
        for (UIImage *image in self.files) {
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image%d\"; filename=\"image%d.jpg\"\r\n", i	, i] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[@"Content-Type: application/octet-stream; charset=UTF-8\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Transfer-Encoding: 8bit\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                imageData = nil;
                i++;
            }
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setURL:requestURL];
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        // 返回数据转json
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:kNilOptions
                                                               error:&error];
        
        
//        NSString *stringTemp = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//        
//        // responseinfo段再转json
//        NSString* responseinfo = [json objectForKey:@"responseinfo"];
//        NSData *dataResponseinfo = [responseinfo dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary* jsonResponseinfo = [NSJSONSerialization JSONObjectWithData:dataResponseinfo
//                                                                         options:kNilOptions
//                                                                           error:&error];
        
//        NSLog(@"responseinfo %@", responseinfo);
        // 返回数据
        NSString *resultData = [json objectForKey:@"resultdata"];
        NSData *dataResultData = [resultData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResultData = [NSJSONSerialization JSONObjectWithData:dataResultData
                                                                       options:kNilOptions
                                                                         error:&error];

//        NSLog(@"resultdata %@", resultData);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[jsonResultData objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            // 关闭当前视图，在父视图弹出消息
//            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
//            UIView *listView = [topWindow viewWithTag:200];
            [self resetForm];
            [yxtUtil message:self.view :@"发送成功"];
            
//            [self.view removeFromSuperview];
//            UIView *formView = [topWindow viewWithTag:300];
//            [formView removeFromSuperview];
//            UIView *list1View = [topWindow viewWithTag:400];
//            [list1View removeFromSuperview];
        } else {
            [yxtUtil warning:self.view :[jsonResultData objectForKey:@"resultdes"]];
        }
    });
}

- (IBAction)albumTapped:(id)sender {
    // 相册
    if ([self.files count] >= 5) {
        [yxtUtil warning:self.view :@"最多只能上传五张图片"];
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    }
}

- (IBAction)photoTapped:(id)sender {
    // 拍照
    if ([self.files count] >= 5) {
        [yxtUtil warning:self.view :@"最多只能上传五张图片"];
    } else {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 判断相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            //            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = sourceType;
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
}

// 拍照或相册选中图片后返回
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo {
    // resize
    aImage = [yxtUtil resizeImage: aImage];
    
    // 存放到数组
    [self.files addObject:aImage];
    // 绘制图片
    [self drawImage:aImage :[self.files count] - 1];
    
    [picker dismissModalViewControllerAnimated:YES];
}

//
//+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    //UIGraphicsBeginImageContext(newSize);
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}


// 显示图片和删除角标
- (void) drawImage: (UIImage *)image :(NSInteger)seqNo {
    int xOffset = seqNo * 60;
    
    // 添加imgaeView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    // 数组索引+1000 作为tag
    imageView.tag = seqNo + 1000;
    imageView.frame = CGRectMake(15 + xOffset, 5, 50, 50);
    [self.scrollView addSubview:imageView];
    
    // 添加删除角标
    UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDel setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    btnDel.frame = CGRectMake(15 - 10 + xOffset, 0, 20, 20);
    // 数组索引 作为tag
    btnDel.tag = seqNo;
    [btnDel addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btnDel];
}

// 删除图片
- (void) delImage: (id)sender; {
    // 从界面删除所有图片
    for (UIView *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIImageView class]] || [v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    UIButton *button = (UIButton *) sender;
    // 从tag获取要删除的图片在数组中的索引
    NSInteger index = button.tag;
    // 从数组中删除指定索引
    [self.files removeObjectAtIndex:index];
    
    // 遍历数组，重新绘制图片
    NSInteger i = 0;
    for (UIImage *image in self.files) {
        [self drawImage:image :i];
        i++;
    }
}

- (IBAction)courseTapped:(id)sender {
    if ([self.dataListArray count] > 0) {
        self.dataSource = self.dataListArray;
        [self.inputPicker setTag:1];
        [self.inputPicker setHidden:NO];
        [self.inputPicker reloadAllComponents];
    } else {
        [yxtUtil warning:self.view :@"没有可用的作业课程"];
    }
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
        if (self.inputPicker.tag == 1) {
            NSDictionary *rowData = [self.dataSource objectAtIndex:row];
            result = [rowData objectForKey:@"name"];
//            [self.inputCourse setTag:[[rowData objectForKey:@"value"] integerValue]];
        }
    }
    
    return result;
}

// 点击关闭inputPicker
- (void) closePicker {
    NSInteger row = [self.inputPicker selectedRowInComponent:0];
    
    if ([self.dataSource count] > 0 && self.inputPicker.tag == 1) {
        NSDictionary *value = [self.dataSource objectAtIndex:row];
        [self.inputCourse setTitle:[value objectForKey:@"name"]  forState:UIControlStateNormal];
    }
    
    [self.inputPicker setHidden:YES];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    [self.inputPicker setHidden:YES];
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    [super textViewDidBeginEditing:textView];
    [self.inputPicker setHidden:YES];
}

- (void)viewDidUnload {
    [self setInputCourse:nil];
    [self setInputTitle:nil];
    [self setInputSMS:nil];
    [self setInputWeibo:nil];
    [self setInputContent:nil];
    [self setImageBackground:nil];
    [self setBtnAlbum:nil];
    [self setBtnPhoto:nil];
    [self setInputPicker:nil];
    [super viewDidUnload];
}

@end
