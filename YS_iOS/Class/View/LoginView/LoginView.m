//
//  LoginView.m
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "LoginView.h"
#import "UserDefaultsUtil.h"


@interface LoginView ()<UITextFieldDelegate>

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame loginBlock:(LoginBlock)loginBlock {

    if (self = [super initWithFrame:frame]) {
        
        _loginBlock = [loginBlock copy];
        
        self.backgroundColor = kWhiteColor;
        
    
        [self configLoginView];
        
    }

    return self;
}

- (void)configLoginView {
    
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
        make.height.mas_equalTo(91);
    }];
    
    
    UIView *lineH = [[UIView alloc] init];
    lineH.lk_attribute
    .backgroundColor(kSeperateLineColor)
    .superView(inputView);
    
    [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
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
    
    _userNameTF = [[UITextField alloc] init];
    _userNameTF.placeholder = @"输入手机号";
    _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    _userNameTF.font = kTitleFont;
    _userNameTF.layer.cornerRadius = kBorderCorner;
    _userNameTF.delegate = self;
    _userNameTF.tag = 1700;
    [inputView addSubview:_userNameTF];
    
    [_userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(47);
        make.top.mas_equalTo(12);
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
        make.top.mas_equalTo(14 + 45);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(19);
    }];
    
    _passwordTF = [[UITextField alloc] init];
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.font = kTitleFont;
    _passwordTF.layer.cornerRadius = kBorderCorner;
    _passwordTF.delegate = self;
    [inputView addSubview:_passwordTF];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(47);
        make.top.mas_equalTo(12 + 45);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];

    
    //忘记密码
    UIButton *forgetPasswordButton = [UIButton buttonWithTitle:@"忘记密码?" titleColor:kTextSecondLevelColor backgroundColor:nil titleFont:14];
    forgetPasswordButton.tag = 1000 + 1;
    [forgetPasswordButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetPasswordButton];

    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(inputView.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    //登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.lk_attribute
    .backgroundColor(kAppCustomMainColor)
    .normalTitle(@"登录")
    .corner(kBorderCorner)
    .event(self, @selector(clickButton:))
    .tag(1000 +2)
    .font(16)
    .superView(self);
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(inputView.mas_bottom).offset(44);
        make.height.mas_equalTo(44);
    }];

    //注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.lk_attribute
    .backgroundColor([UIColor clearColor])
    .normalTitle(@"注册")
    .corner(kBorderCorner)
    .event(self, @selector(clickButton:))
    .border(kSeperateLineColor, 1)
    .normalTitleColor(kTextFirstLevelColor)
    .tag(1000 +3)
    .font(16)
    .superView(self);
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(loginButton.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];

    
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
        .tag(1000 + 4 + i)
        .event(self, @selector(clickButton:))
        .superView(self);
        
        [thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(kWidth(50));
            make.bottom.mas_equalTo(kHeight(-80));
            
            CGFloat spaceH = (kScreenWidth-68*2 - kWidth(50)*3)/2;
            make.left.mas_equalTo(68+(kWidth(50)+spaceH)*i);
        }];
    }
    
    // 获取默认手机号和密码
    NSString *mobile = [UserDefaultsUtil getUserDefaultName];
    if (mobile.length == 0) {
        return;
    }
    
    _userNameTF.text = mobile;
    
}

#pragma mark - Events
- (void)clickButton:(UIButton *)button {

    [self endEditing:YES];
    
    NSUInteger tag = button.tag - 1000;
    
    _loginBlock((ButtonStateType)tag);
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
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {
        return YES;
    }
    if (textField.tag == 1700 && textField.text.length >= 11) {
        
        return NO;
    }
    
    return YES;
}

@end
