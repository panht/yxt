//
//  yxtAppDelegate.h
//  yxt
//
//  Created by pht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "yxtLoginSwitch.h"

@class yxtIndex;
@class yxtLogin;

@interface yxtAppDelegate : UIResponder <UIApplicationDelegate>
//{
//    UIWindow *window;
//    yxtLoginSwitch * loginSwitch;
//}

@property (nonatomic, strong) UIWindow *window;
//@property (nonatomic, strong) yxtLoginSwitch *loginSwitch;
//@property (strong, nonatomic) yxtIndex *index;

@property (strong, nonatomic) IBOutlet UIViewController *login;

@property (strong, nonatomic) IBOutlet UITabBarController *index;

-(void)showIndex;


@end
