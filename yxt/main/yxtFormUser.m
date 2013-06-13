//
//  yxtFormUser.m
//  yxt
//
//  Created by panht on 13-6-5.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtFormUser.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "GTMBase64.h"
#import "yxtWelcome.h"
#import "MBProgressHUD.h"

@interface yxtFormUser ()

@end

@implementation yxtFormUser

@synthesize imageOld;
@synthesize imageNew;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置文本框委托
    self.oldpwd.delegate = self;
    self.newpwd1.delegate = self;
    self.newpwd2.delegate = self;
    
    // 设置头像
    // 判断本地是否已保存头像文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"avatar.png"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if (data != NULL) {
        self.imageOld = [UIImage imageWithData:data];
    } else {
        // 否则显示默认头像
        self.imageOld = [UIImage imageNamed:@"account_ico.png"];
    }
    self.imageHead.image = self.imageOld;
    [self.imageHead setNeedsDisplay];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageHead:nil];
    [self setOldpwd:nil];
    [self setNewpwd1:nil];
    [self setNewpwd2:nil];
    [self setScrollView:nil];
    [self setImageBackground:nil];
    [self setBtnSave:nil];
    [super viewDidUnload];
}
- (IBAction)chooseHead:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置头像..." message:@"" delegate:self cancelButtonTitle:@"拍照" otherButtonTitles: @"相册", nil];
    [alert show];
}

//定义的委托，buttonindex就是按下的按钮的index值
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 拍照
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 判断相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];
        }
    } else if (buttonIndex == 1) {
        // 相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo {
    self.imageNew = aImage;
    self.imageHead.image = aImage;
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    [self.view endEditing: YES];
    
    // 任一密码框有输入，则视为需要保存密码
    if (![self.oldpwd.text isEqualToString:@""] || ![self.newpwd1.text isEqualToString:@""] || ![self.newpwd2.text isEqualToString:@""]) {
        if ([self.oldpwd.text isEqualToString:@""]) {
            [yxtUtil warning: self.view :@"请输入原密码"];
            return;
        } else if ([self.newpwd1.text isEqualToString:@""]) {
            [yxtUtil warning: self.view :@"请输入新密码"];
            return;
        } else if ([self.newpwd2.text isEqualToString:@""]) {
            [yxtUtil warning: self.view :@"请重新输入新密码"];
            return;
        } else if (![self.newpwd1.text isEqualToString:self.newpwd2.text]) {
            [yxtUtil warning: self.view :@"两次输入的新密码不一样"];
            return;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *bytesImage;
        if (self.imageOld != self.imageNew && self.imageNew != NULL) {
            NSData *dataImage = UIImagePNGRepresentation(self.imageHead.image);
            bytesImage = [GTMBase64 stringByEncodingData:dataImage];

            // 判断本地是否已保存头像文件
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:@"avatar.png"];
            [dataImage writeToFile:filePath atomically:YES];
                    
            // 更新主界面的头像
            self.parentImageHead.image = self.imageNew;
        } else {
            bytesImage = @"";
        }
        
        // 提交表单
        NSString *requestInfo;
        NSString *identityInfo;
        NSString *data;
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"picstream\":\"%@\", \"oldPass\":\"%@\", \"newPass\":\"%@\"}]", bytesImage, self.oldpwd.text, self.newpwd1.text]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"updateUserInfo" :@"0" :@"0" :identityInfo :data]];
        NSLog(@"%@", data);
        
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :data];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            self.imageOld = self.imageNew;
            
            // 关闭当前视图，在父视图弹出消息
            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
            UIView *welcomeView = [topWindow viewWithTag:200];
            [yxtUtil message:welcomeView :@"保存成功"];
            
            [self.view removeFromSuperview];
            UIView *list1View = [topWindow viewWithTag:300];
            [list1View removeFromSuperview];
        } else {
            [yxtUtil warning: self.view :[dataResponse objectForKey:@"resultdes"]];
        }
        
    });
    
}
@end
