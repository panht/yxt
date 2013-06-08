//
//  yxtTab1.h
//  yxt
//
//  Created by panht on 13-5-31.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtList1;

@interface yxtTab1 : UIViewController

@property (nonatomic, strong) UIWindow *window;
@property (strong, nonatomic) IBOutlet yxtList1 *list1;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;

- (IBAction)btn1Tapped:(id)sender;
- (IBAction)btn2Tapped:(id)sender;
- (IBAction)btn3Tapped:(id)sender;
- (IBAction)btn4Tapped:(id)sender;


- (void) createIcons;
- (void) showList1: (NSString *)action;

@end
