//
//  yxtForm2.h
//  yxt
//
//  Created by panht on 13-6-8.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yxtViewControllerBase.h"
@interface yxtForm2 : yxtViewControllerBase <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSArray *dataSource;
    UIPickerView *inputPicker;
}
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *dataListArray;
@property (strong, nonatomic) NSMutableArray *files;

@property (weak, nonatomic) IBOutlet UIButton *inputCourse;
@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UISwitch *inputSMS;
@property (weak, nonatomic) IBOutlet UISwitch *inputWeibo;
@property (weak, nonatomic) IBOutlet UITextView *inputContent;
@property (weak, nonatomic) IBOutlet UIPickerView *inputPicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnAlbum;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)courseTapped:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)albumTapped:(id)sender;
- (IBAction)photoTapped:(id)sender;

- (void) drawImage: (UIImage *)image :(NSInteger)seqNo;
- (void) delImage: (id)sender;
- (void) resettle;
- (void) loadData;
- (void) closePicker;

@end
