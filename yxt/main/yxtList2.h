//
//  yxtList2.h
//  yxt
//
//  Created by world ask on 13-6-9.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yxtList2 : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property BOOL flagLoadNext;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSString *classid;
@property (strong, nonatomic) NSString *pageSize;
@property (strong, nonatomic) NSString *pageIndex;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UIImage *image11;
@property (strong, nonatomic) UIImage *image12;

@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;


- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;
- (IBAction)btn1Tapped:(id)sender;
- (IBAction)btn2Tapped:(id)sender;
- (IBAction)btn3Tapped:(id)sender;

- (void) phoneTapped:(id)sender;
- (void) smsTapped:(id)sender;
- (void) resettle;
- (void) loadData;

@end
