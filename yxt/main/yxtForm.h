//
//  yxtForm.h
//  yxt
//
//  Created by world ask on 13-6-6.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class yxtFormUser;

@interface yxtForm : UIViewController

@property (strong, nonatomic) NSString *xibName;
@property (strong, nonatomic) yxtFormUser *formUser;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;

- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;
- (IBAction)backgroundTap:(id)sender;

-(void) loadFormUser;
@end
