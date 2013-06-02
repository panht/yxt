//
//  yxtWelcome.h
//  yxt
//
//  Created by world ask on 13-6-2.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yxtWelcome : UIViewController

@property (strong, nonatomic) UIViewController *tab1;
@property (strong, nonatomic) UIViewController *tab2;
@property (strong, nonatomic) UIViewController *tab3;
@property (strong, nonatomic) UIViewController *tabCurrent;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
