//
//  yxtForm4.h
//  yxt
//
//  Created by panht on 13-6-8.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yxtViewControllerBase.h"
#import "ALPickerView.h"
#import "CYCustomMultiSelectPickerView.h"

@interface yxtForm4 : yxtViewControllerBase <UIPickerViewDelegate, UIPickerViewDataSource, CYCustomMultiSelectPickerViewDelegate> {
    NSArray *dataSource1;
    UIPickerView *picker;
	NSArray *dataSource2;
    NSArray *dataSource2Selected;
	NSMutableDictionary *selectionStates;
    UILabel *showLbl;
    CYCustomMultiSelectPickerView *multiPickerView;
}
    
@property (strong, nonatomic) NSArray *dataSource1;
@property (strong, nonatomic) NSArray *dataSource2;
@property (strong, nonatomic) NSArray *dataSource2Selected;

@property (weak, nonatomic) IBOutlet UIButton *inputUser;
@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UISwitch *inputSMS;
@property (weak, nonatomic) IBOutlet UISwitch *inputWeibo;
@property (weak, nonatomic) IBOutlet UITextView *inputContent;
@property (weak, nonatomic) IBOutlet UIPickerView *inputPicker1;


- (IBAction)userTapped:(id)sender;
- (IBAction)send:(id)sender;

- (void) resettle;
- (void) loadData;
- (void) closePicker;
- (void) loadMultiPicker;
- (void) getData;

@end
