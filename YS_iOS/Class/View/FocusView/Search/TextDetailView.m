//
//  TextDetailView.m
//  BS
//
//  Created by 张阳 on 16/4/8.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "TextDetailView.h"

@implementation TextDetailView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        
        
        UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth -144)/2.0, 22, 144, 1)];
        lineH.backgroundColor = kSeperateLineColor;
        [self addSubview:lineH];
        
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 84)/2, 12, 84, 20)];
        _textLabel.text = text;
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = kTextSecondLevelColor;
        _textLabel.font = Font(16);
        [self addSubview:_textLabel];
        
        
        UIView *lineH1 = [[UIView alloc] init];
        lineH1.lk_attribute
        .backgroundColor(kSeperateLineColor)
        .superView(self);
        
        [lineH1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
    }
   
    return self;
}

@end
