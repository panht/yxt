//
//  yxtDetail1.m
//  yxt
//
//  Created by panht on 13-6-5.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "yxtDetail1.h"
#import "yxtAppDelegate.h"
#import "yxtUtil.h"
#import "MBProgressHUD.h"

@interface yxtDetail1 ()

@end

@implementation yxtDetail1

@synthesize action;
@synthesize type;
@synthesize title1;
@synthesize title2;
@synthesize content;
@synthesize data;
@synthesize pageIndex;
@synthesize pageSize;
@synthesize recordCount;
@synthesize dataFiles;
@synthesize assignmentID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) setByAction: (NSString *)action{
    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *boxtype;
    
    if ([self.action isEqualToString:@"bulletinContent"]) {
        self.navTitle.title = @"通知公告 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", self.type, app.userId]];
    } else if ([self.action isEqualToString:@"homeworkContent"]) {
        if ([app.loginType isEqualToString:@"1"]) {
            boxtype = @"outbox";
        } else {
            boxtype = @"inbox";
        }
        
        self.navTitle.title = @"家庭作业 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", boxtype, app.userId]];
    } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
        self.navTitle.title = @"成绩信息 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
    } else if ([self.action isEqualToString:@"selectExamReceiveMsgDetail"]) {
        self.navTitle.title = @"成绩信息 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@""]];
    } else if ([self.action isEqualToString:@"reviewsConetent"]) {
        if ([app.loginType isEqualToString:@"1"]) {
            boxtype = @"outbox";
        } else {
            boxtype = @"inbox";
        }
        
        self.navTitle.title = @"日常表现 >> 详细内容";
        self.data = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"boxtype\":\"%@\", \"userid\":\"%@\"}]", boxtype, app.userId]];
    }
}

- (IBAction)btn1Tapped:(id)sender {
    // 从界面删除所有图片
    for (UIView *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    [self setPageIndex:@"1"];
    [self loadData];
}

- (IBAction)btn2Tapped:(id)sender {
    // 从界面删除所有图片
    for (UIView *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    NSInteger intPageIndex = [self.pageIndex integerValue];
    
    intPageIndex--;
    if (intPageIndex < 1) {
        intPageIndex = 1;
    }
    
    [self setPageIndex:[NSString stringWithFormat:@"%d", intPageIndex]];
    [self loadData];
}

- (IBAction)btn3Tapped:(id)sender {
    // 从界面删除所有图片
    for (UIView *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    NSInteger intPageIndex = [self.pageIndex integerValue];
    NSInteger recordcount = [self.recordCount integerValue];
    
    intPageIndex++;
    if (intPageIndex > recordcount) {
        intPageIndex = recordcount;
    }
    
    [self setPageIndex:[NSString stringWithFormat:@"%d", intPageIndex]];
    [self loadData];
}

- (IBAction)btn4Tapped:(id)sender {
    // 从界面删除所有图片
    for (UIView *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    [self setPageIndex:self.recordCount];
    [self loadData];
}

- (IBAction)homeTapped:(id)sender {
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *list1View = [topWindow viewWithTag:300];
    [self.view removeFromSuperview];
    [list1View removeFromSuperview];
}

- (IBAction)backTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (void) loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *requestInfo;
        NSString *identityInfo;
        identityInfo = [[NSString alloc] initWithString:[yxtUtil setIdentityInfo]];
        requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:self.action :self.pageIndex :self.pageSize :identityInfo :self.data]];
    
//    NSLog(@"requestInfo    %@", requestInfo);
//    NSLog(@"identityInfo    %@", identityInfo);
//    NSLog(@"data     %@", self.data);
        // 从服务端获取数据
        NSDictionary *dataResponse = [yxtUtil getResponse:requestInfo :identityInfo :self.data];
        
        if ([[dataResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
            // 总记录数，用于翻页
            self.recordCount = [dataResponse objectForKey:@"recordcount"];
            
            NSData *dataList = [[dataResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                     options:kNilOptions
                                                                       error:&error];
            
            NSArray *dataListArray = [jsonList objectForKey:@"list"];
            NSDictionary *row = [dataListArray objectAtIndex:0];
            
            int x, y, width, height;
            x = 5;
            y = self.navBar.frame.size.height + 5;
            width = self.view.frame.size.width - x * 2;
            height = 25;
            int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
            
            [self.view bringSubviewToFront:self.labelContent];
            [self.labelContent setClipsToBounds:YES];
            
            // 数据绑定到控件
            NSString *detailTitle;
            NSString *DetailContent;
            
            if ([self.action isEqualToString:@"bulletinContent"]) {
                // 通知公告
                detailTitle = [row objectForKey:@"msg_title"];
                detailTitle = [yxtUtil replacePercent:detailTitle];
                DetailContent = [row objectForKey:@"bulletin_content"];
                DetailContent = [yxtUtil replacePercent:DetailContent];
                
                self.label1.text = detailTitle;
                self.label2.text = [NSString stringWithFormat:@"发件人：%@  消息类型：通知公告", [row objectForKey:@"user_name"]];
                self.label3.text = [NSString stringWithFormat:@"时间：%@", [row objectForKey:@"rec_date"]];
                self.labelContent.text = DetailContent;
                
                // 标题多行显示
                NSInteger lines;
                // 取法向上取整 (A + B - 1) / B
                lines = ([detailTitle length] + (18 - 1)) / 18;
                self.label1.numberOfLines = lines;
                
                self.label1.frame = CGRectMake(x, y, width, height * lines);
                self.label2.frame = CGRectMake(x, y + height * lines, width, height);
                self.label3.frame = CGRectMake(x, y + height * (lines + 1), width, height);
                int heightContent = self.view.frame.size.height - height * (lines + 2) - self.navBar.frame.size.height * 2 - statusBarHeight - 10;
                self.labelContent.frame = CGRectMake(x, y + height * (lines + 2), width, heightContent);
                
                self.label1.textAlignment = UITextAlignmentCenter;
                self.label2.textAlignment = UITextAlignmentCenter;
                self.label3.textAlignment = UITextAlignmentCenter;
                self.label2.textColor =  [UIColor grayColor];
                self.label3.textColor =  [UIColor grayColor];
                self.label2.font = [UIFont systemFontOfSize:12];
                self.label3.font = [UIFont systemFontOfSize:12];
                self.labelContent.font = [UIFont systemFontOfSize:14];
            } else if ([self.action isEqualToString:@"homeworkContent"]) {
                // 家庭作业
                detailTitle = [row objectForKey:@"ass_title"];
                detailTitle = [yxtUtil replacePercent:detailTitle];
                DetailContent = [row objectForKey:@"ass_content"];
                DetailContent = [yxtUtil replacePercent:DetailContent];
                self.label1.text = [NSString stringWithFormat:@"作业课程：%@", [row objectForKey:@"course_name"]];
                self.label2.text = [NSString stringWithFormat:@"发  送  人：%@", [row objectForKey:@"user_name"]];
                self.label3.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"rec_date"]];
                self.label4.text = [NSString stringWithFormat:@"作业标题：%@", detailTitle];
                self.labelContent.text = DetailContent;
                
                // 标题多行显示
                NSInteger lines;
                // 取法向上取整 (A + B - 1) / B
                lines = ([detailTitle length] + 5 + (18 - 1)) / 18;
                self.label4.numberOfLines = lines;
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
                self.label3.frame = CGRectMake(x, y + height * 2, width, height);
                self.label4.frame = CGRectMake(x, y + height * 3, width, height * lines);
                self.scrollView.frame = CGRectMake(0, self.view.frame.size.height - 64 - self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
                self.labelContent.frame = CGRectMake(x, y + height * (3 + lines), width, self.view.frame.size.height - height * (3 + lines) - self.navBar.frame.size.height * 2 - self.scrollView.frame.size.height- statusBarHeight - 5);
                
                [self.scrollView setClipsToBounds:YES];
                
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
                self.label3.textAlignment = UITextAlignmentLeft;
                self.label4.textAlignment = UITextAlignmentLeft;
                
                // 家庭作业需要判断是否有附件
                self.assignmentID = [row objectForKey:@"assignment_id"];
                NSString *dataHomework = [[NSString alloc] initWithString:[NSString stringWithFormat:@"[{\"assignmentid\":\"%@\"}]", self.assignmentID]];
                requestInfo = [[NSString alloc] initWithString:[yxtUtil setRequestInfo:@"getHomeWorkFile" :@"1" :@"5" :identityInfo :dataHomework]];
                NSDictionary *dataHomeworkResponse = [yxtUtil getResponse:requestInfo :identityInfo :dataHomework];
                
                if ([[dataHomeworkResponse objectForKey:@"resultcode"] isEqualToString: @"0"]) {
                    NSData *dataList = [[dataHomeworkResponse objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error;
                    NSDictionary *jsonList = [NSJSONSerialization JSONObjectWithData:dataList
                                                                             options:kNilOptions
                                                                               error:&error];
                    
                    self.dataFiles = [jsonList objectForKey:@"list"];
                    
                    // 遍历数组，将附件显示到界面
                    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
                    NSInteger i = 0, j = 0;
                    NSString *filename, *filepath;
                    NSURL *fileURL;
                    NSData *fileData;
                    
                    for (NSDictionary *rowData in self.dataFiles) {
                        filename = [rowData objectForKey:@"filename"];
                        filepath = [rowData objectForKey:@"filepath"];
                        
                        // 判断本地是否已保存
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsPath = [paths objectAtIndex:0];
                        NSString *filenameLocal = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", self.assignmentID, filename]];
                        fileData = [NSData dataWithContentsOfFile:filenameLocal];
                        
                        if (fileData != NULL) {
                        } else {
                            // 否则从服务器获取
                            fileURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", app.urlFile, filepath]];
                            fileData = [NSData dataWithContentsOfURL:fileURL];
                            
                            if (fileData != NULL) {
                                //  保存为本地文件
                                [fileData writeToFile:filenameLocal atomically:YES];
                            } else {
                            }
                        }
                        
                        // 文件是否存在
                        if (fileData != NULL) {
                            [self drawImage:fileData :filenameLocal :i :j];
                            i++;
                        }
                        j++;
                    }
                    self.scrollView.contentSize = CGSizeMake(i * 60, self.scrollView.contentSize.height);
//                    [self.scrollView setNeedsDisplay];
                    
                    // 处理webview
                    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
                    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
                    
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, screenHeight - 44)];
                    [webView setDelegate:self];
                    [webView setScalesPageToFit:YES];
                    [self.view addSubview:webView];
                    [webView setHidden:YES];
                } else {
                    [yxtUtil warning:self.view :[dataHomeworkResponse objectForKey:@"resultdes"]];
                }
            } else if ([self.action isEqualToString:@"selectExamSendMsg"]) {
                self.label1.text = [NSString stringWithFormat:@"标题：%@", [row objectForKey:@"msg_title"]];
                self.label2.text = [NSString stringWithFormat:@"考试班级：%@", [row objectForKey:@"class_name"]];
                self.label3.text = [NSString stringWithFormat:@"考试科目：%@", [row objectForKey:@"course_name"]];
                self.label4.text = [NSString stringWithFormat:@"发送备注：%@", [[row objectForKey:@"send_remark"] isEqualToString:@"1"] ? @"是" : @"否"];
                self.label5.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"op_date"]];
                
                
                // 标题多行显示
                NSInteger lines;
                // 取法向上取整 (A + B - 1) / B
                lines = ([[row objectForKey:@"msg_title"] length] + 3 + (18 - 1)) / 18;
                self.label1.numberOfLines = lines;
                
                self.label1.frame = CGRectMake(x, y, width, height * lines);
                self.label2.frame = CGRectMake(x, y + height * lines, width, height);
                self.label3.frame = CGRectMake(x, y + height * (lines + 1), width, height);
                self.label4.frame = CGRectMake(x, y + height * (lines + 2), width, height);
                self.label5.frame = CGRectMake(x, y + height * (lines + 3), width, height);
                
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
                self.label3.textAlignment = UITextAlignmentLeft;
                self.label4.textAlignment = UITextAlignmentLeft;
                self.label5.textAlignment = UITextAlignmentLeft;
            } else if ([self.action isEqualToString:@"selectExamReceiveMsgDetail"]) {
                self.label1.text = [NSString stringWithFormat:@"发送者：%@", [row objectForKey:@"user_name"]];
                self.label2.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"op_date"]];
                self.labelContent.text = [row objectForKey:@"msg_content"];
                
                self.label1.frame = CGRectMake(x, y, width, height);
                self.label2.frame = CGRectMake(x, y + height, width, height);
//                self.labelContent.frame = CGRectMake(x, y + height * 2, width, height);
                int heightContent = self.view.frame.size.height - height * 2 - self.navBar.frame.size.height * 2 - statusBarHeight - 10;
                self.labelContent.frame = CGRectMake(x, y + height * 2, width, heightContent);
                
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
//                self.label3.textAlignment = UITextAlignmentLeft;
            } else if ([self.action isEqualToString:@"reviewsConetent"]) {
                // 日常表现
                detailTitle = [row objectForKey:@"title"];
                detailTitle = [yxtUtil replacePercent:detailTitle];
                DetailContent = [row objectForKey:@"content"];
                DetailContent = [yxtUtil replacePercent:DetailContent];
                
                self.label1.text = [NSString stringWithFormat:@"发件人：%@", [row objectForKey:@"user_name"]];
                self.label2.text = detailTitle;
                self.label3.text = [NSString stringWithFormat:@"发送时间：%@", [row objectForKey:@"announce_date"]];
                self.labelContent.text = DetailContent;
                
                // 标题多行显示
                NSInteger lines1, lines2;
                // 取法向上取整 (A + B - 1) / B
                lines1 = ([[row objectForKey:@"user_name"] length] + 4 + (18 - 1)) / 18;
                self.label1.numberOfLines = lines1;
                lines2 = ([detailTitle length] + (18 - 1)) / 18;
                self.label2.numberOfLines = lines2;
                
                self.label1.frame = CGRectMake(x, y, width, height * lines1);
                self.label2.frame = CGRectMake(x, y + height * lines1, width, height * lines2);
                self.label3.frame = CGRectMake(x, y + height * (lines1 + lines2), width, height);
                int heightContent = self.view.frame.size.height - height * (lines1 + lines2 + 1) - self.navBar.frame.size.height * 3 - statusBarHeight - 10;
                self.labelContent.frame = CGRectMake(x, y + height * (lines1 + lines2 + 1), width, heightContent);
                
                self.label1.textAlignment = UITextAlignmentLeft;
                self.label2.textAlignment = UITextAlignmentLeft;
                self.label3.textAlignment = UITextAlignmentLeft;
                self.label3.textColor =  [UIColor grayColor];
                self.label3.font = [UIFont systemFontOfSize:12];
            }
        } else {
            [yxtUtil warning:self.view :[dataResponse objectForKey:@"resultdes"]];
        }
    
    // 如果是成绩信息，置为已读
//    if ([self.action isEqualToString:@"selectExamReceiveMsgDetail"]) {
//    }
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

// 显示图片
- (void) drawImage: (NSData *)fileData :(NSString *)fileName :(NSInteger)seqNo :(NSInteger)tagNo {
    int xOffset = seqNo * 60;
    // 添加imgaeView
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image;
    
    // 判断是否图片
    if ([[fileName pathExtension] isEqualToString:@"jpg"] || [[fileName pathExtension] isEqualToString:@"jpeg"] || [[fileName pathExtension] isEqualToString:@"png"] ||[[fileName pathExtension] isEqualToString:@"bmp"] ||[[fileName pathExtension] isEqualToString:@"gif"]) {
        image = [UIImage imageWithData:fileData];
    } else if ([[fileName pathExtension] isEqualToString:@"doc"] || [[fileName pathExtension] isEqualToString:@"docx"] || [[fileName pathExtension] isEqualToString:@"xls"] || [[fileName pathExtension] isEqualToString:@"xlsx"] || [[fileName pathExtension] isEqualToString:@"pdf"] || [[fileName pathExtension] isEqualToString:@"txt"] || [[fileName pathExtension] isEqualToString:@"ppt"] || [[fileName pathExtension] isEqualToString:@"pptx"]) {
        image = [UIImage imageNamed:@"attachment.png"];
    }
    [btn addTarget:self action:@selector(loadDocument:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTag:tagNo];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(15 - 10 + xOffset, 5, 50, 50);
    [self.scrollView addSubview:btn];
}

// 在webview打开
- (void) loadDocument:(UIButton *)button {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSDictionary *rowData = [self.dataFiles objectAtIndex:button.tag];
        NSString *filename = [rowData objectForKey:@"filename"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filenameLocal = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", self.assignmentID, filename]];
        NSURL *fileURL = [NSURL fileURLWithPath:filenameLocal];
        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        
//        NSString *filename = [[NSString alloc] initWithFormat:@"%@%@", app.urlFile, [rowData objectForKey:@"filename"]];
//        NSURL *fileURL = [NSURL URLWithString:filepath];
//        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        
        [self.btnBack removeTarget:self action:@selector(backTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnBack  addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    
    @try {
        [webView loadRequest:request];
        [webView setHidden:NO];
    }
    @catch (NSException *exception) {
        [yxtUtil warning:self.view :@"无法打开这个附件"];
    }
    @finally {
    }
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    });
}

- (void) closeWebView {
    [self.btnBack removeTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBack addTarget:self action:@selector(backTapped:) forControlEvents:UIControlEventTouchUpInside];
    [webView loadHTMLString:@"" baseURL:nil];
    [webView setHidden:YES];
}

// 调用app打开文件
//- (void) loadDocument2:(UIButton *)button {
//    yxtAppDelegate *app = (yxtAppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSDictionary *rowData = [self.dataFiles objectAtIndex:button.tag];
//    NSString *filepath = [[NSString alloc] initWithFormat:@"%@%@", app.urlFile, [rowData objectForKey:@"filepath"]];
//    // 从服务器获取
//    NSURL *fileURL = [NSURL URLWithString:filepath];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:fileURL]) {
//        uidController = [[UIDocumentInteractionController alloc] init];
//        uidController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filepath]];
//        
//        
//        // 判断扩展名
//        NSString *filename = [rowData objectForKey:@"filename"];
//        if ([[filename pathExtension] isEqualToString:@"doc"] || [[filename pathExtension] isEqualToString:@"docx"]) {
//            uidController.UTI = @"com.microsoft.word.doc";
//        } else if ([[filename pathExtension] isEqualToString:@"xls"] || [[filename pathExtension] isEqualToString:@"xlsx"]) {
//            uidController.UTI = @"com.microsoft.excel.xls";
//        } else if ([[filename pathExtension] isEqualToString:@"ppt"] || [[filename pathExtension] isEqualToString:@"pptx"]) {
//            uidController.UTI = @"com.microsoft.powerpoint.ppt";
//        } else if ([[filename pathExtension] isEqualToString:@"pdf"]) {
//            uidController.UTI = @"com.adobe.pdf";
//        } else if ([[filename pathExtension] isEqualToString:@"txt"]) {
//            uidController.UTI = @"public.plain-text";
//        } else if ([[filename pathExtension] isEqualToString:@"gif"]) {
//            uidController.UTI = @"com.compuserve.gif";
//        } else if ([[filename pathExtension] isEqualToString:@"png"]) {
//            uidController.UTI = @"public.png";
//        } else if ([[filename pathExtension] isEqualToString:@"bmp"]) {
//            uidController.UTI = @"com.microsoft";
//        } else if ([[filename pathExtension] isEqualToString:@"jpg"] || [[filename pathExtension] isEqualToString:@"jpeg"]) {
//            uidController.UTI = @"public.jpeg";
//        }
//        
//        uidController.delegate = self;
//        CGRect navRect = self.view.frame;
//        
//        [uidController presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
//    }
//}

// 保存到相册
//- (void) saveFile:(id)sender {
//    UIButton *btn = (UIButton*)sender;
//    UIImageWriteToSavedPhotosAlbum(btn.imageView.image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
//}
//
//// 保存完成
//- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
//    if (error) {
//        // Do anything needed to handle the error or display it to the user
//    } else {
//         [yxtUtil message:self.view :@"已保存到相册"];
//    }
//}

- (void) resettle {
    // 导航栏背景图
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"backgroundNav.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 获得屏幕宽高
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // 底部按钮
    int x, y, width, height;
    x = 0;
    y = screenHeight - statusBarHeight - self.navBar.frame.size.height;
    width = screenWidth / 4 - 2;
    height = self.navBar.frame.size.height;
    self.btn1.frame = CGRectMake(x, y, width, height);
    self.btn2.frame = CGRectMake(x + width + 2, y, width, height);
    self.btn3.frame = CGRectMake(x + width * 2 + 4, y, width, height);
    self.btn4.frame = CGRectMake(x + width * 3 + 6, y, width + 2, height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resettle];
    
    [self setByAction:self.action];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabel1:nil];
    [self setLabel2:nil];
    [self setLabelContent:nil];
    [self setNavTitle:nil];
    [self setLabel3:nil];
    [self setLabel4:nil];
    [self setLabel5:nil];
    [self setNavBar:nil];
    [self setBtn1:nil];
    [self setBtn2:nil];
    [self setBtn3:nil];
    [self setBtn4:nil];
    [self setScrollView:nil];
    [self setBtnBack:nil];
    [super viewDidUnload];
}
@end
