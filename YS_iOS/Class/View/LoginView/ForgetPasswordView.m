//
//  ForgetPasswordView.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "ForgetPasswordView.h"

@interface ForgetPasswordView ()<UITextFieldDelegate>

@end

@implementation ForgetPasswordView

- (instancetype)initWithFrame:(CGRect)frame forgetPwdBlock:(ForgetPwdBlock)forgetPwdBlock {

    if (self = [super initWithFrame:frame]) {
        
        _forgetPwdBlock = [forgetPwdBlock copy];
        
        
        [self configForgetPwdView];
        
        self.backgroundColor = kPaleGreyColor;
    }
    
    return self;
}

- (void)configForgetPwdView {

    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = kWhiteColor;
    [self addSubview:whiteBg];
    
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(134);
    }];
    
    
    for (NSInteger i = 0; i < 2; i++) {
        
        UIView *grayLineH = [[UIView alloc] init];
        grayLineH.backgroundColor = kSeperateLineColor;
        [whiteBg addSubview:grayLineH];
        
        [grayLineH mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(45 *(i+1));
            make.height.mas_equalTo(1);
        }];
    }
    
    
    //手机号
    UIImageView *userNameIC = [[UIImageView alloc] init];
    userNameIC.lk_attribute
    .image([UIImage imageNamed:@"ic_iphone"])
    .superView(whiteBg);
    
    [userNameIC mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(11);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(25);
    }];
    
    
    _phoneNumberTF = [[UITextField alloc] init];
    _phoneNumberTF.placeholder = @"输入手机号";
    _phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberTF.font = kTitleFont;
    _phoneNumberTF.layer.cornerRadius = kBorderCorner;
    _phoneNumberTF.delegate = self;
    _phoneNumberTF.tag = 1800;
    [whiteBg addSubview:_phoneNumberTF];
    
    [_phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(43);
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-110);
        make.height.mas_equalTo(22);
    }];
    
    
    //发送验证码
    _sendVerifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendVerifyCodeButton.lk_attribute
    .normalTitle(@"发送验证码")
    .normalTitleColor([UIColor whiteColor])
    .font(14)
    .backgroundColor(kAppCustomMainColor)
    .corner(kBorderCorner)
    .tag(2350 + 0)
    .event(self, @selector(clickButton:))
    .superView(whiteBg);
    
    [_sendVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(98);
        make.height.mas_equalTo(34);
        make.top.mas_equalTo(6);
        make.right.mas_equalTo(-11);
    }];

    
    //验证码
    UIImageView *verifyIC = [[UIImageView alloc] init];
    verifyIC.lk_attribute
    .image([UIImage imageNamed:@"ic_verify"])
    .superView(whiteBg);
    
    [verifyIC mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(13 + 45);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(19);
    }];
    
    _verifyCodeTF = [[UITextField alloc] init];
    _verifyCodeTF.placeholder = @"请输入验证码";
    _verifyCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyCodeTF.font = kTitleFont;
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeTF.layer.cornerRadius = kBorderCorner;
    _verifyCodeTF.delegate = self;
    _verifyCodeTF.tag = 1810;
    [whiteBg addSubview:_verifyCodeTF];
    
    [_verifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(43);
        make.top.mas_equalTo(12 + 45);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    
    //密码
    UIImageView *passwordIC = [[UIImageView alloc] init];
    passwordIC.lk_attribute
    .image([UIImage imageNamed:@"ic_password"])
    .superView(whiteBg);
    
    [passwordIC mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(13 + 45*2);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(19);
    }];
    
    _passwordTF = [[UITextField alloc] init];
    _passwordTF.placeholder = @"输入密码";
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.font = kTitleFont;
    _passwordTF.layer.cornerRadius = kBorderCorner;
    _passwordTF.delegate = self;
    [whiteBg addSubview:_passwordTF];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(43);
        make.top.mas_equalTo(12 + 45*2);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];

    
    //提交
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.lk_attribute
    .backgroundColor(kAppCustomMainColor)
    .normalTitle(@"完成")
    .corner(kBorderCorner)
    .event(self, @selector(clickButton:))
    .normalTitleColor(kWhiteColor)
    .tag(2350 + 1)
    .font(16)
    .superView(self);
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(whiteBg.mas_bottom).offset(30);
        make.height.mas_equalTo(44);
    }];

}

- (void)clickButton:(UIButton *)button {
    
    NSUInteger tag = button.tag - 2350;
    
    if (tag == 0) {
        
        _forgetPwdBlock(ForgetPwdButtonStateTypeSendVerifyCode);
        
    }else if (tag == 1) {
        
        _forgetPwdBlock(ForgetPwdButtonStateTypeCommit);
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_passwordTF resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //删除string或者按下return
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {
        return YES;
    }
    if (textField.tag == 1800) {
        
        if (textField.text.length >= 11) {
            
            return NO;
        }
        
    }else if (textField.tag == 1810) {
        
        if (textField.text.length >= 6) {
            
            return NO;
        }
    }
    
    return YES;
}

@end
