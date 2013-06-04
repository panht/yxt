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
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) UIImage *image11;
@property (weak, nonatomic) UIImage *image12;
@property (weak, nonatomic) UIImage *image21;
@property (weak, nonatomic) UIImage *image22;
@property (weak, nonatomic) UIImage *image31;
@property (weak, nonatomic) UIImage *image32;
@property (weak, nonatomic) IBOutlet UIImageView *imageHead;

-(void) setButton;

@end
