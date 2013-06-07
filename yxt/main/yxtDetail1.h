//
//  yxtDetail1.h
//  yxt
//
//  Created by world ask on 13-6-5.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yxtDetail1 : UIViewController

@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *title1;
@property (strong, nonatomic) NSString *title2;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *pageSize;
@property (strong, nonatomic) NSString *pageIndex;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UITextView *labelContent;

- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;

-(void) loadData;
-(void) setByAction: (NSString *)action;


@end
