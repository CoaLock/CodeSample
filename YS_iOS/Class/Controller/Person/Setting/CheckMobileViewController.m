//
//  CheckMobileViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/14.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "CheckMobileViewController.h"
#import "ChangeMobileViewController.h"

#import "SendVerifyCodeApi.h"
#import "CheckVerifyCodeValidApi.h"
#import "UserInfoApi.h"

#import "Check.h"


@interface CheckMobileViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *mobileTF;

@property (weak, nonatomic) IBOutlet UITextField *verifyTF;

@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@property (nonatomic, strong) NSTimer *timeInterval;
@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, strong) NSString *mobile;


@end

@implementation CheckMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"验证旧手机"];
    
    
    [self getUserInfo];
    
    
    _verifyBtn.backgroundColor = kAppCustomMainColor;
    _nextBtn.backgroundColor = kAppCustomMainColor;
    
    
    _verifyTF.delegate = self;
    _verifyTF.tag = 1000;
}

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


- (IBAction)sendVerifyAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *mobile = _mobile;
    
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



- (IBAction)nextAction:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *mobile = _mobile;
    NSString *verifyCode = _verifyTF.text;
    
    //验证手机号
    NSString *promptStr = [Check checkMobileNum:mobile];
    
    if (promptStr.length > 0) {
        
        [self showTextOnly:promptStr];
        return;
    }
    if (verifyCode.length != 6) {
        
        [self showTextOnly:@"验证码格式不正确"];
        return;
    }

    _nextBtn.userInteractionEnabled = NO;
    CheckVerifyCodeValidApi *checkApi = [[CheckVerifyCodeValidApi alloc] init];
    [checkApi getCheckVerifyCodeValid:verifyCode mobile:_mobile callback:^(id resultData, NSInteger code) {
        _nextBtn.userInteractionEnabled = YES;
        if (code == 0 && [PASS_NULL_TO_NIL(resultData) integerValue] == 1) {
            
            
            ChangeMobileViewController *changeMobileVC = [[ChangeMobileViewController alloc] init];
            changeMobileVC.oldVerify = verifyCode;
            [self.navigationController pushViewController:changeMobileVC animated:YES
             ];
            
        }
        else {
            [self showErrorMsg:@"无效验证码"];
        }
    }];
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


#pragma mark - down count
- (void)startCountDown {
    
    _timeCount = 59;
    [_verifyBtn setEnabled:NO];
    _timeInterval = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    
    if (_timeCount < 0) {
        
        [_timeInterval invalidate];
        _timeInterval = nil;
        _verifyBtn.enabled = YES;
        [_verifyBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    [_verifyBtn setTitle:[NSString stringWithFormat:@"已发送(%lis)", _timeCount] forState:UIControlStateDisabled];
    _timeCount--;
}





@end
