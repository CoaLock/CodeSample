//
//  RegisterView.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "RegisterView.h"
#import "AppMacro.h"

@interface RegisterView ()<UITextFieldDelegate>

@end

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame registerBlock:(RegisterBlock)registerBlock {

    if (self = [super initWithFrame:frame]) {
        
        _registerBlock = [registerBlock copy];
        
        self.backgroundColor = kWhiteColor;
        
        [self configRegisterView];
        
    }
    
    return self;

}

- (void)configRegisterView {

    // close_ic
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_close_black"])
    .event(self, @selector(clickButton:))
    .tag(1000)
    .superView(self);
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(22);
        make.width.height.mas_equalTo(22);
    }];
    
    
    // 小草icon
    UIImageView *imgView = [[UIImageView alloc ] init];
    imgView.lk_attribute
    .image([UIImage imageNamed:@"square_bg"])
    .corner(kBorderCorner)
    .superView(self);
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(kWidth(80));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kWidth(94));
    }];

    
    // 输入框
    UIView *inputView = [[UIView alloc] init];
    inputView.lk_attribute
    .corner(kBorderCorner)
    .border(kSeperateLineColor, 1)
    .superView(self);
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(imgView.mas_bottom).offset(30);
        make.height.mas_equalTo(136);
    }];
    
    for (NSInteger i =0; i <2; i++) {
     
        UIView *lineH = [[UIView alloc] init];
        lineH.lk_attribute
        .backgroundColor(kSeperateLineColor)
        .superView(inputView);
        
        [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(45*(i+1));
            make.height.mas_equalTo(1);
        }];
    }
    
    
    //用户名
    UIImageView *userNameIC = [[UIImageView alloc] init];
    userNameIC.lk_attribute
    .image([UIImage imageNamed:@"ic_iphone"])
    .superView(inputView);
    
    [userNameIC mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
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
    _phoneNumberTF.tag = 1750;
    [inputView addSubview:_phoneNumberTF];
    
    [_phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(47);
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    _sendVerifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendVerifyCodeButton.lk_attribute
    .normalTitle(@"发送验证码")
    .normalTitleColor([UIColor whiteColor])
    .font(14)
    .backgroundColor(kAppCustomMainColor)
    .corner(kBorderCorner)
    .tag(1000 +1)
    .event(self, @selector(clickButton:))
    .superView(inputView);
    
    
    [_sendVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(98);
        make.height.mas_equalTo(34);
        make.top.mas_equalTo(6);
        make.right.mas_equalTo(-11);
    }];

    
    // 验证码
    UIImageView *verifyIC = [[UIImageView alloc] init];
    verifyIC.lk_attribute
    .image([UIImage imageNamed:@"ic_verify"])
    .superView(inputView);
    
    [verifyIC mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
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
    _verifyCodeTF.tag = 1760;
    [inputView addSubview:_verifyCodeTF];
    
    [_verifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(47);
        make.top.mas_equalTo(12 + 45);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    
    //密码
    UIImageView *passwordIC = [[UIImageView alloc] init];
    passwordIC.lk_attribute
    .image([UIImage imageNamed:@"ic_password"])
    .superView(inputView);
    
    [passwordIC mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
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
    [inputView addSubview:_passwordTF];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(47);
        make.top.mas_equalTo(12 + 45*2);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];

    
    //用户协议
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.lk_attribute
    .text(@"注册即代表同意")
    .textColor(kTextThirdLevelColor)
    .font(12)
    .superView(self);
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(13);
        make.height.mas_equalTo(17);
        make.top.mas_equalTo(inputView.mas_bottom).offset(14);
    }];
    
    UIButton *userProtocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userProtocolButton.lk_attribute
    .tag(1000 +2)
    .normalTitle(@"《用户使用协议》")
    .event(self, @selector(clickButton:))
    .normalTitleColor([UIColor colorWithHexString:@"#26B8F2"])
    .font(12)
    .superView(self);
    [userProtocolButton setEnlargeEdge:20];
    
    [userProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(promptLabel.mas_right).offset(0);
        make.height.mas_equalTo(17);
        make.top.mas_equalTo(inputView.mas_bottom).offset(14);
    }];

    
    //注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.lk_attribute
    .backgroundColor(kAppCustomMainColor)
    .normalTitle(@"注册")
    .corner(kBorderCorner)
    .event(self, @selector(clickButton:))
    .normalTitleColor(kWhiteColor)
    .tag(1000 +3)
    .font(16)
    .superView(self);
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(inputView.mas_bottom).offset(44);
        make.height.mas_equalTo(44);
    }];
    

    UIButton *hadAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    hadAccount.lk_attribute
    .normalTitle(@"已有账号登录")
    .font(16)
    .event(self, @selector(clickButton:))
    .tag(1000 +4)
    .textAlignment(NSTextAlignmentCenter)
    .normalTitleColor([UIColor colorWithHexString:@"#26B8F2"])
    .superView(self);
    
    [hadAccount mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(registerButton.mas_bottom).offset(16);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(22);
    }];
    
    
    // 第三方注册
    UIView *lineHBottom = [[UIView alloc] init];
    lineHBottom.lk_attribute
    .backgroundColor(kSeperateLineColor)
    .superView(self);
    
    [lineHBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(68);
        make.right.mas_equalTo(-68);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(kHeight(-54));
    }];
    
    UILabel *thirdLabel = [[UILabel alloc] init];
    thirdLabel.lk_attribute
    .text(@"第三方登录")
    .backgroundColor(kWhiteColor)
    .font(12)
    .textColor(kSeperateLineColor)
    .textAlignment(NSTextAlignmentCenter)
    .superView(self);
    
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(kHeight(-46));
    }];
    
    NSArray *titleNames = @[@"ic_qq", @"ic_weixin", @"ic_weibo"];
    
    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        thirdBtn.lk_attribute
        .normalBackgroundImage([UIImage imageNamed:titleNames[i]])
        .event(self, @selector(clickButton:))
        .tag(1000 +5 + i)
        .superView(self);
        
        [thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(kWidth(50));
            make.bottom.mas_equalTo(kHeight(-80));
            
            CGFloat spaceH = (kScreenWidth-68*2 - kWidth(50)*3)/2;
            make.left.mas_equalTo(68+(kWidth(50)+spaceH)*i);
        }];
    }

    
}

#pragma mark - Events
- (void)closeAction {
    
    
    
}


- (void)clickButton:(UIButton *)button {

    NSUInteger tag = button.tag - 1000;
    
    if (_registerBlock) {
        _registerBlock((RegisterButtonStateType)tag);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_passwordTF resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {//按下return
        return YES;
    }
    if (textField.tag == 1750) {
        
        if (textField.text.length >= 11) {
            
            return NO;
        }
        
    }else if (textField.tag == 1760) {
    
        if (textField.text.length >= 6) {
            
            return NO;
        }
    }
    
    return YES;
}

@end
