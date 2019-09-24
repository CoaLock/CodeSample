//
//  LoginViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

#import "LoginView.h"

#import "HomeViewController.h"

#import "AppDelegate.h"
#import "NavigationController.h"

#import "UserDefaultsUtil.h"

#import "SignInApi.h"

#import <UMSocialCore/UMSocialCore.h>
#import "UMLoginUtil.h"

#import "ThirdPartLoginApi.h"

#import "BindMobileViewController.h"

#import "JPushRegIdApi.h"


@interface LoginViewController ()

//登录
@property (nonatomic, strong) LoginView *loginView;

@property (nonatomic, strong) UMLoginUtil *uMLoginUtil;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"登录"];
    
    
    [self configLoginView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)configLoginView {

    GrassWeakSelf;
    _loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) loginBlock:^(ButtonStateType stateType) {
        if (stateType == ButtonStateTypeDismiss) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if (stateType == ButtonStateTypeForgetPW) {
        
            ForgetPasswordViewController *forgetPwdVC = [ForgetPasswordViewController new];
            [weakSelf.navigationController pushViewController:forgetPwdVC animated:YES];
        }
        else if (stateType == ButtonStateTypeLogin) {
            
            [weakSelf userLogin];
            
        }else if (stateType == ButtonStateTypeRegister) {
            
            RegisterViewController *registerVC = [[RegisterViewController alloc] init];
            [weakSelf.navigationController pushViewController:registerVC animated:YES];
       
        }else if (stateType == ButtonStateTypeQQ) {

            [weakSelf userThirdPartLoginUserInfoWithType:UMSocialPlatformType_QQ];
        }
        else if (stateType == ButtonStateTypeWeixin) {
            
            [weakSelf userThirdPartLoginUserInfoWithType:UMSocialPlatformType_WechatSession];
        }
        else if (stateType == ButtonStateTypeWeibo) {
            
            [weakSelf userThirdPartLoginUserInfoWithType:UMSocialPlatformType_Sina];
        }
    }];
    
    [self.view addSubview:_loginView];
}

#pragma mark - Private
- (void)userLogin {

    [self.view endEditing:YES];
    
    NSString *mobile = _loginView.userNameTF.text;
    NSString *password = [HttpSign doMD5:_loginView.passwordTF.text];
    NSString *errorMsg = @"";
    if (mobile.length != 11) {
        errorMsg = @"请输入正确的手机号";
    }
    else if (password.length == 0) {
        errorMsg = @"请填写密码";
    }
    if (errorMsg.length > 0) {

        [self showTextOnly:errorMsg];
        return;
    }

    [self showIndicatorOnWindowWithMessage:@"登陆中..."];
    SignInApi *signInApi = [[SignInApi alloc] init];
    self.view.userInteractionEnabled = NO;
    [signInApi userSigninMobile:mobile password:password callback:^(id resultData, NSInteger code) {
        
        self.view.userInteractionEnabled = YES;
        [self hideIndicatorOnWindow];
        if (code == 0) {
            
            if (_loginSuccess) {
                _loginSuccess();
            }
            
            [self showSuccessIndicator:@"登录成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
            
            // 1.设置用户登录 成功
            [UserDefaultsUtil setUserLogin];
            
            
            // 2.保存
            [Singleton sharedManager].userId = [NSString stringWithFormat:@"%@", resultData];
            [Singleton sharedManager].mobile = mobile;
            [Singleton sharedManager].userPassward = password;
            
            [Singleton sharedManager].thirdLoginType = 0;
            
            
            [UserDefaultsUtil setUserDefaultName:mobile];
            [UserDefaultsUtil setUserDefaultPassword:password];
            

            // 3.上传极光推送 id
            JPushRegIdApi *pushRegIdApi = [[JPushRegIdApi alloc] init];
            NSString *pushId = [Singleton sharedManager].registrationID;
              [pushRegIdApi setJPushRegIdJpushRegId:pushId callback:^(id resultData, NSInteger code) {
                  
              }];
            
        }
        // 未设置密码
        else if (code == 4020107) {
            
            ForgetPasswordViewController *forgetPwdVC = [ForgetPasswordViewController new];
            forgetPwdVC.isSetPW = YES;
            [self.navigationController pushViewController:forgetPwdVC animated:YES];
            [self showErrorMsg:@"账号未设置密码,请立即设置哦"];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)userThirdPartLoginUserInfoWithType:(UMSocialPlatformType)loginType {
    
    _uMLoginUtil = [[UMLoginUtil alloc] init];
    
    GrassWeakSelf;
    [_uMLoginUtil getUserInfoWithPlatform:loginType completion:^(NSDictionary *userInfo, NSString *errorStr, HandleStatus handleStatus) {

        if (handleStatus == HandleStatusCanle) {
            
            // 用户取消
        }
        else if (handleStatus == HandleStatusFailure) {
            
            [weakSelf showTextOnly:errorStr];
        }
        // 授权成功
        else {
        
            NSInteger type = 0;
            if (loginType == UMSocialPlatformType_WechatSession) {
                type = 1;
            }
            else if (loginType == UMSocialPlatformType_QQ) {
                type = 2;
            }
            else if (loginType == UMSocialPlatformType_Sina) {
            
                type = 3;
            }
                
            [weakSelf userThirdLoginWithType:type userInfo:userInfo];
        }
        
    }];
}

- (void)userThirdLoginWithType:(NSInteger)type userInfo:(NSDictionary*)userInfo {
    if (type == 0) {
        [self showTextOnly:@"访问错误"];
    }
    
    NSString *jsonStr = [NSString serializeMessage:userInfo];

    ThirdPartLoginApi *thirdPartLoginApi = [[ThirdPartLoginApi alloc] init];
    [thirdPartLoginApi getThirdPartLoginType:type detail:jsonStr callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            [self showSuccessIndicator:@"登录成功"];

            
            // 1.设置登录成功
            [UserDefaultsUtil setUserLogin];
            
            
            // 2.保存
            [Singleton sharedManager].userId = [NSString stringWithFormat:@"%@", resultData];
            [Singleton sharedManager].thirdLoginType = 1;

            
            // 3.隐藏界面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            
            
            // 4.上传极光推送 id
            JPushRegIdApi *pushRegIdApi = [[JPushRegIdApi alloc] init];
            NSString *pushId = [Singleton sharedManager].registrationID;
            [pushRegIdApi setJPushRegIdJpushRegId:pushId callback:^(id resultData, NSInteger code) {
                
                
            }];
            
            
        }
        else {
            // 未绑定手机号
            if (code == 4020308) {
                
                BindMobileViewController *bindMobileVC = [[BindMobileViewController alloc] init];
                bindMobileVC.isBindMobile = YES;
                [self.navigationController pushViewController:bindMobileVC animated:YES];
                
                return ;
            }
            
            [self showTextOnly:resultData[@"msg"]];
        }
    }];
    
}


#pragma mark - Event
- (void)back {

    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
