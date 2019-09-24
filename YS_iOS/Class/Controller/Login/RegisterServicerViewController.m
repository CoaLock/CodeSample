//
//  RegisterServicerViewController.m
//  MaShangDao
//
//  Created by 崔露凯 on 15/9/9.
//  Copyright (c) 2015年 李华光. All rights reserved.
//

#import "RegisterServicerViewController.h"

@interface RegisterServicerViewController ()

@end

@implementation RegisterServicerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"用户协议"];
    
    [self initWithSubViews];

}

- (void)initWithSubViews {

    NSString *textFilePath = [[NSBundle mainBundle] pathForResource:@"servicerProvision" ofType:nil];
    NSString *text = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *attribute = @{
                                NSFontAttributeName:[UIFont systemFontOfSize:14]
                                };
    CGRect frame = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    CGFloat textHeight = CGRectGetHeight(frame);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    scrollView.backgroundColor = RGB(226, 226, 226);
    scrollView.contentSize = CGSizeMake(kScreenWidth, textHeight + 160);
    [self.view addSubview:scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 40)];
    titleLabel.text = @"“商超”注册服务条款";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = RGB(43, 41, 236);
    [scrollView addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, kScreenWidth - 30, textHeight)];
    textLabel.text = text;
    textLabel.font = [UIFont systemFontOfSize:14.0];
    textLabel.numberOfLines = 0;
    [scrollView addSubview:textLabel];
    
    UIButton *knowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    knowButton.frame = CGRectMake(30, CGRectGetMaxY(textLabel.frame) + 20, kScreenWidth - 60, 40);
    [knowButton setTitle:@"知道了" forState:UIControlStateNormal];
    [knowButton addTarget:self action:@selector(knowClick:) forControlEvents:UIControlEventTouchUpInside];
    knowButton.backgroundColor = RGB(69, 161, 34);
    knowButton.layer.cornerRadius = 5;
    [scrollView addSubview:knowButton];
}

- (void)knowClick:(UIButton*)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

@end
