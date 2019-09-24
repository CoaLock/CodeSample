//
//  BlankDisplayView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/17.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BlankDisplayView.h"

@implementation BlankDisplayView


- (instancetype)initWithFrame:(CGRect)frame img:(NSString*)imgName title:(NSString*)title bgColor:(UIColor*)color {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.lk_attribute
        .image([UIImage imageNamed:imgName])
        .superView(self);
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(kWidth(100));
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(kWidth(70));
            make.height.mas_equalTo(kWidth(70));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.lk_attribute
        .text(title)
        .textAlignment(NSTextAlignmentCenter)
        .font(14)
        .numberLines(0)
        .textColor(kTextSecondLevelColor)
        .superView(self);
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(imgView.mas_bottom).offset(kWidth(40));
            make.centerX.mas_equalTo(0);
        }];

        
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.lk_attribute
        .backgroundColor(kAppCustomMainColor)
        .normalTitleColor(kWhiteColor)
        .font(14)
        .corner(kBorderCorner)
        .superView(self);
        
        _skipBtn.hidden = YES;
        
        [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(label.mas_bottom).mas_offset(17);
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(44);
 
        }];
        
    }
    return self;
}

- (void)shouldShow:(BOOL)shouldShow {

    _bindedView.hidden = shouldShow;
    self.hidden = !shouldShow;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    
    [[self nextResponder] touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder] touchesEnded:touches withEvent:event];
    
    [super touchesEnded:touches withEvent:event];
}




@end
