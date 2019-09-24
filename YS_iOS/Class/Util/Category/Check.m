//
//  Check.m
//  BS
//
//  Created by 蔡卓越 on 16/4/20.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "Check.h"

@implementation Check

//检查手机号和验证码
+ (NSString *)checkMobileNum:(NSString *)mobileNum verifyCode:(NSString *)verifyCode {
    
    return [self checkMobileNum:mobileNum verifyCode:verifyCode resetPassword:nil];
}

+ (NSString *)checkOldPassword:(NSString *)oldPassword resetPassword:(NSString *)resetPassword repeatPassword:(NSString *)repeatPassword {

    NSString *promptStr = @"";
    
    if (![resetPassword isEqualToString:repeatPassword]) {
        
        promptStr = @"新密码和重复密码不一致";
    }
    
    if (repeatPassword.length == 0) {
        
        promptStr = @"重复密码不能为空";
        
    }else if (repeatPassword.length != 6) {
    
//        promptStr = @"支付密码长度为6位";
    }
    
    if (resetPassword.length == 0) {
        
        promptStr = @"新密码不能为空";
        
    }else if (resetPassword.length != 6) {
    
//        promptStr = @"支付密码长度为6位";
    }
    
    if (oldPassword.length == 0) {
        
        promptStr = @"旧密码不能为空";
        
    }else if (oldPassword.length != 6) {
    
//        promptStr = @"支付密码长度为6位";
    }
    
    return promptStr;

}

+ (NSString *)checkMobileNum:(NSString *)mobileNum verifyCode:(NSString *)verifyCode resetPassword:(NSString *)resetPassword {

    NSString *promptStr = @"";
    
    if (resetPassword.length == 0) {
        
        promptStr = @"新密码不能为空";
        
    }else if (resetPassword.length != 6) {
    
//        promptStr = @"支付密码长度为6位";
    }
    
    if (verifyCode.length == 0) {
        
        promptStr = @"验证码不能为空";
        
    }else if (verifyCode.length != 6) {
        
        promptStr = @"请输入6位验证码";
    }
    
    if (mobileNum.length == 0) {
        
        promptStr = @"手机号不能为空";
        
    }else if (mobileNum.length != 11) {
        
        promptStr = @"请输入11位手机号";
        
    }else {
        
        //验证手机号码是否正确   手机号以13， 15，18 17 开头，八个 \d 数字字符
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        BOOL  isMobileNum = [phoneTest evaluateWithObject:mobileNum];
        if (!isMobileNum) {
            
            promptStr = @"手机号码不正确,请重新输入";
        }
        
    }
    
    return promptStr;
}

+ (NSString *)checkCommentStr:(NSString *)commentStr itemScore:(NSInteger)itemScore footManScore:(NSInteger)footManScore {
    NSString *str = @"";
    
    if (footManScore < 0) {
        
        str = @"请对配送员进行评分";
    }
    
    if (itemScore < 0) {
        
        str = @"请对商品进行评分";
    }
    
    if (footManScore <= 3 || itemScore <= 3) {
        
        if (commentStr.length < 5) {
            
            str = @"评论内容不小于五字";
        }
        if ([commentStr isEqualToString:@""]) {
            
            str = @"评论内容不能为空";
        }
    }
    
    
    return str;
}

+ (NSString *)checkMobileNum:(NSString *)mobileNum {

    NSString *promptStr = @"";
    
    if (mobileNum.length == 0) {
        
        promptStr = @"手机号不能为空";
        
    }else if (mobileNum.length != 11) {
        
        promptStr = @"请输入11位手机号码";
        
    }else {
        
        //验证手机号码是否正确   手机号以13， 15，18 17 开头，八个 \d 数字字符
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        BOOL  isMobileNum = [phoneTest evaluateWithObject:mobileNum];
        if (!isMobileNum) {
            
            promptStr = @"手机号码不正确,请重新输入";
        }
        
    }

    return promptStr;
}

+ (NSString *)checkPassword:(NSString *)password {

    NSString *promptStr = @"";
    
    if (password.length == 0) {
        
        promptStr = @"密码不能为空";
        
    }
    
    return promptStr;
}

@end
