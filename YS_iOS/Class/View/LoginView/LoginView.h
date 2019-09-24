//
//  LoginView.h
//  BS
//
//  Created by 蔡卓越 on 16/4/16.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonStateType) {

    ButtonStateTypeDismiss,
    ButtonStateTypeForgetPW,
    ButtonStateTypeLogin,
    ButtonStateTypeRegister,
    ButtonStateTypeQQ,
    ButtonStateTypeWeixin,
    ButtonStateTypeWeibo,
};

typedef void (^LoginBlock) (ButtonStateType stateType);

@interface LoginView : UIView

@property (nonatomic, strong) UITextField *userNameTF;
@property (nonatomic, strong) UITextField *passwordTF;

@property (nonatomic, copy) LoginBlock loginBlock;

- (instancetype)initWithFrame:(CGRect)frame loginBlock:(LoginBlock)loginBlock;

@end
