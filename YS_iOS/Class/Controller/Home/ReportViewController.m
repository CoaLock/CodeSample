//
//  ReportViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/30.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ReportViewController.h"

#import "ReportApi.h"

@interface ReportViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *feedTV;

@property (nonatomic, strong) UITextField *placeHolderTF;


@end

@implementation ReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"举报原因"];
    
    self.view.backgroundColor = kBackgroundColor;
    
    
    
    [self initWithSubviews];
}

#pragma mark - Init

- (void)initWithSubviews {
    
    
    [UIBarButtonItem addRightItemWithTitle:@"提交" frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(clickFeedbackCommit:)];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 190)];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    
    
    _feedTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth -20, 190)];
    _feedTV.font = Font(16.0);
    
    _feedTV.delegate = self;
    [bgView addSubview:_feedTV];
    
    
    _placeHolderTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 8, 300, 20)];
    _placeHolderTF.placeholder = @"请输入举报原因...";
    _placeHolderTF.userInteractionEnabled = NO;
    _placeHolderTF.font = Font(15);
    [bgView addSubview:_placeHolderTF];
    
    
}

- (void)clickFeedbackCommit:(UIButton *)sender {
    
    NSString *textStr = _feedTV.text;
    if (textStr.length == 0) {
        
        [self showErrorMsg:@"请输入您的意见哦"];
        return;
    }
    
    ReportApi *reportApi = [[ReportApi alloc] init];
    [reportApi reportWithType:_type relationId:_relationId description:textStr callback:^(id resultData, NSInteger code) {
       
        if (code == 0) {
            
            [self showErrorMsg:@"提交成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
        
    }];
    
}


#pragma mark - UITextFieldDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (textView.text.length > 0) {
        _placeHolderTF.hidden = YES;
    }
    else {
        _placeHolderTF.hidden = NO;
    }
}










@end
