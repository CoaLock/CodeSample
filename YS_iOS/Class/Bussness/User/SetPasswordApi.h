//
//  SetPasswordApi.h
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "BaseApi.h"

@interface SetPasswordApi : BaseApi

/**
 *   2.2.7 修改密码 (xiaocao.user.setPassword)
 */
- (void)setPasswordWithVerifyCode:(NSString*)verifyCode newPassword:(NSString*)newPassword callback:(ApiRequestCallBack)callback;


@end
