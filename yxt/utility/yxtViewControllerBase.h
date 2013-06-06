//
//  yxtViewControllerBase.h
//  yxt
//
//  Created by world ask on 13-6-6.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yxtViewControllerBase : UIViewController <UITextFieldDelegate>  


@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;
- (void)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)backgroundTap:(id)sender;
-(IBAction)closeKeyboard:(id)sender;

@end
