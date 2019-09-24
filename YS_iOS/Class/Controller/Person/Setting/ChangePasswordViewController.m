//
//  ChangePasswordViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "SendVerifyCodeApi.h"
#import "RetrievePasswordApi.h"

#import "Check.h"

#import "UserInfoApi.h"

@interface ChangePasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;


@property (nonatomic, strong) NSTimer *timeInterval;
@property (nonatomic, assign) NSInteger timeCount;


@property (nonatomic, strong) NSString *mobile;



@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    
    _verifyCodeBtn.backgroundColor = kAppCustomMainColor;
    
    _completeBtn.backgroundColor = kAppCustomMainColor;

    
    _verifyCodeTF.delegate = self;
    _verifyCodeTF.tag = 1000;
    
    [self congifSubviews];
    
    [self getUserInfo];
}

#pragma mark - Private
- (void)getUserInfo {

    UserInfoApi *userInfoApi = [[UserInfoApi alloc] init];
    [userInfoApi getUserInfoWithFields:@"mobile" callback:^(id resultData, NSInteger code) {
        if (code == 0) {
         
            NSString *mobile = PASS_NULL_TO_NIL(resultData[@"mobile"]);
            if (mobile.length == 11) {
                _mobile = mobile;
                
                _mobileTF.text = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                _mobileTF.userInteractionEnabled = NO;
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - Config

- (void)congifSubviews {

    self.navigationItem.titleView = [UILabel labelWithTitle:@"修改密码"];
    
    _verifyCodeBtn.layer.cornerRadius = 4;
    _verifyCodeBtn.clipsToBounds = YES;
    
    _completeBtn.layer.cornerRadius = 4;
    _completeBtn.clipsToBounds = YES;
}



- (IBAction)sendVerify:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *mobile = _mobile ? _mobile: _mobileTF.text;
    
    //验证手机号
    NSString *promptStr = [Check checkMobileNum:mobile];
    
    if (promptStr.length > 0) {
        
        [self showTextOnly:promptStr];
        return;
    }
    
    SendVerifyCodeApi *sendVerifyCodeApi = [[SendVerifyCodeApi alloc] init];
    [self  showIndicatorOnWindowWithMessage:@"发送中..."];
    
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


- (IBAction)submit:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *mobile = _mobile ? _mobile: _mobileTF.text;
    NSString *verifyCode = _verifyCodeTF.text;
    NSString *password = _passwordTF.text;
    
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
            
            [self showSuccessIndicator:@"修改成功"];

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
    [_verifyCodeBtn setEnabled:NO];
    _timeInterval = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    
    if (_timeCount < 0) {
        
        [_timeInterval invalidate];
        _timeInterval = nil;
        _verifyCodeBtn.enabled = YES;
        [_verifyCodeBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    [_verifyCodeBtn setTitle:[NSString stringWithFormat:@"已发送(%lis)", _timeCount] forState:UIControlStateDisabled];
    _timeCount--;
}



#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {
        return YES;
    }
    if (textField.tag == 1000 && textField.text.length >= 6) {
        
        return NO;
    }
    
    return YES;
}




@end
