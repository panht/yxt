//
//  yxtIndex2.h
//  yxt
//
//  Created by panht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtList1;

@interface yxtTab2 : UIViewController

@property (nonatomic, strong) UIWindow *window;
@property (strong, nonatomic) IBOutlet yxtList1 *list1;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;

- (IBAction)button1Touch:(id)sender;
- (IBAction)button2Touch:(id)sender;
- (IBAction)button3Touch:(id)sender;
- (IBAction)button4Touch:(id)sender;
- (IBAction)button5Touch:(id)sender;
- (IBAction)button6Touch:(id)sender;

- (void) createIcons;

@end
