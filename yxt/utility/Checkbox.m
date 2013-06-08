//
//  Checkbox.m
//  yxt
//
//  Created by panht on 13-4-19.
//  Copyright (c) 2013年 com.landwing.yxt. All rights reserved.
//

#import "Checkbox.h"

@implementation Checkbox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder: (NSCoder *)aCoder {
    if (self = [super initWithCoder:aCoder]) {
        [self initilization];
    }
    return self;
}

- (void)initilization {
    [self removeTarget: self action: nil forControlEvents:UIControlEventTouchUpInside];
    [self addTarget: self action: @selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClick: (id)sender {
    self.selected = ![self isSelected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
