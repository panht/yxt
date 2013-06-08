//
//  yxtForm3.h
//  yxt
//
//  Created by panht on 13-6-8.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yxtViewControllerBase.h"

@interface yxtForm3 : yxtViewControllerBase <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *dataSource;
    UIPickerView *picker;
}

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *dataListArray1;
@property (strong, nonatomic) NSArray *dataListArray2;
@property (strong, nonatomic) NSArray *dataListArray3;

@property (weak, nonatomic) IBOutlet UISegmentedControl *inputType;
@property (weak, nonatomic) IBOutlet UIButton *inputName;
@property (weak, nonatomic) IBOutlet UIButton *inputClass;
@property (weak, nonatomic) IBOutlet UIButton *inputSubject;
@property (weak, nonatomic) IBOutlet UISwitch *inputMemo;
@property (weak, nonatomic) IBOutlet UISwitch *inputMessage;
@property (weak, nonatomic) IBOutlet UISwitch *inputSMS;
@property (weak, nonatomic) IBOutlet UISwitch *inputWeibo;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)nameTapped:(id)sender;
- (IBAction)classTapped:(id)sender;
- (IBAction)subjectTapped:(id)sender;
- (IBAction)send:(id)sender;

- (void) resettle;
- (void) loadData;
- (void) closePicker;

@end
