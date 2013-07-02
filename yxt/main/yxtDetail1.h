//
//  yxtDetail1.h
//  yxt
//
//  Created by panht on 13-6-5.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yxtDetail1 : UIViewController <UIWebViewDelegate>{
    UIWebView *webView;
}


@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *title1;
@property (strong, nonatomic) NSString *title2;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *pageSize;
@property (strong, nonatomic) NSString *pageIndex;
@property (strong, nonatomic) NSString *recordCount;
@property (strong, nonatomic) NSArray *dataFiles;
@property (strong, nonatomic) NSString *assignmentID;


@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UITextView *labelContent;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;


- (IBAction)btn1Tapped:(id)sender;
- (IBAction)btn2Tapped:(id)sender;
- (IBAction)btn3Tapped:(id)sender;
- (IBAction)btn4Tapped:(id)sender;

- (IBAction)homeTapped:(id)sender;
- (IBAction)backTapped:(id)sender;

- (void) resettle;
- (void) loadData;
- (void) setByAction: (NSString *)action;
- (void) drawImage: (NSData *)fileData :(NSString *)filename :(NSInteger)seqNo :(NSInteger)tagNo;
- (void) loadDocument:(UIButton *)button;
- (void) closeWebView;

@end
