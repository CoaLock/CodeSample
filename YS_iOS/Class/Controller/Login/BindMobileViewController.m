//
//  BindMobileViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/12.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BindMobileViewController.h"
#import "BindMobileApi.h"

#import "SendVerifyCodeApi.h"
#import "Check.h"

#import "BindMobileApi.h"

#import "JPushRegIdApi.h"

@interface BindMobileViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *mobileTF;

@property (weak, nonatomic) IBOutlet UITextField *verifyTF;


@property (weak, nonatomic) IBOutlet UIButton *sendVerifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property (nonatomic, strong) NSTimer *timeInterval;
@property (nonatomic, assign) NSInteger timeCount;



@end

@implementation BindMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;

    if (_isBindMobile) {
        self.navigationItem.titleView = [UILabel labelWithTitle:@"绑定手机号"];
    }
    else {
        self.navigationItem.titleView = [UILabel labelWithTitle:@"修改手机号码"];
    }
    
    
    _sendVerifyBtn.backgroundColor = kAppCustomMainColor;
    _submitBtn.backgroundColor = kAppCustomMainColor;
    
    
    
    _mobileTF.tag = 1000;
    _verifyTF.tag = 1001;
    
    _mobileTF.delegate = self;
    _verifyTF.delegate  = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (IBAction)sendVerifyAction:(UIButton *)sender {
    
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
    
    if (_isBindMobile) {
        
        [self bindMobile];
    }
    else {
    
        [self changeBindMobile];
    }
    
}

- (void)bindMobile {

    NSString *mobile = _mobileTF.text;
    NSString *verifyCode = _verifyTF.text;
    
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

    
    BindMobileApi *bindMobileApi = [[BindMobileApi alloc] init];
    [bindMobileApi userBindMobileWithThirdId:nil mobile:mobile verifyCode:verifyCode callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            [self showSuccessIndicator:@"绑定成功"];
            
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
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            });
        }
        else if (code == 4020402) {
            [self showTextOnly:@"手机号格式不正确"];
        }
        else if (code == 4020404) {
            [self showTextOnly:@"验证码格式不正确"];
        }
        else if (code == 4020405) {
            [self showTextOnly:@"无效验证码"];
        }
        else if (code == 4020407) {
            [self showTextOnly:@"第三方账号异常"];
        }
        else if (code == 4020408) {
            [self showTextOnly:@"当前手机已绑定同类型第三方账号"];
        }
        else if (code == 4020409) {
            [self showTextOnly:@"绑定失败"];
        }
        else if (code == 4020410) {
            [self showTextOnly:@"登录失败"];
        }
        else {
            [self showTextOnly:resultData[@"msg"]];
        }
        
    }];
}

- (void)changeBindMobile {


    
}


#pragma mark - down count
- (void)startCountDown {
    
    _timeCount = 59;
    [_sendVerifyBtn setEnabled:NO];
    _timeInterval = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    
    if (_timeCount < 0) {
        
        [_timeInterval invalidate];
        _timeInterval = nil;
        _sendVerifyBtn.enabled = YES;
        [_sendVerifyBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        return;
    }
    [_sendVerifyBtn setTitle:[NSString stringWithFormat:@"已发送(%lis)", _timeCount] forState:UIControlStateDisabled];
    
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
