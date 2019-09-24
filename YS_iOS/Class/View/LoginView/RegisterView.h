//
//  RegisterView.h
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, RegisterButtonStateType) {

    RegisterButtonStateTypeDismiss,
    RegisterButtonStateTypeSendVerify,
    RegisterButtonStateTypeProtocol,
    RegisterButtonStateTypeRegister,
    RegisterButtonStateTypeHadAccount,
    RegisterButtonStateTypeQQ,
    RegisterButtonStateTypeWeixin,
    RegisterButtonStateTypeWeibo,
};


typedef void (^RegisterBlock) (RegisterButtonStateType stateType);

@interface RegisterView : UIView

@property (nonatomic, strong) UITextField *phoneNumberTF;

@property (nonatomic, strong) UITextField *verifyCodeTF;

@property (nonatomic, strong) UITextField *passwordTF;

@property (nonatomic, strong) UIButton *sendVerifyCodeButton;

@property (nonatomic, copy) RegisterBlock registerBlock;

- (instancetype)initWithFrame:(CGRect)frame registerBlock:(RegisterBlock)registerBlock;

@end
