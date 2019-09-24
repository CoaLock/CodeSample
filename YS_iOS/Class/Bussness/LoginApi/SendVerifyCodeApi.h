//
//  SendVerifyCodeApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface SendVerifyCodeApi : BaseApi

/**
 *  2.2.11 发送验证码(xiaocao.user.sendVerifyCode)
 */
- (void)userSendVerifyCodeWithMobile:(NSString*)mobile callback:(ApiRequestCallBack)callback;

@end
