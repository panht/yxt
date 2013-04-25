//
//  yxtLogin.h
//  yxt
//
//  Created by world ask on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtIndex;

@interface yxtLogin : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

- (IBAction)closeKeyboard:(id)sender;
//- (IBAction)backgroundTap:(id)sender;
- (IBAction)login:(id)sender;

@end
