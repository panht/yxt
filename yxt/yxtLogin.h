//
//  yxtLogin.h
//  yxt
//
//  Created by pht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yxtLogin : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;

- (IBAction)login:(id)sender;
- (IBAction)closeKeyboard:(id)sender;
- (void)resettle;
- (void)readDefaults;


@end
//@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
//@property (strong, nonatomic) IBOutlet UIImageView *imageViewLogo;
//@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
//@property (strong, nonatomic) IBOutlet UILabel *labelPassword;

//- (IBAction)backgroundTap:(id)sender;
