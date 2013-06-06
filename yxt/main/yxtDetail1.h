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
@property (strong, nonatomic) NSString *pageSize;
@property (strong, nonatomic) NSString *pageIndex;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UITextView *labelContent;

- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;

-(void) loadData;

@end
