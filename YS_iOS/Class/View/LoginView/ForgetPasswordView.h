//
//  ForgetPasswordView.h
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ForgetPwdButtonStateType) {
    
    ForgetPwdButtonStateTypeSendVerifyCode,
    ForgetPwdButtonStateTypeCommit,
};

typedef void (^ForgetPwdBlock) (ForgetPwdButtonStateType stateType);

@interface ForgetPasswordView : UIView


@property (nonatomic, strong) UITextField *phoneNumberTF;
@property (nonatomic, strong) UIButton    *sendVerifyCodeButton;
@property (nonatomic, strong) UITextField *verifyCodeTF;
@property (nonatomic, strong) UITextField *passwordTF;

@property (nonatomic, copy) ForgetPwdBlock forgetPwdBlock;

- (instancetype)initWithFrame:(CGRect)frame forgetPwdBlock:(ForgetPwdBlock)forgetPwdBlock;

@end
