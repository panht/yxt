//
//  yxtFormUser.m
//  yxt
//
//  Created by world ask on 13-6-5.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtFormUser.h"
#import "yxtAppDelegate.h"

@interface yxtFormUser ()

@end

@implementation yxtFormUser

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
    // Do any additional setup after loading the view from its nib.
    
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", app.urlHead, app.headerimg]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data != NULL) {
        // 判断头像图片是否存在
        UIImage *aimage = [[UIImage alloc] initWithData:data];
        self.imageHead.image = aimage;
        [self.imageHead setNeedsDisplay];
    }
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
    [super viewDidUnload];
}
- (IBAction)chooseHead:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置头像..." message:@"" delegate:self cancelButtonTitle:@"拍照" otherButtonTitles: @"相册", nil];
    [alert show];
}

//定义的委托，buttonindex就是按下的按钮的index值
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%i",buttonIndex);
    
}

- (IBAction)save:(id)sender {
}
@end
