//
//  yxtWelcome.h
//  yxt
//
//  Created by panht on 13-6-2.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtForm;
@class yxtFormUser;
@class yxtTab1;
@class yxtTab2;
@class yxtTab3;

@interface yxtWelcome : UIViewController

@property (strong, nonatomic) yxtForm *form;
@property (strong, nonatomic) yxtFormUser *formUser;
@property (strong, nonatomic) yxtTab1 *tab1;
@property (strong, nonatomic) yxtTab2 *tab2;
@property (strong, nonatomic) yxtTab3 *tab3;
@property (strong, nonatomic) UIViewController *tabCurrent;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIImageView *button1;
@property (weak, nonatomic) IBOutlet UIImageView *button2;
@property (weak, nonatomic) IBOutlet UIImageView *button3;
@property (weak, nonatomic) UIImage *image11;
@property (weak, nonatomic) UIImage *image12;
@property (weak, nonatomic) UIImage *image21;
@property (weak, nonatomic) UIImage *image22;
@property (weak, nonatomic) UIImage *image31;
@property (weak, nonatomic) UIImage *image32;
@property (weak, nonatomic) IBOutlet UIImageView *imageHead;
@property (weak, nonatomic) IBOutlet UILabel *username;

- (IBAction)logout:(id)sender;

-(void) setButton;
-(void) openForm: (NSString *)nibName;
-(void) openFormUser;

@end
