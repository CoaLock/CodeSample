//
//  LaunchController.m
//  BS
//
//  Created by 崔露凯 on 16/5/5.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "LaunchController.h"

#import "UserDefaultsUtil.h"

#import "GetConfigApi.h"

#import "AppDelegate.h"

#import "MainDrawerController.h"


@interface LaunchController ()

@property (nonatomic, strong) UIImageView *imgView;



@end

@implementation LaunchController


- (void)initLaunchView {

    _imgView = [[UIImageView alloc] init];
    [self.view addSubview:_imgView];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    
    NSInteger i = 0;
    if (CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen].currentMode.size))
    {
        _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%ld_1136", i]];
    }
    else if(CGSizeEqualToSize(CGSizeMake(750, 1334), [UIScreen mainScreen].currentMode.size))
    {
        _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%ld_1334", i]];
    }
    else if(CGSizeEqualToSize(CGSizeMake(1242, 2208), [UIScreen mainScreen].currentMode.size))
    {
        _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%ld_2208", i]];
    }
    else
    {
        _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%ld_960", i]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLaunchView];
 
    
    [self getAppConfig];
}

#pragma mark - Private
- (void)getAppConfig {

    GetConfigApi *congifApi = [[GetConfigApi alloc] init];
    
    [congifApi getSyetemConfigWithField:nil callback:^(id resultData, NSInteger code) {
        if (code == 0) {
         
            // 1.配置主题
            
            Singleton *singleton = [Singleton sharedManager];
            
            singleton.app_style = [NSString stringWithFormat:@"%@", resultData[@"app_style"]];
            singleton.customer_service_telephone = resultData[@"customer_service_telephone"];
            
            singleton.personal_background = resultData[@"personal_background"];

            singleton.ios_verify = resultData[@"ios_verify"];
            
            
            // 2.进入首页
        }
        
        [self goToMainVC];
        
    }];
}

- (void)goToMainVC {
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    MainDrawerController *mainVC = [[MainDrawerController alloc] init];
    appDelegate.window.rootViewController = mainVC;
}





@end
