//
//  yxtForm4.h
//  yxt
//
//  Created by panht on 13-6-8.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yxtViewControllerBase.h"

@interface yxtForm4 : yxtViewControllerBase <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *dataSource;
    UIPickerView *picker;
}


@end
