//
//  Check.h
//  BS
//
//  Created by 蔡卓越 on 16/4/20.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Check : NSObject
//验证手机号和验证码
+ (NSString *)checkMobileNum:(NSString *)mobileNum verifyCode:(NSString *)verifyCode;

+ (NSString *)checkOldPassword:(NSString *)oldPassword resetPassword:(NSString *)resetPassword repeatPassword:(NSString *)repeatPassword;

+ (NSString *)checkMobileNum:(NSString *)mobileNum verifyCode:(NSString *)verifyCode resetPassword:(NSString *)resetPassword;

+ (NSString *)checkCommentStr:(NSString *)commentStr itemScore:(NSInteger)itemScore footManScore:(NSInteger)footManScore;
//验证手机号
+ (NSString *)checkMobileNum:(NSString *)mobileNum;

//检查密码
+ (NSString *)checkPassword:(NSString *)password;

@end
