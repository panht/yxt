//
//  yxtAppDelegate.h
//  yxt
//
//  Created by panht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtWelcome;
@class yxtLogin;

@interface yxtAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSString *urlService;
@property (strong, nonatomic) NSString *urlHead;
@property (strong, nonatomic) NSString *urlFile;
@property (strong, nonatomic) NSString *ThreeDesKey;

@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *schoolNo;
// 登录类型，1教师，2家长，3，双角色，4学生
@property (strong, nonatomic) NSString *loginType;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *headerimg;


@property (nonatomic, strong) UIWindow *window;
@property (strong, nonatomic) IBOutlet yxtLogin *login;
@property (strong, nonatomic) IBOutlet yxtWelcome *welcome;

- (void) showLogin;
-(void) showWelcome;


@end
