//
//  yxtList1.m
//  yxt
//
//  Created by world ask on 13-5-29.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtList1.h"

@interface yxtList1 ()

@end

@implementation yxtList1

@synthesize tableView1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView1:nil];
    [super viewDidUnload];
}
@end
