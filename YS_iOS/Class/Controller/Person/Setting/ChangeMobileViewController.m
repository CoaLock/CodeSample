//
//  ChangeMobileViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ChangeMobileViewController.h"

#import "SendVerifyCodeApi.h"
#import "ChangeMobileApi.h"
#import "Check.h"


@interface ChangeMobileViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;


@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;


@property (nonatomic, strong) NSTimer *timeInterval;
@property (nonatomic, assign) NSInteger timeCount;



@end

@implementation ChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"修改手机号"];

    self.view.backgroundColor = kBackgroundColor;
    
    _mobileTF.tag = 1000;
    _verifyCodeTF.tag = 1001;

    _mobileTF.delegate = self;
    _verifyCodeTF.delegate  = self;
    
    
    _verifyCodeBtn.backgroundColor = kAppCustomMainColor;
    _completeBtn.backgroundColor = kAppCustomMainColor;
}



- (IBAction)sendVerify:(UIButton *)sender {

    [self.view endEditing:YES];
    
    NSString *mobile = _mobileTF.text;
    
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


- (IBAction)submitAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *mobile = _mobileTF.text;
    NSString *verifyCode = _verifyCodeTF.text;

    
    NSString *errorMsg = @"";
    if (mobile.length != 11) {
        errorMsg = @"请输入正确的手机号";
    }
    else if (verifyCode.length != 6) {
        errorMsg = @"请输入正确的验证码";
    }
    if (errorMsg.length > 0) {
        
        [self showTextOnly:errorMsg];
        return;
    }
    
    [self showIndicatorOnWindowWithMessage:@"换绑中..."];
    ChangeMobileApi *changeMobileApi = [[ChangeMobileApi alloc] init];
    [changeMobileApi userBindMobileWithOldVerifyCode:_oldVerify newMobile:mobile newVerifyCode:verifyCode callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {
            
            [self showSuccessIndicator:@"换绑成功"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSArray *childrenVC = self.navigationController.viewControllers;
                UIViewController *vc = childrenVC[childrenVC.count-3];
                [self.navigationController popToViewController:vc animated:YES];
            });
        }
        else if (code == 4020509) {
            [self showTextOnly:@"该手机号已被注册"];
        }
        else if (code == 4020510) {
            [self showTextOnly:@"换绑失败"];
        }
        else if (code == 4020504) {
            [self showTextOnly:@"手机号格式不正确"];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
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
    if (textField.tag == 1000 && textField.text.length >= 11) {
        
        return NO;
    }
    if (textField.tag == 1001 && textField.text.length >= 6) {
        
        return NO;
    }
    
    return YES;
}






@end
