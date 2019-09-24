//
//  RegisterViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "RegisterViewController.h"
#import "NavigationController.h"
#import "BindMobileViewController.h"

#import "BaseWKWebViewController.h"


#import "RegisterView.h"

#import "SendVerifyCodeApi.h"
#import "SignUpApi.h"
#import "SignInApi.h"

#import "Check.h"

#import <UMSocialCore/UMSocialCore.h>
#import "UMLoginUtil.h"

#import "ThirdPartLoginApi.h"


#import "RegisterAgreementView.h"

#import "JPushRegIdApi.h"


@interface RegisterViewController ()

//注册
@property (nonatomic, strong) RegisterView *registerView;

@property (nonatomic, strong) NSTimer *timeInterval;
@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, strong) UMLoginUtil *uMLoginUtil;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"注册"];
    
    [self configRegisterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)configRegisterView {

    GrassWeakSelf
    _registerView = [[RegisterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) registerBlock:^(RegisterButtonStateType stateType) {
        
        if (stateType == RegisterButtonStateTypeDismiss) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else if (stateType == RegisterButtonStateTypeSendVerify) {
        
            [weakSelf sendVerifyCode];
            
        }else if (stateType == RegisterButtonStateTypeProtocol) {
        
            [weakSelf getIntoUserProtocol];
        }else if (stateType == RegisterButtonStateTypeRegister) {
            
            [weakSelf userRegister];
        }else if (stateType == RegisterButtonStateTypeHadAccount) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else if (stateType == RegisterButtonStateTypeQQ) {
            
            [weakSelf userThirdPartLoginUserInfoWithType:UMSocialPlatformType_QQ];
        }else if (stateType == RegisterButtonStateTypeWeixin) {
            
            [weakSelf userThirdPartLoginUserInfoWithType:UMSocialPlatformType_WechatSession];
            
        }else if (stateType == RegisterButtonStateTypeWeibo) {
            
            [weakSelf userThirdPartLoginUserInfoWithType:UMSocialPlatformType_Sina];
        }

    }];
    
    [self.view addSubview:_registerView];
}

#pragma mark - Private
- (void)sendVerifyCode {

    [self.view endEditing:YES];
    
    NSString *mobile = _registerView.phoneNumberTF.text;
    //验证手机号
    NSString *promptStr = [Check checkMobileNum:mobile];
    
    if (promptStr.length > 0) {
        
        [self showTextOnly:promptStr];
        return;
    }
    
    SendVerifyCodeApi *sendVerifyCodeApi = [[SendVerifyCodeApi alloc] init];
    [self showIndicatorOnWindowWithMessage:@"发送中..."];
    [sendVerifyCodeApi userSendVerifyCodeWithMobile:mobile callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {
         
            [self showSuccessIndicator:@"发送成功"];
            
            [self startCountDown];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
        
    }];
}



- (void)getIntoUserProtocol {
    
    
    BaseWKWebViewController *webviewVC = [[BaseWKWebViewController alloc] init];
    webviewVC.titleStr = @"注册协议";
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, kWebUrlRegistAgreement];
    
    [webviewVC wkWebViewRequestWithURL:url];
    
    [self.navigationController pushViewController:webviewVC animated:YES];
    
//    RegisterAgreementView *agreementView = [[RegisterAgreementView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [[UIApplication sharedApplication].windows.lastObject addSubview:agreementView];
    
    
    
}

- (void)userRegister {

    [self.view endEditing:YES];
    

    NSString *mobile = _registerView.phoneNumberTF.text;
    NSString *verifyCode = _registerView.verifyCodeTF.text;
    NSString *password = _registerView.passwordTF.text;
    
    NSString *errorMsg = @"";
    if (mobile.length != 11) {
        errorMsg = @"请输入正确的手机号";
    }
    else if (verifyCode.length != 6) {
        errorMsg = @"请输入正确的验证码";
    }
    else if (password.length == 0) {
        errorMsg = @"请填写密码";
    }
    if (errorMsg.length > 0) {
        
        [self showTextOnly:errorMsg];
        return;
    }
    
    
    NSString *pwSigned = [HttpSign doMD5:password];
    SignUpApi *signUpApi = [[SignUpApi alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [signUpApi userSignupMobile:mobile password:pwSigned verifyCode:verifyCode callback:^(id resultData, NSInteger code) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (code == 0) {
            
            [self showSuccessIndicator:@"注册成功"];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            
            
            // 1.设置用户登录 成功
            [UserDefaultsUtil setUserLogin];
            
            
            // 2.保存
            [Singleton sharedManager].userId = [NSString stringWithFormat:@"%@", resultData];
            [Singleton sharedManager].mobile = mobile;
            [Singleton sharedManager].userPassward = pwSigned;
            
            [Singleton sharedManager].thirdLoginType = 0;
            
            
            [UserDefaultsUtil setUserDefaultName:mobile];
            [UserDefaultsUtil setUserDefaultPassword:pwSigned];
            
            
            // 3.上传极光推送 id
            JPushRegIdApi *pushRegIdApi = [[JPushRegIdApi alloc] init];
            NSString *pushId = [Singleton sharedManager].registrationID;
            [pushRegIdApi setJPushRegIdJpushRegId:pushId callback:^(id resultData, NSInteger code) {
                
            }];

            
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

#pragma mark - ThirdPartLogin

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
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            
            
            // 1.设置登录成功
            [UserDefaultsUtil setUserLogin];
            
            
            // 2.保存
            [Singleton sharedManager].userId = [NSString stringWithFormat:@"%@", resultData];
            [Singleton sharedManager].thirdLoginType = 1;
            
            // 3.上传极光推送 id
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


#pragma mark - down count
- (void)startCountDown {
    
    _timeCount = 59;
    [_registerView.sendVerifyCodeButton setEnabled:NO];
    _timeInterval = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    
    if (_timeCount < 0) {
        
        [_timeInterval invalidate];
        _timeInterval = nil;
        _registerView.sendVerifyCodeButton.enabled = YES;
        [_registerView.sendVerifyCodeButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    
    [_registerView.sendVerifyCodeButton setTitle:[NSString stringWithFormat:@"已发送(%li)", _timeCount] forState:UIControlStateDisabled];
    _timeCount--;
}






@end
