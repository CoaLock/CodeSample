//
//  RegisterAgreementView.m
//  BS
//
//  Created by 崔露凯 on 16/6/13.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "RegisterAgreementView.h"

@implementation RegisterAgreementView


- (void)createSubview {
    
    UIView *effectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    effectView.backgroundColor = [UIColor blackColor];
    effectView.alpha = 0.3;
    [self addSubview:effectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close_service_ic"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(kScreenWidth - 24 -12, 41, 24, 24);
    [self addSubview:button];

    CGFloat widthWhite = kScreenWidth - 24;
    CGFloat heightWhite = kScreenHeight - 80 - 20;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(12, 80, widthWhite, heightWhite)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 8;
    [self addSubview:whiteView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, widthWhite, 20)];
    titleLabel.text = @"点购到家注册使用协议";
    titleLabel.font = boldFont(20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 60, widthWhite - 30, heightWhite - 60 -20)];
    textView.editable = NO;
    textView.font = Font(14.0);
    textView.textColor = [UIColor colorWithHexString:@"#323232"];
    [whiteView addSubview:textView];
    
    NSString *textFilePath = [[NSBundle mainBundle] pathForResource:@"servicerProvision" ofType:nil];
    NSString *text = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    textView.text = text;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      
        self.backgroundColor = [UIColor clearColor];
        
        [self createSubview];
    }
    return self;
}


- (void)closeAction {

    [self removeFromSuperview];
}


@end
