//
//  yxtList1.h
//  yxt
//
//  Created by world ask on 13-5-29.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class yxtDetail1;

@interface yxtList1 : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet yxtDetail1 *detail1;

@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *pageSize;
@property (strong, nonatomic) NSString *pageIndex;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;

- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;

-(void) loadData;

@end
