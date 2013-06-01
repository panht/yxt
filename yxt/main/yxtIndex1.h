//
//  yxtIndex1.h
//  yxt
//
//  Created by pht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtList1;

@interface yxtIndex1 : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

- (IBAction)button1Touch:(id)sender;
- (IBAction)button2Touch:(id)sender;
- (IBAction)button3Touch:(id)sender;
- (IBAction)button4Touch:(id)sender;

@property (strong, nonatomic) IBOutlet UIViewController *list1;

- (void) createIcons;
- (void) openList;

@end
