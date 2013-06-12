//
//  yxtList1.h
//  yxt
//
//  Created by panht on 13-5-29.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtDetail1;
@class yxtList2;
@class yxtForm;
@class yxtForm1;

@interface yxtList1 : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property BOOL flagLoadNext;
@property NSInteger lastOffsetY;
@property (strong, nonatomic) IBOutlet yxtList2 *list2;
@property (strong, nonatomic) IBOutlet yxtDetail1 *detail1;
@property (strong, nonatomic) yxtForm *form;
@property (strong, nonatomic) yxtForm1 *form1;

@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSString *classid;
@property (strong, nonatomic) NSString *actionDetail;
@property (strong, nonatomic) NSString *title1;
@property (strong, nonatomic) NSString *title2;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *pageSize;
@property (strong, nonatomic) NSString *pageIndex;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UIImage *image11;
@property (strong, nonatomic) UIImage *image12;
@property (strong, nonatomic) UIImage *image21;
@property (strong, nonatomic) UIImage *image22;

@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;


- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;
- (IBAction)btn0Tapped:(id)sender;
- (IBAction)btn1Tapped:(id)sender;
- (IBAction)btn2Tapped:(id)sender;

- (void) loadData;
- (void) setByAction: (NSString *) action;

@end
