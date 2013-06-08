//
//  yxtList1.h
//  yxt
//
//  Created by panht on 13-5-29.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtDetail1;
@class yxtForm;
@class yxtForm1;

@interface yxtList1 : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet yxtDetail1 *detail1;
@property (strong, nonatomic) yxtForm *form;
@property (strong, nonatomic) yxtForm1 *form1;

@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *actionDetail;
@property (strong, nonatomic) NSString *title1;
@property (strong, nonatomic) NSString *title2;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *pageSize;
@property (strong, nonatomic) NSString *pageIndex;
@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;


- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;
- (IBAction)btn1Tapped:(id)sender;
- (IBAction)btn2Tapped:(id)sender;
- (IBAction)btn3Tapped:(id)sender;

- (void) loadData;
- (void) setByAction: (NSString *) action;

@end
