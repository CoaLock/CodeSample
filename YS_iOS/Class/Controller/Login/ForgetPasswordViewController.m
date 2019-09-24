//
//  ForgetPasswordViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPasswordView.h"

#import "SendVerifyCodeApi.h"
#import "RetrievePasswordApi.h"

#import "Check.h"

@interface ForgetPasswordViewController ()
//忘记密码
@property (nonatomic, strong) ForgetPasswordView *forgetPasswordView;

@property (nonatomic, strong) NSTimer *timeInterval;
@property (nonatomic, assign) NSInteger timeCount;


@end

@implementation ForgetPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isSetPW) {

        self.navigationItem.titleView = [UILabel labelWithTitle:@"设置密码"];
    }
    else {
    
        self.navigationItem.titleView = [UILabel labelWithTitle:@"忘记密码"];
    }
    
    [self configForgetPwdView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


- (void)configForgetPwdView {

    GrassWeakSelf;
    _forgetPasswordView = [[ForgetPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) forgetPwdBlock:^(ForgetPwdButtonStateType stateType) {
        
        if (stateType == ForgetPwdButtonStateTypeSendVerifyCode) {
            [weakSelf sendVerifyCode];
        }
        else {
            [weakSelf commit];
        }
        
    }];
    
    [self.view addSubview:_forgetPasswordView];
}

- (void)sendVerifyCode {

    [self.view endEditing:YES];
    
    NSString *mobile = _forgetPasswordView.phoneNumberTF.text;

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

- (void)commit {

    
    [self.view endEditing:YES];
    
    NSString *mobile = _forgetPasswordView.phoneNumberTF.text;
    NSString *verifyCode = _forgetPasswordView.verifyCodeTF.text;
    NSString *password = _forgetPasswordView.passwordTF.text;
    
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
    
    [self showIndicatorOnWindowWithMessage:@"设置密码中..."];
    RetrievePasswordApi *retrievePasswordApi = [[RetrievePasswordApi alloc] init];
    [retrievePasswordApi retrievePasswordWithMobile:mobile verifyCode:verifyCode newPassword:[HttpSign doMD5:password] callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {
            
            [self showSuccessIndicator:@"设置成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else if (code == 4020609) {
            [self showTextOnly:@"修改失败,您的密码与原密码相同"];
        }
        else {
            
            [self showTextOnly:resultData[@"msg"]];
        }
    }];

}

#pragma mark - down count
- (void)startCountDown {
    
    _timeCount = 59;
    [_forgetPasswordView.sendVerifyCodeButton setEnabled:NO];
    _timeInterval = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    
    if (_timeCount < 0) {
        
        [_timeInterval invalidate];
        _timeInterval = nil;
        _forgetPasswordView.sendVerifyCodeButton.enabled = YES;
        [_forgetPasswordView.sendVerifyCodeButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    [_forgetPasswordView.sendVerifyCodeButton setTitle:[NSString stringWithFormat:@"已发送(%lis)", _timeCount] forState:UIControlStateDisabled];
    _timeCount--;
}


@end
