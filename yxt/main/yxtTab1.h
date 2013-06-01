//
//  yxtTab1.h
//  yxt
//
//  Created by world ask on 13-5-31.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtList1;
@interface yxtTab1 : UIViewController


@property (nonatomic, strong) UIWindow *window;
@property (strong, nonatomic) IBOutlet UIViewController *list1;

- (IBAction)btn1Tapped:(id)sender;
- (IBAction)btn2Tapped:(id)sender;
- (IBAction)btn3Tapped:(id)sender;
- (IBAction)btn4Tapped:(id)sender;


- (void) createIcons;

@end
