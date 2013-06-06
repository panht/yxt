//
//  yxtFormUser.h
//  yxt
//
//  Created by world ask on 13-6-5.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yxtFormUser : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageHead;
@property (weak, nonatomic) IBOutlet UITextField *oldpwd;
@property (weak, nonatomic) IBOutlet UITextField *newpwd1;
@property (weak, nonatomic) IBOutlet UITextField *newpwd2;

- (IBAction)chooseHead:(id)sender;
- (IBAction)save:(id)sender;

@end
