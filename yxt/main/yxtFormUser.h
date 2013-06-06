//
//  yxtFormUser.h
//  yxt
//
//  Created by world ask on 13-6-5.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yxtViewControllerBase.h"

@interface yxtFormUser : yxtViewControllerBase <UIImagePickerControllerDelegate, UINavigationControllerDelegate> { }
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;

@property (strong, nonatomic) UIImage *imageOld;
@property (strong, nonatomic) UIImage *imageNew;
@property (weak, nonatomic) IBOutlet UIImageView *imageHead;
@property (weak, nonatomic) IBOutlet UITextField *oldpwd;
@property (weak, nonatomic) IBOutlet UITextField *newpwd1;
@property (weak, nonatomic) IBOutlet UITextField *newpwd2;

- (IBAction)chooseHead:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;

@end
