//
//  yxtForm1.h
//  yxt
//
//  Created by panht on 13-6-1.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yxtViewControllerBase.h"

@interface yxtForm1 : yxtViewControllerBase <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *dataSource;
    UIPickerView *picker;
}

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *dataListArray;

@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;
@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UIButton *inputScope;
@property (weak, nonatomic) IBOutlet UIButton *inputTarget;
@property (weak, nonatomic) IBOutlet UISwitch *inputSMS;
@property (weak, nonatomic) IBOutlet UISwitch *inputWeibo;
@property (weak, nonatomic) IBOutlet UITextView *inputContent;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)scopeTapped:(id)sender;
- (IBAction)targetTapped:(id)sender;
- (IBAction)send:(id)sender;

- (void) resettle;
- (void) loadData;
- (void) closePicker;

@end
