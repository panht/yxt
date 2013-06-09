//
//  yxtLogin.h
//  yxt
//
//  Created by panht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yxtViewControllerBase.h"

@interface yxtLogin : yxtViewControllerBase

@property BOOL flagLogout;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelDisplayPassword;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inputDisplayPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelAutoLogin;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inputAutoLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

- (IBAction)loginTapped:(id)sender;
- (IBAction)closeKeyboard:(id)sender;
//- (IBAction)backgroundTap:(id)sender;
- (void) login:(NSString *)requestInfo :(NSString *)identityInfo :(NSString *)data;
- (BOOL) checkVersion;
- (void) resettle;
- (void) readDefaults;
- (void) displayPasswordTapped;
- (void) autoLogin;

@end

