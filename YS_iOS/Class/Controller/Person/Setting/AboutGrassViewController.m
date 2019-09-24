//
//  AboutGrassViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AboutGrassViewController.h"

#import "PlatformProfileViewController.h"
#import "UserProtocolViewController.h"

#define kIconViewHeight kWidth(167)

#import "BaseWKWebViewController.h"


@interface AboutGrassViewController ()

@end

@implementation AboutGrassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithSubviews];
    
}

#pragma mark - Init

- (void)initWithSubviews {

    self.navigationItem.titleView = [UILabel labelWithTitle:@"关于我们"];
    
    self.view.backgroundColor = kBackgroundColor;
    
    
    UIView *topBg = [[UIView alloc] init];
    topBg.lk_attribute
    .backgroundColor(kWhiteColor)
    .superView(self.view);
    
    [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(kIconViewHeight);
        make.left.right.top.mas_equalTo(0);
    }];
    
    
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kIconViewHeight)];
    
    [self.view addSubview:iconView];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_icon"]];
    
    [iconView addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(70);
        make.top.mas_equalTo(30);
        
    }];
    
    logoImage.layer.cornerRadius = kBorderCorner;
    logoImage.clipsToBounds = YES;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    
    NSString *verStr = [NSString stringWithFormat:@"v: %@", currentVersion];
    
    
    UILabel *versionLabel = [UILabel labelWithText:verStr textColor:kTextFirstLevelColor textFont:12];
    
    [iconView addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(logoImage.mas_bottom).mas_equalTo(12);
        
    }];
    
    NSArray *titleArray = @[@"简介", @"用户协议", @"给我们评分", @"检测版本"];
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UIView *contentView = [[UIView alloc] init];
        
        contentView.backgroundColor = kWhiteColor;
        
        [self.view addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(44);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(kIconViewHeight + i*44);
        }];
        
        UILabel *titleLabel = [UILabel labelWithText:titleArray[i] textColor:kBlackColor textFont:16.0];
        
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(0);
            
        }];
        
        UIImageView *rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_right"]];
        
        [contentView addSubview:rightIcon];
        [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.width.height.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        
        lineView.backgroundColor = kSeperateLineColor;
        
        [contentView addSubview:lineView];
        
        UIButton *clickBtn = [UIButton buttonWithImageName:@""];
        
        clickBtn.tag = 1300 + i;
        
        [clickBtn addTarget:self action:@selector(clickAboutGrass:) forControlEvents:UIControlEventTouchUpInside];

        [contentView addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(0);
        }];
    }
}

#pragma mark - Events

- (void)clickAboutGrass:(UIButton *)sender {

    NSInteger index = sender.tag - 1300;
    
    switch (index) {
        case 0:
            
        {
            
            BaseWKWebViewController *webviewVC = [[BaseWKWebViewController alloc] init];
            webviewVC.titleStr = @"平台简介";
            
            NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, kWebUrlAboutUs];
            
            [webviewVC wkWebViewRequestWithURL:url];
            
            [self.navigationController pushViewController:webviewVC animated:YES];
        }
            break;
        
        case 1:
            
        {
            BaseWKWebViewController *webviewVC = [[BaseWKWebViewController alloc] init];
            webviewVC.titleStr = @"注册协议";
            
            NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, kWebUrlRegistAgreement];
            
            [webviewVC wkWebViewRequestWithURL:url];
            
            [self.navigationController pushViewController:webviewVC animated:YES];
            
        }
            break;
            
        case 2:
            
        {
           
            NSString *str = [NSString stringWithFormat:
                             @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", kAPPID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
            break;
            
        case 3:
            
        {
            
            //检查版本更新
            [[Singleton sharedManager] checkUpdateWithVC:self];
            
        }
            break;
            
        default:
            break;
    }
}

@end
