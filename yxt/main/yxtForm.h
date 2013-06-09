//
//  yxtForm.h
//  yxt
//
//  Created by panht on 13-6-6.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yxtViewControllerBase.h"

@class yxtViewControllerBase;
@class yxtFormUser;
@class yxtForm1;
@class yxtForm2;
@class yxtForm3;
@class yxtForm4;

@interface yxtForm : UIViewController

@property (strong, nonatomic) NSString *xibName;
@property (strong, nonatomic) yxtFormUser *formUser;
@property (strong, nonatomic) yxtForm1 *form1;
@property (strong, nonatomic) yxtForm2 *form2;
@property (strong, nonatomic) yxtForm3 *form3;
@property (strong, nonatomic) yxtForm4 *form4;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UIImageView *parentImageHead;

- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;
- (IBAction)backgroundTap:(id)sender;

-(void) settleForm: (yxtViewControllerBase*)vc;
-(void) loadFormUser;
-(void) loadForm1;
-(void) loadForm2;
-(void) loadForm3;
-(void) loadForm4;
@end
