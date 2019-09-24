//
//  PublishPerformViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/14.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishPerformViewController.h"

@interface PublishPerformViewController ()


@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;


@end

@implementation PublishPerformViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"发布审核"];
    
    _submitBtn.lk_attribute
    .backgroundColor(kAppCustomMainColor);
    
    _iconImgView.image = [[UIImage imageNamed:@"ic_publish_success"] imageWithColor:kAppCustomMainColor];
    
    
    [UIBarButtonItem addLeftItemWithImageName:@"ic_return_wihte" frame:CGRectMake(0, 0, 11, 20) vc:self action:@selector(dismissController:)];

}

// 禁用侧滑 返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return NO;
}


- (void)dismissController:(UIButton*)button {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)sureAction:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
