//
//  yxtAppDelegate.h
//  yxt
//
//  Created by pht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtIndex;
@class yxtLogin;

@interface yxtAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *schoolNo;
// 登录类型，1教师，2家长，3，双角色，4学生
@property (strong, nonatomic) NSString *loginType;
@property (strong, nonatomic) NSString *token;


@property (nonatomic, strong) UIWindow *window;
@property (strong, nonatomic) IBOutlet UIViewController *login;
@property (strong, nonatomic) IBOutlet UIViewController *index;

-(void)showIndex;


@end
