//
//  FeedbackViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackApi.h"


@interface FeedbackViewController () <UITextViewDelegate>


@property (nonatomic, strong) UITextView *feedTV;

@property (nonatomic, strong) UITextField *placeHolderTF;


@end

@implementation FeedbackViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"意见反馈"];

    self.view.backgroundColor = kBackgroundColor;

    
    
    [self initWithSubviews];
}

#pragma mark - Init

- (void)initWithSubviews {

//    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14.0];
//    
//    commitBtn.frame = CGRectMake(0, 0, 30, 30);
//    [commitBtn addTarget:self action:@selector(clickFeedbackCommit:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    [UIBarButtonItem addRightItemWithTitle:@"提交" frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(clickFeedbackCommit:)];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 190)];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    
    
    _feedTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth -20, 190)];
    _feedTV.font = Font(16.0);
    
    _feedTV.delegate = self;
    [bgView addSubview:_feedTV];
    
    
    _placeHolderTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 8, 300, 20)];
    _placeHolderTF.placeholder = @"有什么意见或者好的建议统统告诉我们吧。";
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
    
    FeedbackApi *feedBackApi = [[FeedbackApi alloc] init];
    [feedBackApi feedbackWithContents:textStr callback:^(id resultData, NSInteger code) {
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
